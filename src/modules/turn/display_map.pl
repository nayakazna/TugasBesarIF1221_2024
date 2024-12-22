katakanPeta :- \+gameMulai, write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.

katakanPeta :-
    gameMulai,
    cetakDividerOut,
    cetakHeadPetak1,
    cetakUntaPetak1,
    cetakTrapPetak1,
    cetakDividerOut,
    cetakHeadPetak2,
    cetakUntaPetak2,
    cetakTrapPetak2,
    cetakDividerIn,
    cetakHeadPetak3,
    cetakUntaPetak3,
    cetakTrapPetak3,
    cetakDividerIn,
    cetakHeadPetak4,
    cetakUntaPetak4,
    cetakTrapPetak4,
    cetakDividerOut,
    cetakHeadPetak5,
    cetakUntaPetak5,
    cetakTrapPetak5,
    cetakDividerOut.

cetakSpace(0):- !.
cetakSpace(N) :-
    write(' '),
    N1 is N - 1,
    cetakSpace(N1).

calculateSpaceSF(X, Result) :-
    Half is X / 2,         
    FloorVal is round(Half), 
    Result is 12 - X - FloorVal.

calculateSpace(X, Result) :-
    Result is 13 - 2 * X.

cetakPetakUnta(Kode) :-
    getStackByKode(Kode, Stack),
    len(Stack, Len),
    (
        Len =:= 0
        ->  cetakSpace(11), writeStack(Stack), cetakSpace(12), write('|')
        ;   translateStackSingkatan(Stack, Singkatan),
            calculateSpace(Len, LeftSpace),
            cetakSpace(LeftSpace),
            writeStack(Singkatan),
            RightSpace is 26 - 
                (
                    Len * 2             % 2 = 1 (untuk spasi) + 1 (untuk karakter)
                    + (Len - 1) * 2     % (untuk spasi dan koma)
                    + 2                 % 2 = untuk pembatas (|)
                    + LeftSpace         % 1 = 1 (untuk spasi kiri)
                ),
            cetakSpace(RightSpace),
            write('|')
    ).

cetakPetakTrap(Kode) :-
    getTrapByKode(Kode, Trap),
    (
        Trap = none -> cetakSpace(11), write('( )'), cetakSpace(12), write('|')
    ;   Trap = maju -> cetakSpace(9), write('(Trap>)'), cetakSpace(10), write('|')
    ;   Trap = mundur -> cetakSpace(9), write('(<Trap)'), cetakSpace(10), write('|')
    ).

cetakDividerOut :-
    write('+--------------------------+--------------------------+--------------------------+--------------------------+--------------------------+'), nl.

cetakDividerIn :-
    write('+--------------------------+                                                                                +--------------------------+'), nl.

cetakHeadPetak1 :-
    write('|           S/F            |            A             |            B             |            C             |            D             |'), nl.

cetakUntaPetak1 :-
    write('|'),
    getStackByKode(s_f, StackSF),
    len(StackSF, LenSF),
    % Petak S/F
    (
        LenSF =:= 0
        ->  cetakSpace(11), writeStack(StackSF), cetakSpace(12), write('|')
        ;   translateStackSingkatan(StackSF, SingkatanSF),
            calculateSpaceSF(LenSF, LeftSpaceSF),
            cetakSpace(LeftSpaceSF),
            writeSF(SingkatanSF),
            RightSpaceSF is 26 - 
                (
                    LenSF * 2       % 2 = 1 (untuk spasi) + 1 (untuk karakter)
                    + (LenSF - 1)   % 1 = 1 (untuk spasi)
                    + 2             % 2 = untuk pembatas (|)
                    + LeftSpaceSF   % 1 = 1 (untuk spasi kiri)
                ),
            cetakSpace(RightSpaceSF),
            write('|')
    ),
    cetakPetakUnta(a),
    cetakPetakUnta(b),
    cetakPetakUnta(c),
    cetakPetakUnta(d),
    nl, !.

cetakTrapPetak1 :-
    write('|'),
    cetakPetakTrap(s_f),
    cetakPetakTrap(a),
    cetakPetakTrap(b),
    cetakPetakTrap(c),
    cetakPetakTrap(d),
    nl, !.

cetakHeadPetak2 :-
    write('|            O             |                                                                                |            E             |'), nl.

cetakUntaPetak2 :-
    write('|'),
    cetakPetakUnta(o),
    cetakSpace(80),
    write('|'),
    cetakPetakUnta(e),
    nl, !.

cetakTrapPetak2 :-
    write('|'),
    cetakPetakTrap(o),
    cetakSpace(80),
    write('|'),
    cetakPetakTrap(e),
    nl, !.

cetakHeadPetak3 :-
    write('|            N             |                                                                                |            F             |'), nl.

cetakUntaPetak3 :-
    write('|'),
    cetakPetakUnta(n),
    cetakSpace(35),
    write('Camel Up!'),
    cetakSpace(36),
    write('|'),
    cetakPetakUnta(f),
    nl, !.

cetakTrapPetak3 :-
    write('|'),
    cetakPetakTrap(n),
    cetakSpace(80),
    write('|'),
    cetakPetakTrap(f),
    nl, !.

cetakHeadPetak4 :-
    write('|            M             |                                                                                |            G             |'), nl.

cetakUntaPetak4 :-
    write('|'),
    cetakPetakUnta(m),
    cetakSpace(80),
    write('|'),
    cetakPetakUnta(g),
    nl, !.

cetakTrapPetak4 :-
    write('|'),
    cetakPetakTrap(m),
    cetakSpace(80),
    write('|'),
    cetakPetakTrap(g),
    nl, !.

cetakHeadPetak5 :-
    write('|            L             |            K             |            J             |            I             |            H             |'), nl.

cetakUntaPetak5 :-
    write('|'),
    cetakPetakUnta(l),
    cetakPetakUnta(k),
    cetakPetakUnta(j),
    cetakPetakUnta(i),
    cetakPetakUnta(h),
    nl, !.

cetakTrapPetak5 :-
    write('|'),
    cetakPetakTrap(l),
    cetakPetakTrap(k),
    cetakPetakTrap(j),
    cetakPetakTrap(i),
    cetakPetakTrap(h),
    nl, !.



translateSingkatan(Warna, Singkatan) :-
    (
        Warna = biru    -> Singkatan = '\33\[38;5;33mUB\33\[0m';
        Warna = kuning  -> Singkatan = '\33\[38;5;220mUK\33\[0m';
        Warna = hijau   -> Singkatan = '\33\[38;5;28mUH\33\[0m';
        Warna = merah   -> Singkatan = '\33\[38;5;196mUM\33\[0m';
        Warna = putih   -> Singkatan = '\33\[38;5;15mUP\33\[0m';
        Warna = hytam   -> Singkatan = '\33\[38;5;240mUI\33\[0m'
    ).

translateStackSingkatan([], []) :- !.
translateStackSingkatan([H|T], [Singkatan|SingkatanT]) :-
    translateSingkatan(H, Singkatan),
    translateStackSingkatan(T, SingkatanT),
    !.

% debugPeta :-
%     peta(P),
%     maplist(displayPetak, P).       

% displayPetak((Kode, Isi, Trap)) :-
%     format('Petak ~w: Unta ~w, Trap ~w~n', [Kode, Isi, Trap]).