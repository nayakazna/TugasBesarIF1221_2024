kocokDadu(Warna, Angka) :- 
    remaining_dadu_colors([]), 
    initializeDadu, 
    kocokDadu(Warna, Angka),
    !.

kocokDadu(Warna, Angka) :-
        % Ambil list warna dadu tersisa
        remaining_dadu_colors(WarnaWarni),
        len(WarnaWarni, WarnaLen),
        
        % Ambil list angka dadu
        dadu_faces(AngkaAngka),
        len(AngkaAngka, AngkaLen),

        % Ambil warna acak
        random(0, WarnaLen, WarnaIndex),
        getElmt(WarnaWarni, WarnaIndex, InitWarna),
        
        % Ambil angka acak
        random(0, AngkaLen, AngkaIndex),
        getElmt(AngkaAngka, AngkaIndex, Angka),

        % Buat dadu hytamputih
        (
            InitWarna = hytamputih 
        ->  (
                0 =:= mod(Angka, 2)
            ->  Warna = putih
            ;   Warna = hytam
            )
        ;   Warna = InitWarna
        ),

        % Update list warna dadu tersisa
        del(WarnaWarni, InitWarna, NewWarni),
        retract(remaining_dadu_colors(_)),
        asserta(remaining_dadu_colors(NewWarni)).

% Inisialisasi dadu
initializeDadu :-
    retractall(remaining_dadu_colors(_)),
    default_dadu_colors(DaduColors),
    asserta(remaining_dadu_colors(DaduColors)).