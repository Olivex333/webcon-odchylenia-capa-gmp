/* 03_dane_testowe.sql – fikcyjne dane testowe (nazwy produktów i osób są wymyślone).
   Wyniki raportów w 04_raporty.sql opisano dla daty 20.11.2026. */

INSERT INTO dbo.Slownik_Linie (Kod, Nazwa, KierownikLogin) VALUES
    (N'L1', N'Linia syropów',          N'firma\k.nowak'),
    (N'L2', N'Linia tabletek',         N'firma\a.wisniewska'),
    (N'L3', N'Linia saszetek',         N'firma\m.kaczmarek'),
    (N'QC', N'Laboratorium kontroli jakości', N'firma\e.lewandowska');

INSERT INTO dbo.Slownik_Produkty (Nazwa, Postac) VALUES
    (N'Produkt testowy A 100 ml', N'syrop'),
    (N'Produkt testowy B 20 szt.', N'tabletki'),
    (N'Produkt testowy C 10 szt.', N'saszetki');

INSERT INTO dbo.Slownik_KategorieOdchylen (Nazwa) VALUES
    (N'Parametr procesu poza zakresem'),
    (N'Awaria lub nastawa urządzenia'),
    (N'Materiał / opakowanie'),
    (N'Dokumentacja serii'),
    (N'Środowisko (temperatura, wilgotność)');

INSERT INTO dbo.Slownik_PrzyczynyKategorie (Nazwa) VALUES
    (N'Człowiek'), (N'Metoda'), (N'Maszyna'), (N'Materiał'), (N'Pomiar'), (N'Środowisko');

INSERT INTO dbo.Rejestr_Odchylen
    (Sygnatura, DataZdarzenia, DataWykrycia, LiniaID, ProduktID, NumerSerii, KategoriaID,
     Klasyfikacja, StatusSerii, Krok, ProwadzacyDochodzenie, DataKlasyfikacji, TerminDochodzenia,
     PrzyczynaKategoriaID, OcenaSkutecznosci, DataZamkniecia)
VALUES
    (N'DEV/2026/0001', '2026-09-03T07:40', '2026-09-03T08:00', 1, 1, N'S2609-011', 4,
     N'Mniejsze',   N'Zwolniona',  N'Zamknięte',                 N'firma\j.lis',   '2026-09-04', '2026-10-04', 2, NULL,         '2026-09-20T08:00'),
    (N'DEV/2026/0002', '2026-09-15T09:30', '2026-09-15T10:00', 2, 2, N'T2609-044', 2,
     N'Poważne',    N'Wstrzymana', N'Zamknięte',                 N'firma\p.zajac', '2026-09-16', '2026-10-01', 3, N'Skuteczne', '2026-10-30T10:00'),
    (N'DEV/2026/0003', '2026-10-06T13:10', '2026-10-06T13:25', 2, 2, N'T2610-007', 2,
     N'Krytyczne',  N'Wstrzymana', N'Realizacja CAPA',           N'firma\p.zajac', '2026-10-06', '2026-10-13', 3, NULL,         NULL),
    (N'DEV/2026/0004', '2026-10-27T22:05', '2026-10-27T22:30', 1, 1, N'S2610-090', 1,
     N'Mniejsze',   N'Wstrzymana', N'Dochodzenie',               N'firma\r.mazur', '2026-10-28', '2026-11-27', NULL, NULL,       NULL),
    (N'DEV/2026/0005', '2026-11-04T11:00', '2026-11-04T11:15', 3, 3, N'Z2611-003', 3,
     N'Mniejsze',   N'Zwolniona',  N'Dochodzenie',               N'firma\j.lis',   '2026-11-05', '2026-12-05', NULL, NULL,       NULL),
    (N'DEV/2026/0006', '2026-11-18T06:50', '2026-11-18T07:05', 1, 1, N'S2611-061', 5,
     NULL,          NULL,          N'Klasyfikacja QA',           NULL,             NULL,         NULL,         NULL, NULL,       NULL);

INSERT INTO dbo.Rejestr_CAPA (OdchylenieID, Typ, Opis, Wlasciciel, Termin, Status, DataWykonania) VALUES
    (2, N'Korygujące',    N'Wymiana zużytego stempla w tabletkarce',               N'firma\ur.kowal',  '2026-10-05', N'Wykonane', '2026-10-03'),
    (2, N'Zapobiegawcze', N'Dodanie kontroli stempli do przeglądu tygodniowego',   N'firma\ur.kowal',  '2026-10-20', N'Wykonane', '2026-10-18'),
    (3, N'Korygujące',    N'Regulacja nastawy siły nacisku i ponowna kwalifikacja', N'firma\ur.kowal',  '2026-10-25', N'Wykonane', '2026-10-24'),
    (3, N'Zapobiegawcze', N'Monitoring siły nacisku z alarmem w systemie linii',   N'firma\it.nowicki','2026-11-15', N'Otwarte',  NULL);

/* Przykład śladu audytowego: QA podnosi klasyfikację DEV/2026/0004 z „Mniejsze” na „Poważne”,
   więc termin dochodzenia skraca się z 30 do 15 dni. Trigger zapisze dwie zmiany. */
UPDATE dbo.Rejestr_Odchylen
SET    Klasyfikacja      = N'Poważne',
       TerminDochodzenia = '2026-11-12'
WHERE  Sygnatura = N'DEV/2026/0004';
