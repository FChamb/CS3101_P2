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