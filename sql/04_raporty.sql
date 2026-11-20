/* =========================================================
   04_raporty.sql – raporty i KPI (T-SQL)
   Oczekiwane wyniki podano dla danych z 03_dane_testowe.sql
   i daty 20.11.2026 (zamiast GETDATE() można podstawić @Dzis).
   ========================================================= */

DECLARE @Dzis DATE = CAST(GETDATE() AS DATE);

/* 1. Otwarte odchylenia według klasyfikacji i wieku
      oczekiwane: Krytyczne / ponad 30 dni = 1; Poważne / 16–30 = 1;
                  Mniejsze / 16–30 = 1; (nieklasyfikowane) / 0–15 = 1 */
SELECT  ISNULL(o.Klasyfikacja, N'(nieklasyfikowane)') AS Klasyfikacja,
        CASE WHEN DATEDIFF(DAY, o.DataWykrycia, @Dzis) <= 15 THEN N'0–15 dni'
             WHEN DATEDIFF(DAY, o.DataWykrycia, @Dzis) <= 30 THEN N'16–30 dni'
             ELSE N'ponad 30 dni' END             AS Wiek,
        COUNT(*)                                   AS Liczba
FROM    dbo.Rejestr_Odchylen o
WHERE   o.DataZamkniecia IS NULL
GROUP BY ISNULL(o.Klasyfikacja, N'(nieklasyfikowane)'),
         CASE WHEN DATEDIFF(DAY, o.DataWykrycia, @Dzis) <= 15 THEN N'0–15 dni'
              WHEN DATEDIFF(DAY, o.DataWykrycia, @Dzis) <= 30 THEN N'16–30 dni'
              ELSE N'ponad 30 dni' END
ORDER BY Klasyfikacja, Wiek;

/* 2. Dochodzenia po terminie
      oczekiwane: DEV/2026/0004, r.mazur, 8 dni */
SELECT  o.Sygnatura,
        l.Kod                                         AS Linia,
        o.Klasyfikacja,
        o.ProwadzacyDochodzenie,
        o.TerminDochodzenia,
        DATEDIFF(DAY, o.TerminDochodzenia, @Dzis)     AS DniPoTerminie
FROM    dbo.Rejestr_Odchylen o
JOIN    dbo.Slownik_Linie l ON l.LiniaID = o.LiniaID
WHERE   o.Krok = N'Dochodzenie'
  AND   o.TerminDochodzenia < @Dzis
ORDER BY DniPoTerminie DESC;

/* 3. Trend przyczyn (reguła 7): ta sama kategoria przyczyny na tej samej linii
      co najmniej 2 razy w ostatnich 90 dniach
      oczekiwane: L2 / Maszyna / 2 (DEV/2026/0002, DEV/2026/0003) */
SELECT  l.Kod                       AS Linia,
        p.Nazwa                     AS KategoriaPrzyczyny,
        COUNT(*)                    AS Wystapienia,
        STRING_AGG(o.Sygnatura, N', ') WITHIN GROUP (ORDER BY o.Sygnatura) AS Odchylenia
FROM    dbo.Rejestr_Odchylen o
JOIN    dbo.Slownik_Linie l              ON l.LiniaID = o.LiniaID
JOIN    dbo.Slownik_PrzyczynyKategorie p ON p.PrzyczynaKategoriaID = o.PrzyczynaKategoriaID
WHERE   o.DataWykrycia >= DATEADD(DAY, -90, @Dzis)
GROUP BY l.Kod, p.Nazwa
HAVING  COUNT(*) >= 2
ORDER BY Wystapienia DESC;

/* 4. Działania CAPA po terminie
      oczekiwane: DEV/2026/0003, monitoring siły nacisku, it.nowicki, 5 dni */
SELECT  o.Sygnatura,
        c.Typ,
        c.Opis,
        c.Wlasciciel,
        c.Termin,
        DATEDIFF(DAY, c.Termin, @Dzis) AS DniPoTerminie
FROM    dbo.Rejestr_CAPA c
JOIN    dbo.Rejestr_Odchylen o ON o.OdchylenieID = c.OdchylenieID
WHERE   c.Status = N'Otwarte'
  AND   c.Termin < @Dzis
ORDER BY DniPoTerminie DESC;

/* 5. Średni czas od wykrycia do zamknięcia [dni] według klasyfikacji
      oczekiwane: Mniejsze 17,0; Poważne 45,0 */
SELECT  o.Klasyfikacja,
        COUNT(*) AS Zamkniete,
        CAST(AVG(DATEDIFF(HOUR, o.DataWykrycia, o.DataZamkniecia) / 24.0) AS DECIMAL(6,1)) AS SrDni
FROM    dbo.Rejestr_Odchylen o
WHERE   o.DataZamkniecia IS NOT NULL
  AND   o.Klasyfikacja <> N'Zdarzenie'
GROUP BY o.Klasyfikacja
ORDER BY SrDni;

/* 6. Termin dochodzenia z klasyfikacji (reguła 1) – ta sama logika co reguła w WEBCON */
SELECT  o.Sygnatura,
        o.Klasyfikacja,
        DATEADD(DAY,
                CASE o.Klasyfikacja WHEN N'Krytyczne' THEN 7
                                    WHEN N'Poważne'   THEN 15
                                    ELSE 30 END,
                ISNULL(o.DataKlasyfikacji, @Dzis)) AS TerminDochodzenia
FROM    dbo.Rejestr_Odchylen o
WHERE   o.Klasyfikacja IS NOT NULL;

/* 7. Ślad audytowy wybranego odchylenia */
SELECT  a.DataZmiany, a.ZmienilLogin, a.Pole, a.StaraWartosc, a.NowaWartosc
FROM    dbo.Audit_Odchylenia a
JOIN    dbo.Rejestr_Odchylen o ON o.OdchylenieID = a.OdchylenieID
WHERE   o.Sygnatura = N'DEV/2026/0004'
ORDER BY a.DataZmiany;
