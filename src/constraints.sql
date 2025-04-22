C1:
DELIMITER //
CREATE TRIGGER trg_stop_arrival_check
BEFORE INSERT ON stop
FOR EACH ROW
BEGIN
    IF NEW.adh * 60 + NEW.adm > (SELECT dh * 60 + dm FROM service WHERE hc = NEW.hc) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Arrival time cannot be after departure time';
    END IF;
END;
//
DELIMITER ;


C2:
DELIMITER //
CREATE TRIGGER trg_departure_diff_constraint
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
    DECLARE is_destination BOOLEAN;
    SET is_destination = NOT EXISTS (
        SELECT 1 FROM plan WHERE hc = NEW.hc AND frm = NEW.loc
    );

    IF NOT is_destination AND (NEW.ddh IS NULL OR NEW.ddm IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non-terminal locations must have finite departure differential';
    END IF;
END;
//
DELIMITER ;

C3:
DELIMITER //
CREATE TRIGGER trg_train_service_unique
BEFORE INSERT ON service
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM service
        WHERE uid = NEW.uid AND dh = NEW.dh AND dm = NEW.dm
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Train already used at that time';
    END IF;
END;
//
DELIMITER ;

Q1:
DELIMITER //
CREATE VIEW trainLEV AS
SELECT s.hc, r.orig AS orig, CONCAT(s.dh, LPAD(s.dm, 2, '0')) AS dep
FROM service s
JOIN route r ON s.hc = r.hc
WHERE s.uid = 170406
ORDER BY s.dh, s.dm;
//
DELIMITER ;

Q2:
DELIMITER //
CREATE VIEW scheduleEDB AS
SELECT s.hc, CONCAT(s.dh, LPAD(s.dm, 2, '0')) AS dep, s.pl,
       (SELECT p.loc FROM plan p WHERE p.hc = s.hc AND p.ddh = 'ω') AS dest,
       (SELECT COUNT(*) FROM coach WHERE uid = s.uid) AS len,
       s.toc
FROM service s
JOIN route r ON s.hc = r.hc
WHERE r.orig = 'Edinburgh'
ORDER BY s.dh, s.dm;
//
DELIMITER ;

Q3:
DELIMITER //
CREATE VIEW serviceEDBDEE AS
SELECT p.loc, st.code AS stn, stp.pl,
       CONCAT(s.dh + p.ddh, LPAD(s.dm + p.ddm, 2, '0')) AS arr,
       CONCAT(s.dh + p.ddh, LPAD(s.dm + p.ddm + 1, 2, '0')) AS dep
FROM plan p
JOIN service s ON s.hc = p.hc
LEFT JOIN stop stp ON stp.hc = p.hc AND stp.loc = p.loc
LEFT JOIN station st ON st.loc = p.loc
WHERE s.hc = '1L27' AND s.dh = 18 AND s.dm = 59
ORDER BY p.ddh, p.ddm;
//
DELIMITER ;

P1:
DELIMITER //
CREATE PROCEDURE proc_new_service(
    IN origin_station VARCHAR(255),
    IN origin_platform INT,
    IN dep_time TIME,
    IN train_id INT,
    IN toc_code VARCHAR(5)
)
BEGIN
    DECLARE new_hc CHAR(4);
    DECLARE try_count INT DEFAULT 0;
    DECLARE exists_check INT;

    -- Check if origin station exists
    IF NOT EXISTS (SELECT 1 FROM station WHERE loc = origin_station) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Origin station does not exist';
    END IF;

    -- Check if train exists
    IF NOT EXISTS (SELECT 1 FROM train WHERE uid = train_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Train ID does not exist';
    END IF;

    -- Check if train already used at that time
    IF EXISTS (
        SELECT 1 FROM service
        WHERE uid = train_id AND dh = HOUR(dep_time) AND dm = MINUTE(dep_time)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Train already scheduled at that time';
    END IF;

    -- Generate unique headcode (max 10 attempts)
    REPEAT
        SET new_hc = CONCAT('1', CHAR(FLOOR(RAND() * 26) + 65), LPAD(FLOOR(RAND() * 100), 2, '0'));
        SELECT COUNT(*) INTO exists_check FROM route WHERE hc = new_hc;
        SET try_count = try_count + 1;
    UNTIL exists_check = 0 OR try_count >= 10 END REPEAT;

    IF exists_check > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to generate unique headcode';
    END IF;

    -- Insert route and service
    INSERT INTO route(hc, orig) VALUES(new_hc, origin_station);
    INSERT INTO service(hc, dh, dm, pl, uid, toc)
    VALUES(new_hc, HOUR(dep_time), MINUTE(dep_time), origin_platform, train_id, toc_code);
END;
//
DELIMITER ;

P2:
DELIMITER //
CREATE PROCEDURE proc_add_loc(
    IN route_hc CHAR(4),
    IN loc_name VARCHAR(255),
    IN prev_loc VARCHAR(255),
    IN ddh INT,
    IN ddm INT,
    IN adh INT,
    IN adm INT,
    IN platform INT
)
BEGIN
    DECLARE next_loc VARCHAR(255);

    IF NOT EXISTS (SELECT 1 FROM route WHERE hc = route_hc) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Route headcode does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM location WHERE loc = loc_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location to add does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM plan WHERE hc = route_hc AND loc = prev_loc) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Preceding location does not exist in route';
    END IF;

    IF EXISTS (SELECT 1 FROM plan WHERE hc = route_hc AND loc = loc_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location already exists in route';
    END IF;

    SELECT loc INTO next_loc
    FROM plan
    WHERE hc = route_hc AND frm = prev_loc
    LIMIT 1;

    IF next_loc IS NULL THEN
        INSERT INTO plan(hc, frm, loc, ddh, ddm)
        VALUES(route_hc, prev_loc, loc_name, ddh, ddm);
    ELSE
        DELETE FROM plan WHERE hc = route_hc AND frm = prev_loc AND loc = next_loc;
        INSERT INTO plan(hc, frm, loc, ddh, ddm)
        VALUES(route_hc, prev_loc, loc_name, ddh, ddm);
        INSERT INTO plan(hc, frm, loc, ddh, ddm)
        VALUES(route_hc, loc_name, next_loc, 0, 0);
    END IF;

    IF adh IS NOT NULL AND adm IS NOT NULL AND platform IS NOT NULL THEN
        INSERT INTO stop(hc, frm, loc, adh, adm, pl)
        VALUES(route_hc, prev_loc, loc_name, adh, adm, platform);
    ELSEIF adh IS NOT NULL OR adm IS NOT NULL OR platform IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'All or none of adh, adm, pl must be provided';
    END IF;
END;
//
DELIMITER ;


To Update DIFF and Arrival Times:
DELIMITER //
CREATE PROCEDURE proc_update_diff(
    IN route_hc CHAR(4),
    IN from_loc VARCHAR(255),
    IN to_loc VARCHAR(255),
    IN new_ddh INT,
    IN new_ddm INT
)
BEGIN
    DECLARE origin_loc VARCHAR(255);
    DECLARE orig_hour INT;
    DECLARE orig_min INT;
    DECLARE cumulative_minutes INT DEFAULT 0;
    DECLARE this_ddh INT;
    DECLARE this_ddm INT;

    IF NOT EXISTS (
        SELECT 1 FROM plan
        WHERE hc = route_hc AND frm = from_loc AND loc = to_loc
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Plan entry does not exist';
    END IF;

    UPDATE plan
    SET ddh = new_ddh, ddm = new_ddm
    WHERE hc = route_hc AND frm = from_loc AND loc = to_loc;

    SELECT r.orig INTO origin_loc FROM route r WHERE r.hc = route_hc;
    SELECT dh, dm INTO orig_hour, orig_min FROM service WHERE hc = route_hc;

    DROP TEMPORARY TABLE IF EXISTS tmp_plan_walk;
    CREATE TEMPORARY TABLE tmp_plan_walk (
        frm VARCHAR(255), loc VARCHAR(255), ddh INT, ddm INT, total_minutes INT
    );

    INSERT INTO tmp_plan_walk
    SELECT frm, loc, ddh, ddm, ddh * 60 + ddm
    FROM plan
    WHERE hc = route_hc AND frm = origin_loc;

    WHILE EXISTS (
        SELECT 1 FROM plan p
        JOIN tmp_plan_walk t ON p.frm = t.loc
        WHERE p.hc = route_hc
        AND NOT EXISTS (
            SELECT 1 FROM tmp_plan_walk WHERE frm = p.frm AND loc = p.loc
        )
    ) DO
        INSERT INTO tmp_plan_walk
        SELECT p.frm, p.loc, p.ddh, p.ddm,
               t.total_minutes + p.ddh * 60 + p.ddm
        FROM plan p
        JOIN tmp_plan_walk t ON p.frm = t.loc
        WHERE p.hc = route_hc
        AND NOT EXISTS (
            SELECT 1 FROM tmp_plan_walk WHERE frm = p.frm AND loc = p.loc
        );
    END WHILE;

    SELECT total_minutes INTO cumulative_minutes
    FROM tmp_plan_walk
    WHERE loc = to_loc;

    SET cumulative_minutes = cumulative_minutes + orig_hour * 60 + orig_min;
    SET this_ddh = FLOOR(cumulative_minutes / 60);
    SET this_ddm = MOD(cumulative_minutes, 60);

    IF EXISTS (SELECT 1 FROM stop WHERE hc = route_hc AND loc = to_loc) THEN
        UPDATE stop
        SET adh = this_ddh, adm = this_ddm
        WHERE hc = route_hc AND loc = to_loc;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_plan_walk;
END;
//
DELIMITER ;