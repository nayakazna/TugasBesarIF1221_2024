:- dynamic(listInvestasi/1).
:- dynamic(pemain/5).

% Inisialisasi investasi dengan contoh data
inisialisasiInvestasi :-
    retractall(listInvestasi(_)),
    assertz(listInvestasi([
        (merah, []),
        (kuning, []),
        (hijau, []),
        (biru, [])])
    ).

investasi :- \+ gameMulai -> printMerah('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.
investasi :- giliranBeres -> printMerah('Giliran sudah beres, tunggu giliran berikutnya! Jalankan perintah `nextGiliran`.'), nl, !.

investasi :-
    (
        gameMulai, \+ giliranBeres
    ->  clearScreen,
        giliran(IDPemain),
        write('Pilih warna unta untuk investasi (merah, kuning, hijau, biru): '),
        read(Warna),
        (
            atom(Warna), isMember(Warna, [merah, kuning, hijau, biru])
            ->  (   
                    validasi_investasi(Warna, IDPemain) 
                ->  lakukan_investasi(Warna, IDPemain),
                    printHijau('Investasi berhasil!'),
                    
                    % Kalau unta disembunyikan, kembalikan unta
                    (
                        unta_disembunyikan -> 
                        kembalikanUnta
                    ;   true
                    ),
                    asserta(giliranBeres)
                ;   printMerah('Gagal melakukan investasi.')
                )
            ;   printMerah('Warna unta tidak valid! Harus merah, kuning, hijau, atau biru. Huruf kecil, ya, cik!'), nl
        )
    )
    ;   write('')
    .

% Validasi investasi
validasi_investasi(Warna, IDPemain) :-
    listInvestasi(ListInvestasi),
    isMember((Warna, ListPemain), ListInvestasi),
    \+ isMember(IDPemain, ListPemain),
    pemain(IDPemain, _, _, _, Kartu),
    isMember(Warna, Kartu).

sudah_investasi(Warna, IDPemain) :-
    listInvestasi(ListInvestasi),
    isMember((Warna, ListPemain), ListInvestasi),
    isMember(IDPemain, ListPemain).

lakukan_investasi(Warna, IDPemain) :-
    retract(listInvestasi(ListInvestasi)),
    update_investasi(Warna, IDPemain, ListInvestasi, ListBaru),
    assertz(listInvestasi(ListBaru)),

    pemain(IDPemain, Nama, Poin, Trap, Kartu),
    del(Kartu, Warna, KartuBaru),
    retract(pemain(IDPemain, Nama, Poin, Trap, Kartu)),
    assertz(pemain(IDPemain, Nama, Poin, Trap, KartuBaru)),

    format('~w masuk ke daftar investasi unta ~w.~n', [IDPemain, Warna]),
    print_investasi(Warna).

% Perbarui list investasi
update_investasi(Warna, IDPemain, [], [(Warna, [IDPemain])]). % Jika warna tidak ditemukan, buat tuple baru

update_investasi(Warna, Pemain, [(Warna, ListPemain)|Rest], [(Warna, ListBaru)|Rest]) :-
    append(ListPemain, [Pemain], ListBaru). % Tambahkan pemain ke warna yang cocok

update_investasi(Warna, Pemain, [Head|Rest], [Head|UpdatedRest]) :-
    update_investasi(Warna, Pemain, Rest, UpdatedRest). % Lanjutkan pencarian

print_investasi(Warna) :-
    format('Papan investasi pada unta ~w:~n', [Warna]),
    printWarna(Warna, '+-------------------+'), nl,
    printWarna(Warna, '|   INVESTASI UNTA  |'), nl,
    printWarna(Warna, '+-------------------+'), nl,
    listInvestasi(ListInvestasi),
    isMember((Warna, ListPemain), ListInvestasi),
    print_daftar_investasi(ListPemain, 1),
    nl, nl.

% Menampilkan papan investasi
papanInvestasi :-
    listInvestasi(ListInvestasi),
    forall(isMember((Warna, ListPemain), ListInvestasi),
    (format('Papan investasi pada unta ~w:~n', [Warna]),
    printWarna(Warna, '+-------------------+'), nl,
    printWarna(Warna, '|   INVESTASI UNTA  |'), nl,
    printWarna(Warna, '+-------------------+'), nl,
            (   ListPemain \= [] ->
                    print_daftar_investasi(ListPemain, 1)
                ;   write('Belum ada investasi'), nl
            ),
            nl, nl)), nl.

print_daftar_investasi([], _).
print_daftar_investasi([H|T], Index) :-
    format('~w. ', [Index]),
    convert_id_to_name(H),
    NextIndex is Index + 1,
    print_daftar_investasi(T, NextIndex).