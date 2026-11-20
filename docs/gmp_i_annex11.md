# GMP i Aneks 11 w tym projekcie

Systemy komputerowe używane w działalności GMP podlegają Aneksowi 11 do wytycznych GMP UE (EudraLex, tom 4). Poniżej, jak projekt odpowiada na wybrane wymagania. To mapa projektowa, nie dokumentacja walidacyjna.

| Wymaganie | Jak to wygląda w projekcie |
| --- | --- |
| Ślad audytowy zmian i usunięć danych istotnych dla GMP | tabela `dbo.Audit_Odchylenia` i trigger zapisujący kto, kiedy, stara i nowa wartość, powód (sql/02); WEBCON ma też własną historię zmian elementu, którą trzeba włączyć i przeglądać |
| Podpis elektroniczny przy zatwierdzeniach | kroki 5 i 7: zatwierdzenie z ponownym uwierzytelnieniem użytkownika i zapisem znacznika czasu; do potwierdzenia, jak realizuje to konkretna wersja WEBCON |
| Kontrola dostępu | uprawnienia oparte na rolach (docs/obieg.md), brak edycji po zamknięciu |
| Kontrole poprawności danych | walidacje dat, wymagane pola na krokach, słowniki zamiast wpisów ręcznych |
| Wydruki | szablon raportu z odchylenia zawiera numer, wersję danych i podpisy (templates/) |

## ALCOA+ w skrócie

Dane muszą być przypisywalne (kto), czytelne, utworzone w czasie zdarzenia, oryginalne i dokładne, a także kompletne, spójne, trwałe i dostępne. W projekcie: autor i znacznik czasu przy każdej zmianie, słowniki zamiast wolnego tekstu tam, gdzie się da, brak usuwania rekordów.

## Czego ten projekt nie robi

- Nie jest zwalidowany (brak specyfikacji wymagań użytkownika, analizy ryzyka, testów kwalifikacyjnych IQ/OQ/PQ).
- Nie obsługuje zwolnienia serii przez Osobę Wykwalifikowaną. To osobny proces, tutaj jest tylko status serii.
