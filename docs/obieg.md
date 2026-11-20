# Obieg „Odchylenie GMP i CAPA”

## Kroki

| # | Krok | Kto | Ścieżki | Akcje i walidacje |
| --- | --- | --- | --- | --- |
| 1 | Rejestracja | zgłaszający | Zgłoś | sygnatura `DEV/{rok}/{numer}`; data wykrycia ≥ data zdarzenia; opis min. 30 znaków |
| 2 | Działania natychmiastowe | kierownik obszaru (z `Slownik_Linie.KierownikLogin`) | Przekaż do QA, Do uzupełnienia | wymagane: działania natychmiastowe i status serii |
| 3 | Klasyfikacja QA | grupa „QA” | Zdarzenie bez odchylenia, Mniejsze, Poważne / krytyczne | wyliczenie terminu dochodzenia; przy krytycznym: status serii = wstrzymana, e-mail do kierownika QA i produkcji |
| 4 | Dochodzenie | prowadzący dochodzenie | Plan CAPA gotowy, Mniejsze bez CAPA (tylko klasa „mniejsze”) | wymagane: 5 Why, kategoria przyczyny, ocena wpływu; dla CAPA min. 1 działanie i kryterium skuteczności |
| 5 | Zatwierdzenie planu CAPA | kierownik QA | Zatwierdź, Do poprawy | zatwierdzający ≠ prowadzący dochodzenie; ponowne uwierzytelnienie przy zatwierdzeniu |
| 6 | Realizacja CAPA | właściciele działań (zadania równoległe) | Wszystkie działania wykonane | walidacja: każde działanie ma status „wykonane” i datę |
| 7 | Ocena skuteczności | kierownik QA | Skuteczne, Nieskuteczne | oceniający ≠ prowadzący dochodzenie; komentarz wymagany przy „Nieskuteczne” |
| – | Zamknięte / Zamknięte jako zdarzenie | – | – | zapis daty zamknięcia; e-mail do zgłaszającego |

## Akcje automatyczne

- Przy każdym przejściu ścieżki: zapis do `dbo.Rejestr_Odchylen` (komenda SQL) na potrzeby raportów.
- Codziennie o 7:00: przypomnienia o terminach dochodzeń i działań CAPA.
- Przy kroku 4: zapytanie o powtórzenia tej samej kategorii przyczyny na linii w 90 dniach (reguła 7).

## Uprawnienia

- Zgłaszający widzi swoje odchylenia i nie edytuje ich po wysłaniu.
- Kierownik obszaru widzi odchylenia ze swoich linii.
- QA widzi wszystko; edycja klasyfikacji tylko na kroku 3.
- Administrator nie zmienia danych w zamkniętych odchyleniach (zmiany wyłącznie przez nowe odchylenie lub korektę z uzasadnieniem w śladzie audytowym).
