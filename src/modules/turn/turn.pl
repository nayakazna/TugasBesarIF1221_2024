% Menentukan giliran
setGiliran :-
    remaining_ids([ID|_]),
    assertz(giliran(ID)),
    cekGiliran, 
    !.

nextGiliran :-
    clearScreen,
    % Hapus fakta terkait giliran
    retract(giliran(_)),
    (
        giliranBeres -> 
        retract(giliranBeres)
    ;   true
    ),
    
    % Ambil ID pemain selanjutnya
    remaining_ids(IDs),
    rotateLeft(IDs, NewIDs),

    % Update list remaining_ids
    retract(remaining_ids(_)),
    asserta(remaining_ids(NewIDs)),

    % Set giliran pemain selanjutnya
    setGiliran, 
    !.

% Display giliran
cekGiliran :-
    giliran(ID),
    pemain(ID, Nama, _, _, _),
    format('Sekarang giliran ~w! ~n', [Nama]).