tukarUnta :- \+gameMulai, write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.
tukarUnta :- giliranBeres, write('Giliran sudah beres, tunggu giliran berikutnya! Jalankan perintah `nextGiliran`.'), nl, !.
tukarUnta :-
    /*
    Fungsi tukarUnta()
    Fungsi ini dipanggil saat pemain memilih untuk menukar unta secara acak.
    Unta yang dipilih secara acak akan ditukar dengan unta lain.
    */

    % Ambil dua warna secara acak
    kocokDadu(Warna1, _),
    kocokDadu(Warna2, _),
    Warna1 \= Warna2,

    % Ambil kode petak unta yang dipilih
    peta(Map),
    getKodePetakUnta(Map, Warna1, Kode1),
    getKodePetakUnta(Map, Warna2, Kode2),
    getStackByKode(Kode1, Stack1),
    getStackByKode(Kode2, Stack2),
    getElmtIdxInStack(Warna1, Idx1),
    getElmtIdxInStack(Warna2, Idx2),

    % Tukar posisi unta
    replace(Stack1, Idx1, Warna2, NewStack1),
    replace(Stack2, Idx2, Warna1, NewStack2),

    % Update peta
    getElmtIdx((Kode1, _, _), Map, IdxKode1),
    getElmtIdx((Kode2, _, _), Map, IdxKode2),
    getElmt(Map, IdxKode1, (_, _, Trap1)),
    getElmt(Map, IdxKode2, (_, _, Trap2)),
    replace(Map, IdxKode1, (Kode1, NewStack1, Trap1), NewMap1),
    replace(NewMap1, IdxKode2, (Kode2, NewStack2, Trap2), NewMap2),
    retract(peta(_)),
    assertz(peta(NewMap2)),
    
    % Print hasil tukar unta
    format('Unta ~w dan ~w telah ditukar! ~n', [Warna1, Warna2]),
    % Print posisi semula
    format('Posisi semula: ~w di petak ~w, ~w di petak ~w. ~n', [Warna1, Kode1, Warna2, Kode2]),
    % Print posisi baru
    format('Posisi baru: ~w di petak ~w, ~w di petak ~w. ~n', [Warna2, Kode1, Warna1, Kode2]),
    katakanPeta,

    % Kalau unta disembunyikan, kembalikan unta
    (
        unta_disembunyikan -> 
        kembalikanUnta
    ;   true
    ),

    % Selesaikan giliran
    asserta(giliranBeres),
    !.