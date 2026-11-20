# Scenariusze testowe – odchylenia GMP i CAPA

| ID | Scenariusz | Kroki | Oczekiwany wynik |
| --- | --- | --- | --- |
| T01 | Ścieżka pełna, odchylenie poważne | rejestracja → działania natychmiastowe → klasyfikacja „Poważne” → dochodzenie z planem CAPA → zatwierdzenie → realizacja → „Skuteczne” | status „Zamknięte”, termin dochodzenia = data klasyfikacji + 15 dni, wpisy w śladzie audytowym na każdym kroku |
| T02 | Mniejsze bez CAPA | klasyfikacja „Mniejsze”, w dochodzeniu ścieżka „Mniejsze, bez CAPA” | zamknięte bez kroków 5–7 |
| T03 | Poważne nie może pominąć CAPA | klasyfikacja „Poważne”, próba ścieżki „bez CAPA” | ścieżka niewidoczna |
| T04 | Zdarzenie bez odchylenia | QA wybiera „Zdarzenie bez odchylenia” | status „Zamknięte jako zdarzenie”, e-mail do zgłaszającego |
| T05 | Data wykrycia przed zdarzeniem | wykrycie wcześniej niż zdarzenie | walidacja blokuje „Zgłoś” |
| T06 | Krytyczne bez wstrzymania serii | klasyfikacja „Krytyczne”, status serii „Zwolniona” | walidacja blokuje; po zmianie na „Wstrzymana” e-mail do kierownika QA i produkcji |
| T07 | Brak działań natychmiastowych | kierownik obszaru wysyła pusty formularz | walidacja: pole wymagane |
| T08 | Plan CAPA bez kryterium skuteczności | „Plan CAPA gotowy” bez kryterium | walidacja blokuje |
| T09 | Rozdzielenie obowiązków | prowadzący dochodzenie próbuje zatwierdzić plan CAPA | brak uprawnienia |
| T10 | Niewykonane działanie | „Wszystkie działania wykonane” przy działaniu „Otwarte” | walidacja blokuje |
| T11 | Nieskuteczne CAPA | kierownik QA wybiera „Nieskuteczne” z komentarzem | powrót do „Dochodzenie” |
| T12 | Trend przyczyn | nowe odchylenie na L2 z przyczyną „Maszyna” | ostrzeżenie o 2 wcześniejszych odchyleniach (DEV/2026/0002, DEV/2026/0003) |
| T13 | Raport dochodzeń po terminie | dane testowe, 20.11.2026 | DEV/2026/0004, 8 dni po terminie |
| T14 | Ślad audytowy | zmiana klasyfikacji DEV/2026/0004 | 2 wpisy: Klasyfikacja Mniejsze → Poważne, TerminDochodzenia 2026-11-27 → 2026-11-12 |
| T15 | Brak usuwania | próba `DELETE` odchylenia w bazie | błąd 50001, rekord pozostaje |
