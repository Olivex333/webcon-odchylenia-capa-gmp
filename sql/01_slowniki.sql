/* =========================================================
   WEBCON BPS – Odchylenia GMP i CAPA
   01_slowniki.sql – słowniki pod pola wyboru (źródła danych SQL)
   Microsoft SQL Server (T-SQL)
   ========================================================= */

CREATE TABLE dbo.Slownik_Linie (
    LiniaID        INT IDENTITY(1,1) PRIMARY KEY,
    Kod            NVARCHAR(10)  NOT NULL UNIQUE,
    Nazwa          NVARCHAR(100) NOT NULL,
    KierownikLogin NVARCHAR(100) NOT NULL,      -- przypisanie kroku 2
    Aktywna        BIT           NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Slownik_Produkty (
    ProduktID      INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa          NVARCHAR(150) NOT NULL,
    Postac         NVARCHAR(50)  NOT NULL,      -- syrop, tabletki, saszetki...
    Aktywny        BIT           NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Slownik_KategorieOdchylen (
    KategoriaID    INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa          NVARCHAR(100) NOT NULL,
    Aktywna        BIT           NOT NULL DEFAULT 1
);

/* Kategorie przyczyn wg diagramu Ishikawy (6M) – podstawa analizy trendów */
CREATE TABLE dbo.Slownik_PrzyczynyKategorie (
    PrzyczynaKategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nazwa          NVARCHAR(50)  NOT NULL UNIQUE
);

GO
CREATE VIEW dbo.vw_Wybor_Linie AS
    SELECT LiniaID AS ID, Kod + N' – ' + Nazwa AS Nazwa
    FROM dbo.Slownik_Linie
    WHERE Aktywna = 1;
GO
CREATE VIEW dbo.vw_Wybor_Produkty AS
    SELECT ProduktID AS ID, Nazwa + N' (' + Postac + N')' AS Nazwa
    FROM dbo.Slownik_Produkty
    WHERE Aktywny = 1;
GO
