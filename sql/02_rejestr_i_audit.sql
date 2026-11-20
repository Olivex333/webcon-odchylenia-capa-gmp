/* =========================================================
   02_rejestr_i_audit.sql
   Rejestr odchyleń i działań CAPA na potrzeby raportów
   (kopia kluczowych pól zapisywana z obiegu WEBCON komendą SQL)
   oraz ślad audytowy zmian istotnych dla GMP.
   ========================================================= */

CREATE TABLE dbo.Rejestr_Odchylen (
    OdchylenieID          INT IDENTITY(1,1) PRIMARY KEY,
    Sygnatura             NVARCHAR(30)  NOT NULL UNIQUE,
    DataZdarzenia         DATETIME2     NOT NULL,
    DataWykrycia          DATETIME2     NOT NULL,
    LiniaID               INT           NOT NULL REFERENCES dbo.Slownik_Linie(LiniaID),
    ProduktID             INT           NULL     REFERENCES dbo.Slownik_Produkty(ProduktID),
    NumerSerii            NVARCHAR(30)  NULL,
    KategoriaID           INT           NOT NULL REFERENCES dbo.Slownik_KategorieOdchylen(KategoriaID),
    Klasyfikacja          NVARCHAR(20)  NULL
        CHECK (Klasyfikacja IN (N'Zdarzenie', N'Mniejsze', N'Poważne', N'Krytyczne')),
    StatusSerii           NVARCHAR(20)  NULL
        CHECK (StatusSerii IN (N'Zwolniona', N'Wstrzymana')),
    Krok                  NVARCHAR(50)  NOT NULL,
    ProwadzacyDochodzenie NVARCHAR(100) NULL,
    DataKlasyfikacji      DATE          NULL,
    TerminDochodzenia     DATE          NULL,
    PrzyczynaKategoriaID  INT           NULL REFERENCES dbo.Slownik_PrzyczynyKategorie(PrzyczynaKategoriaID),
    OcenaSkutecznosci     NVARCHAR(20)  NULL
        CHECK (OcenaSkutecznosci IN (N'Skuteczne', N'Nieskuteczne')),
    DataZamkniecia        DATETIME2     NULL,
    CONSTRAINT CK_Wykrycie CHECK (DataWykrycia >= DataZdarzenia),
    /* reguła 3: krytyczne odchylenie wymaga wstrzymania serii */
    CONSTRAINT CK_KrytyczneWstrzymana CHECK (Klasyfikacja IS NULL OR Klasyfikacja <> N'Krytyczne' OR StatusSerii = N'Wstrzymana')
);

CREATE TABLE dbo.Rejestr_CAPA (
    CapaID          INT IDENTITY(1,1) PRIMARY KEY,
    OdchylenieID    INT           NOT NULL REFERENCES dbo.Rejestr_Odchylen(OdchylenieID),
    Typ             NVARCHAR(20)  NOT NULL CHECK (Typ IN (N'Korygujące', N'Zapobiegawcze')),
    Opis            NVARCHAR(400) NOT NULL,
    Wlasciciel      NVARCHAR(100) NOT NULL,
    Termin          DATE          NOT NULL,
    Status          NVARCHAR(20)  NOT NULL DEFAULT N'Otwarte' CHECK (Status IN (N'Otwarte', N'Wykonane')),
    DataWykonania   DATE          NULL,
    CONSTRAINT CK_Wykonane CHECK (Status = N'Otwarte' OR DataWykonania IS NOT NULL)
);

/* Ślad audytowy: kto, kiedy, co zmienił (stara i nowa wartość) */
CREATE TABLE dbo.Audit_Odchylenia (
    AuditID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    OdchylenieID   INT           NOT NULL,
    Pole           NVARCHAR(50)  NOT NULL,
    StaraWartosc   NVARCHAR(200) NULL,
    NowaWartosc    NVARCHAR(200) NULL,
    ZmienilLogin   NVARCHAR(128) NOT NULL DEFAULT SUSER_SNAME(),
    DataZmiany     DATETIME2     NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TRIGGER dbo.trg_Odchylenia_Audit
ON dbo.Rejestr_Odchylen
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Audit_Odchylenia (OdchylenieID, Pole, StaraWartosc, NowaWartosc)
    SELECT i.OdchylenieID, v.Pole, v.Stara, v.Nowa
    FROM inserted i
    JOIN deleted d ON d.OdchylenieID = i.OdchylenieID
    CROSS APPLY (VALUES
        (N'Klasyfikacja',      d.Klasyfikacja,                         i.Klasyfikacja),
        (N'StatusSerii',       d.StatusSerii,                          i.StatusSerii),
        (N'Krok',              d.Krok,                                 i.Krok),
        (N'TerminDochodzenia', CONVERT(NVARCHAR(10), d.TerminDochodzenia, 23), CONVERT(NVARCHAR(10), i.TerminDochodzenia, 23)),
        (N'OcenaSkutecznosci', d.OcenaSkutecznosci,                    i.OcenaSkutecznosci)
    ) AS v(Pole, Stara, Nowa)
    WHERE ISNULL(v.Stara, N'') <> ISNULL(v.Nowa, N'');
END;
GO

/* Rekordów odchyleń się nie usuwa (trwałość danych) */
CREATE TRIGGER dbo.trg_Odchylenia_BezUsuwania
ON dbo.Rejestr_Odchylen
INSTEAD OF DELETE
AS
BEGIN
    THROW 50001, N'Odchyleń nie usuwa się. Zamknij odchylenie z uzasadnieniem.', 1;
END;
GO
