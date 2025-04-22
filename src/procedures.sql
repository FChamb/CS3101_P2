DELIMITER //
CREATE PROCEDURE proc_new_service(
  IN in_orig CHAR(3),
  IN in_pl INT,
  IN in_dh INT,
  IN in_dm INT,
  IN in_uid INT,
  IN in_toc CHAR(2)
)
BEGIN
  DECLARE new_hc CHAR(4);
  DECLARE suffix INT DEFAULT 1;
  DECLARE code CHAR(4);
  DECLARE exists_check INT DEFAULT 1;

  IF NOT EXISTS (SELECT 1 FROM station WHERE code = in_orig) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid origin station.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM train WHERE uid = in_uid) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Train does not exist.';
  END IF;

  WHILE exists_check = 1 DO
    SET code = CONCAT('1A', LPAD(suffix, 2, '0'));
    SELECT COUNT(*) INTO exists_check FROM route WHERE hc = code;
    SET suffix = suffix + 1;
  END WHILE;

  SET new_hc = code;

  INSERT INTO route(hc, orig) VALUES (new_hc, in_orig);
  INSERT INTO service(hc, dh, dm, pl, uid, toc) VALUES (new_hc, in_dh, in_dm, in_pl, in_uid, in_toc);
END;
//


CREATE PROCEDURE proc_add_loc(
  IN in_hc CHAR(4),
  IN in_loc VARCHAR(255),
  IN in_prev VARCHAR(255),
  IN in_ddh INT,
  IN in_ddm INT,
  IN in_adh INT,
  IN in_adm INT,
  IN in_pl INT
)
BEGIN
  DECLARE is_stop BOOLEAN;

  IF NOT EXISTS (SELECT 1 FROM location WHERE loc = in_loc) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Location does not exist.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM route WHERE hc = in_hc) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Route does not exist.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM plan WHERE hc = in_hc AND loc = in_prev) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Previous location not found on route.';
  END IF;

  IF (in_ddh = 99 OR in_ddm = 99) THEN
    IF EXISTS (SELECT 1 FROM plan WHERE hc = in_hc AND frm = in_loc) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot append terminal location mid-route.';
    END IF;
  ELSE
    IF in_ddh NOT BETWEEN 0 AND 23 OR in_ddm NOT BETWEEN 0 AND 59 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invalid departure differential.';
    END IF;
  END IF;

  INSERT INTO plan(hc, frm, loc, ddh, ddm)
  VALUES (in_hc, in_prev, in_loc, in_ddh, in_ddm);

  SET is_stop = in_adh IS NOT NULL AND in_adm IS NOT NULL AND in_pl IS NOT NULL;

  IF is_stop THEN
    INSERT INTO stop(hc, frm, loc, adh, adm, pl)
    VALUES (in_hc, in_prev, in_loc, in_adh, in_adm, in_pl);
  END IF;
END;
//
DELIMITER ;