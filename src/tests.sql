-- REPORT TESTS:
INSERT INTO plan (hc, frm, loc, ddh, ddm) VALUES ('1L27', 'EDB', 'HYM', 0, 5);
INSERT INTO stop (hc, frm, loc, adh, adm, pl) VALUES ('1L27', 'EDB', 'HYM', 0, 4, 2);
INSERT INTO stop (hc, frm, loc, adh, adm, pl) VALUES ('1L27', 'EDB', 'HYM', 19, 5, 2);


INSERT INTO plan (hc, frm, loc, ddh, ddm) VALUES ('1L27', 'HYM', 'DEE', 99, 99);
INSERT INTO plan (hc, frm, loc, ddh, ddm) VALUES ('1L27', 'EDB', 'HYM', 99, 99);


INSERT INTO service (hc, dh, dm, pl, uid, toc) VALUES ('1X99', 10, 30, 3, 170406, 'XC');
INSERT INTO service (hc, dh, dm, pl, uid, toc) VALUES ('1X98', 10, 30, 3, 170406, 'XC');


SELECT * FROM trainLEV;


SELECT * FROM scheduleEDB;


SELECT * FROM serviceEDBDEE;


CALL proc_new_service('EDB', 2, 14, 20, 170406, 'XC');
SELECT * FROM service WHERE uid = 170406 AND dh = 14 AND dm = 20;


CALL proc_add_loc('1L27', 'HYM', 'EDB', 0, 4, 0, 3, 2);
CALL proc_add_loc('1L27', 'ABC', 'HYM', 99, 99, NULL, NULL, NULL);
