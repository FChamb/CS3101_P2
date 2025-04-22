C1:
DELIMITER //
CREATE TRIGGER trg_check_arrival_before_departure
BEFORE INSERT ON stop
FOR EACH ROW
BEGIN
  DECLARE arr_time INT;
  DECLARE dep_time INT;

  SET arr_time = NEW.adh * 100 + NEW.adm;
  SET dep_time = NEW.adh * 100 + NEW.adm;

  IF NEW.adh IS NOT NULL AND NEW.adm IS NOT NULL THEN
    SET arr_time = NEW.adh * 100 + NEW.adm;
  END IF;

  IF arr_time > (NEW.adh * 100 + NEW.adm) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Arrival time cannot be after departure time.';
  END IF;
END;
//
DELIMITER ;

C2:
DELIMITER //
CREATE TRIGGER trg_finite_departure_differentials
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
  DECLARE next_loc_exists INT;

  SELECT COUNT(*) INTO next_loc_exists
  FROM plan
  WHERE frm = NEW.loc AND hc = NEW.hc;

  IF next_loc_exists > 0 AND (NEW.ddh = NULL OR NEW.ddm = NULL) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Non-terminal locations must have finite departure differentials.';
  END IF;
END;
//
DELIMITER ;

C3:
ALTER TABLE service
ADD CONSTRAINT unique_train_schedule
UNIQUE (uid, dh, dm);

Q1:
DELIMITER //
CREATE OR REPLACE VIEW trainLEV AS
SELECT
  s.hc,
  r.orig AS orig,
  LPAD(s.dh, 2, '0') * 100 + LPAD(s.dm, 2, '0') AS dep
FROM service s
JOIN route r ON s.hc = r.hc
WHERE s.uid = 170406
ORDER BY dep;
//
DELIMITER ;

Q2:
DELIMITER //
CREATE OR REPLACE VIEW scheduleEDB AS
SELECT
  s.hc,
  LPAD(s.dh, 2, '0') * 100 + LPAD(s.dm, 2, '0') AS dep,
  s.pl,
  (
    SELECT p2.loc
    FROM plan p2
    WHERE p2.hc = s.hc AND (p2.ddh = 99 OR p2.ddm = 99)
    LIMIT 1
  ) AS dest,
  COUNT(c.lid) AS len,
  s.toc
FROM service s
JOIN train t ON s.uid = t.uid
JOIN coach c ON t.uid = c.uid
JOIN route r ON s.hc = r.hc
WHERE r.orig = 'EDB'
GROUP BY s.hc, s.dh, s.dm, s.pl, s.toc
ORDER BY dep;
//
DELIMITER ;

Q3:
DELIMITER //
CREATE OR REPLACE VIEW serviceEDBDEE AS
SELECT
  p.loc,
  s.code AS stn,
  st.pl,
  st.adh * 100 + st.adm AS arr,
  CASE
    WHEN p.ddh = 99 OR p.ddm = 99 THEN NULL
    ELSE (p.ddh * 100 + p.ddm)
  END AS dep
FROM service sv
JOIN plan p ON sv.hc = p.hc
LEFT JOIN stop st ON p.hc = st.hc AND p.loc = st.loc
LEFT JOIN station s ON p.loc = s.loc
WHERE sv.hc = '1L27' AND sv.dh = 18 AND sv.dm = 59
ORDER BY p.frm;
//
DELIMITER ;

P1:
DELIMITER //
CREATE PROCEDURE proc_new_service(
  IN in_orig CHAR(3),
  IN in_platform INT,
  IN in_hour INT,
  IN in_minute INT,
  IN in_uid INT,
  IN in_toc CHAR(2)
)
BEGIN
  DECLARE new_hc CHAR(4);
  DECLARE counter INT;

  SELECT COUNT(*) INTO counter FROM route;
  SET new_hc = CONCAT('1', 'A', LPAD(counter + 1, 2, '0'));

  INSERT INTO route (hc, orig)
  VALUES (new_hc, in_orig);

  INSERT INTO service (hc, dh, dm, pl, uid, toc)
  VALUES (new_hc, in_hour, in_minute, in_platform, in_uid, in_toc);
END;
//
DELIMITER ;

P2:
DELIMITER //
CREATE PROCEDURE proc_add_loc(
  IN in_hc CHAR(4),
  IN in_loc VARCHAR(255),
  IN in_prev VARCHAR(255),
  IN in_ddh INT,
  IN in_adh INT,
  IN in_pl INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM location WHERE loc = in_loc) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Location does not exist';
  END IF;

  INSERT INTO plan (hc, frm, loc, ddh, ddm)
  VALUES (in_hc, in_prev, in_loc, in_ddh, 0);

  IF in_adh IS NOT NULL AND in_pl IS NOT NULL THEN
    INSERT INTO stop (hc, frm, loc, adh, adm, pl)
    VALUES (in_hc, in_prev, in_loc, in_adh, 0, in_pl);
  END IF;
END;
//
DELIMITER ;