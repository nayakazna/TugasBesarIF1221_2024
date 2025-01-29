% trapOwner(IDPetakTrap, IDOwner)
:- dynamic(trapOwner/2).
% Rule untuk memasang trap
pasangTrap :- \+gameMulai, printMerah('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.
pasangTrap :- giliranBeres, printMerah('Giliran sudah beres, tunggu giliran berikutnya! Jalankan perintah `nextGiliran`.'), nl, !.
pasangTrap :-
    gameMulai,
    \+ giliranBeres,
    clearScreen,
    giliran(CurrentPemainID),
    pemain(CurrentPemainID, Nama, Poin, Trap, Kartu),
    (
        Trap =< 0 
    ->  write('Kamu udah nggak punya trap lagi, cik!'), nl
    ;   katakanPeta, write('Masukkan kode petak yang ingin dipasangi trap dalam huruf kecil: '), read(KodePetak),
        (   atom(KodePetak), isMember(KodePetak, [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o])
        ->  getTrapByKode(KodePetak, TrapBaru),
            (
                TrapBaru = none
                ->  write('Trapnya mau gimana nih (maju/mundur)? '), read(JenisTrap),
                ( isMember(JenisTrap, [maju, mundur])
                ->  
                    (
                        adaTrapDiSekitar(KodePetak) 
                    ->  printMerah('Trap udah ada di sekitar petak '), write(KodePetak), write(', cik!'), nl
                    ;
                        adaUnta(KodePetak) -> printMerah('Ada unta di petak '), write(KodePetak), write(', cik!'), nl
                    % Update trap pemain
                    ;   NewTrap is Trap - 1,
                        retract(pemain(CurrentPemainID, _, _, _, _)),
                        asserta(pemain(CurrentPemainID, Nama, Poin, NewTrap, Kartu)),

                        % Pasang trap
                        getIdxByKode(KodePetak, Idx),
                        asserta(trapOwner(Idx, CurrentPemainID)),
                        peta(Map),
                        getStackByKode(KodePetak, Stack),
                        replace(Map, Idx, (KodePetak, Stack, JenisTrap), NewMap),
                        retract(peta(_)),
                        assertz(peta(NewMap)),
                        
                        % Konpirmasi
                        clearScreen,
                        printHijau('Trap '), printHijau(JenisTrap), printHijau(' berhasil dipasang di petak '), printHijau(KodePetak), printHijau(', cik!'), nl,
                        katakanPeta,
                        asserta(giliranBeres),
                        % Kalau unta disembunyikan, kembalikan unta
                        (
                            unta_disembunyikan -> 
                            kembalikanUnta
                        ;   true
                        )
                    )
                ;   printMerah('Gak usah ngadi-ngadi! Jenis trap cuma maju atau mundur.'), nl
                )
            ;   printMerah('Petak ~w udah ada trap ~w, cik! ~n', [KodePetak, TrapBaru]), nl
            )
        ;   printMerah('Itu kode petak ngaco dari mana?! Harus antara a sampai o. Huruf kecil!'), nl
        )
    ).

adaTrapDiSekitar(KodePetak) :-
    peta(Map),
    getIdxByKode(KodePetak, Idx),
    (
        % Petak A
        Idx = 1 -> 
        getElmt(Map, 2, (_, _, TrapNext)),
        TrapNext \= none
        % Petak O
        ; Idx = 15 ->
        getElmt(Map, 14, (_, _, TrapPrev)),
        TrapPrev \= none
        ; % Petak B, C, D, E, F, G, H, I, J, K, L, M, N
        Next is Idx + 1,
        getElmt(Map, Next, (_, _, TrapNext)),
        TrapNext \= none
        ;
        Prev is Idx - 1,
        getElmt(Map, Prev, (_, _, TrapPrev)),
        TrapPrev \= none
    ), !.

adaUnta(KodePetak):-
    getStackByKode(KodePetak, Stack),
    % write(Stack),
    len(Stack, LenStack),
    LenStack \= 0, !.