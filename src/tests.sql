-- Create a service:
CALL proc_new_service('Edinburgh', 1, '09:30:00', 170406, 'VT');

-- Check it exists:
SELECT * FROM service;
SELECT * FROM route;

-- Add locations to route:
CALL proc_add_loc('1L27', 'Haymarket', 'Edinburgh', 0, 5, 0, 4, 2);
CALL proc_add_loc('1L27', 'Linlithgow', 'Haymarket', 0, 18, 0, 23, 1);

-- Insert in middle of route:
CALL proc_add_loc('1L27', 'Dunfermline', 'Haymarket', 0, 9, 0, 13, 2);

-- Check insert worked:
SELECT * FROM plan WHERE hc = '1L27';

-- Fix the differential with update:
CALL proc_update_diff('1L27', 'Dunfermline', 'Linlithgow', 0, 7);

-- Check final route and stop times:
SELECT * FROM stop WHERE hc = '1L27';
SELECT * FROM plan WHERE hc = '1L27';


-- REPORT TESTS:
-- Should fail: arrival later than departure
INSERT INTO stop (hc, frm, loc, adh, adm, pl) VALUES ('1L27', 'Edinburgh', 'Haymarket', 10, 45, 2);

-- Should pass: arrival earlier than departure
INSERT INTO stop (hc, frm, loc, adh, adm, pl) VALUES ('1L27', 'Edinburgh', 'Haymarket', 10, 15, 2);
