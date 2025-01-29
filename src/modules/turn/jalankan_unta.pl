jalankanUnta :- \+gameMulai, write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.
jalankanUnta :- giliranBeres, write('Giliran sudah beres, tunggu giliran berikutnya! Jalankan perintah `nextGiliran`.'), nl, !.

jalankanUnta :-
    gameMulai, \+ giliranBeres,
    clearScreen,
    kocokDadu(Warna, Angka),
    write('Dadu dikocok, aih...'), nl,
    format('Dadu Angka: ~w~nDadu Warna: ~w', [Angka, Warna]), nl, nl,
    format('Woilah, rek, unta ~w bergerak sejauh ~w petak!', [Warna, Angka]), nl,
    peta(Map),
    getKodePetakUnta(Map, Warna, KodeAsal),
    getIdxByKode(KodeAsal, IndexAsal),
    getStackByKode(KodeAsal, StackAsal),
    getTrapByKode(KodeAsal, TrapAsal),
    (
        KodeAsal = s_f ->
        (
            Warna = hytam -> IndeksTujuan is 16 - Angka
        ;   Warna = putih -> IndeksTujuan is 16 - Angka
        ;   IndeksTujuan is IndexAsal + Angka % Else, warna biasa
        ),
        del(StackAsal, Warna, StackAsalBaru),
        replace(Map, IndexAsal, (KodeAsal, StackAsalBaru, TrapAsal), TempMap),
        getElmt(TempMap, IndeksTujuan, (KodeTujuan, StackTujuan, TrapTujuan)),
        insertLast(Warna, StackTujuan, StackTujuanBaru),
        replace(TempMap, IndeksTujuan, (KodeTujuan, StackTujuanBaru, TrapTujuan), NewMap),
        retract(peta(_)),
        assertz(peta(NewMap))

    ;   % Buat sembarang posisi (bukan di s/f)
        (
            Warna = hytam -> 
            (
                TempTujuan is IndexAsal - Angka,
                (TempTujuan < 1 -> IndeksTujuan = 1; IndeksTujuan = TempTujuan)
            )
        ;   Warna = putih -> 
            (
                TempTujuan is IndexAsal - Angka,
                (TempTujuan < 1 -> IndeksTujuan = 1; IndeksTujuan = TempTujuan)
            )
        ;   (
                TempTujuan is IndexAsal + Angka, % Else, warna biasa
                (TempTujuan > 15 -> IndeksTujuan = 0; IndeksTujuan = TempTujuan)
            )   
        ),
        getElmtIdxInStack(Warna, IndeksDiStack),
        split(StackAsal, IndeksDiStack, StackAsalBaru, StackPindah),
        replace(Map, IndexAsal, (KodeAsal, StackAsalBaru, TrapAsal), TempMap),
        getElmt(TempMap, IndeksTujuan, (KodeTujuan, StackTujuan, TrapTujuan)),
        konkat(StackTujuan, StackPindah, StackTujuanBaru),
        replace(TempMap, IndeksTujuan, (KodeTujuan, StackTujuanBaru, TrapTujuan), NewMap),
        retract(peta(_)),
        assertz(peta(NewMap)),
        (
            IndeksTujuan = 0 -> printHijau('Unta udah nyampe di finish, rek!'), nl,
            finishGame
        ;   write(''), nl
        )
    ), 

    % Update poin pemain
    giliran(CurrentPemainID),
    pemain(CurrentPemainID, Nama, Poin, Kartu, Trap),
    NewPoin is Poin + 10,
    retract(pemain(CurrentPemainID, _, Poin, _, _)),
    asserta(pemain(CurrentPemainID, Nama, NewPoin, Kartu, Trap)),
    
    % Kalau unta disembunyikan, kembalikan unta
    (
        unta_disembunyikan -> 
        kembalikanUnta
    ;   true
    ),
    
    % Update giliran
    asserta(giliranBeres),
    % cetakTest,

    % Petak jebakan!
    peta(MMap),
    getKodePetakUnta(MMap, Warna, KodeBaru),
    getTrapByKode(KodeBaru, TrapBaru),
    (
        TrapBaru = none -> katakanPeta
        ; true 
    ),
    % write(TrapBaru), nl,
    (
        TrapBaru = maju -> 
        (
            printMerah('Unta ketemu trap maju, rek!'), nl,
            getIdxByKode(KodeBaru, IndeksBaru),
            IndeksSangatBaru is (IndeksBaru + 1) mod 16
        )
    ;   TrapBaru = mundur -> 
        (
            printMerah('Unta ketemu trap mundur, rek!'), nl,
            getIdxByKode(KodeBaru, IndeksBaru),
            IndeksSangatBaru is (IndeksBaru - 1)
        )
    ;   write(''), nl
    ),
    % Ubah petak asal
    getStackByKode(KodeBaru, StackBaru),
    getElmtIdxInStack(Warna, IndeksDiStackBaru),
    split(StackBaru, IndeksDiStackBaru, StackBaruBaru, StackPindahBaru),
    replace(MMap, IndeksBaru, (KodeBaru, StackBaruBaru, none), TempMapBaru),
    
    % Ubah petak tujuan
    getElmt(TempMapBaru, IndeksSangatBaru, (KodeTujuanBaru, StackTujuanSangatBaru, TrapTujuanBaru)),
    konkat(StackTujuanSangatBaru, StackPindahBaru, StackTujuanBaruBaru),
    replace(TempMapBaru, IndeksSangatBaru, (KodeTujuanBaru, StackTujuanBaruBaru, TrapTujuanBaru), NewMapBaru),
    
    % Tambah poin ke trapowner
    trapOwner(IndeksBaru, TrapOwnerID),
    pemain(TrapOwnerID, NamaTrapOwner, PoinTrapOwner, 0, KartuTrapOwner),
    PoinJebakan is PoinTrapOwner + 10,
    retract(pemain(TrapOwnerID, _, PoinTrapOwner, _, _)),
    asserta(pemain(TrapOwnerID, NamaTrapOwner, PoinJebakan, 0, KartuTrapOwner)),
    retract(trapOwner(IndeksBaru, TrapOwnerID)),

    % Update peta
    retract(peta(_)),
    assertz(peta(NewMapBaru)),
    (
        IndeksSangatBaru = 0 -> printHijau('Unta udah nyampe di finish, rek!'), nl
        ;   write(''), nl
        ),
    (
        TrapBaru = none ->true 
        ; katakanPeta
    ),
    !.