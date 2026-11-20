# Ocena projektu: co ma sens, a co trzeba dopracować

## Co ma sens

- **Właściwy problem.** Odchylenia i CAPA to codzienna praca działu jakości w wytwórni leków i obszar często wskazywany przez inspektorów GMP. WEBCON jest stosowany właśnie do takich obiegów: kroki, akceptacje, terminy, przypomnienia, raporty.
- **Logika zgodna z praktyką.** Klasyfikacja wpływa na termin i wymagany zakres działań, krytyczne odchylenie wymusza wstrzymanie serii, kryterium skuteczności ustala się przed realizacją CAPA, a zatwierdzający nie może być prowadzącym dochodzenie.
- **Raporty, które QA naprawdę ogląda:** wiek otwartych odchyleń, dochodzenia po terminie, powtarzalność przyczyn, działania CAPA po terminie.

## Ograniczenia, o których trzeba powiedzieć

- **To projekt, nie wdrożenie.** Proces nie został jeszcze skonfigurowany w WEBCON Designer Studio.
- **Rejestr w osobnej bazie.** WEBCON przechowuje dane formularzy we własnej bazie. Tabela `Rejestr_Odchylen` to kopia na potrzeby raportów. W prawdziwym wdrożeniu raporty można budować bezpośrednio w WEBCON albo na widokach z jego bazy, a ślad audytowy zapewnia historia zmian elementu w WEBCON.
- **Brak walidacji systemu.** W środowisku GMP system wymaga walidacji (wymagania użytkownika, analiza ryzyka, testy). Scenariusze testowe to tylko zalążek.
- **SQL nieuruchomiony na SQL Server.** Składnię sprawdzono parserem, a oczekiwane wyniki przeliczono ręcznie na danych testowych.

## Co dalej

1. Zbudować obieg w WEBCON (wersja Express albo próbna) i dodać zrzuty ekranu.
2. Uruchomić skrypty w SQL Server Express i potwierdzić wyniki raportów.
3. Dodać powiązanie z procesem kontroli zmian (gdy działanie CAPA wymaga zmiany procesu lub dokumentu): repozytorium [`webcon-kontrola-zmian-gmp`](https://github.com/olivex333/webcon-kontrola-zmian-gmp).
