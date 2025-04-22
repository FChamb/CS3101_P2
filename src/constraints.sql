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


CREATE TRIGGER trg_finite_departure_differentials
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
  DECLARE next_loc_exists INT;

  SELECT COUNT(*) INTO next_loc_exists
  FROM plan
  WHERE frm = NEW.loc AND hc = NEW.hc;

  IF next_loc_exists > 0 AND (NEW.ddh = 99 OR NEW.ddm = 99) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Non-terminal locations must have finite departure differentials.';
  END IF;
END;
//


ALTER TABLE service
ADD CONSTRAINT unique_train_schedule
UNIQUE (uid, dh, dm);