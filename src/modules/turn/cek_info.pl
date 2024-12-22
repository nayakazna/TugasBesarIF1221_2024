cekInfo:-
    (
        gameMulai -> write('Masukkan nama pemain: '), read(Nama),
        (
            clearScreen,
            \+atom(Nama) -> write('Nama tidak valid! Nama harus diawali dengan huruf kecil.'), nl, !
        ;   pemain(ID, Nama, Poin, Trap, Cards) -> format('Nomor urut: ~d, Nama: ~w, Poin: ~d, Trap: ~d, Kartu: ~w~n', [ID, Nama, Poin, Trap, Cards])
        ;   write('Pemain tidak ada!'), nl, !
        )
        ;
        write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !
    ).