clearScreen :- write('\33\c\33\[H').
printMerah(Text) :- format('\33\[38;5;196m~w\33\[0m', [Text]).
printBiru(Text) :- format('\33\[38;5;33m~w\33\[0m', [Text]).
printHijau(Text) :- format('\33\[38;5;28m~w\33\[0m', [Text]).
printKuning(Text) :- format('\33\[38;5;220m~w\33\[0m', [Text]).
printWarna(Warna, Text) :- Warna = merah, printMerah(Text).
printWarna(Warna, Text) :- Warna = biru, printBiru(Text).
printWarna(Warna, Text) :- Warna = hijau, printHijau(Text).
printWarna(Warna, Text) :- Warna = kuning, printKuning(Text).
printBold(Text) :- format('\33\[1m~w\33\[0m', [Text]).