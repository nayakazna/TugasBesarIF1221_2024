%%%%%%%%%%%%%%%% GAME
% Rule untuk ngereset state game
resetGame :-
    retractall(pemain(_, _, _, _, _)),
    retractall(giliran(_)),
    retractall(giliranBeres),
    retractall(remaining_ids(_)),
    retractall(remaining_dadu_colors(_)),
    retractall(peta(_)),
    retractall(gameMulai).

% Rule untuk memulai permainan
startGame :- 
    gameMulai, 
    printMerah('Permainan udah mulai, cik!'), nl, !.

startGame :-
    % Game harusnya belum mulai
    \+gameMulai,
    resetGame,

    % Cetak banner
    clearScreen,
    cetakUntaBanner,
    cetakStartBanner,

    % Input jumlah pemain
    write('Woilah, cik, tolong masukkan jumlah pemain (2-4): '),
    read(Jumlah),   
    (   integer(Jumlah), Jumlah >= 2, Jumlah =< 4
    ->  
    % Inisialisasi game
    initializeAvailableIDs(Jumlah),
    inputPemains(Jumlah),

    % Inisialisasi dadu, investasi, dan peta
    initializeDadu,
    inisialisasiInvestasi,
    inisialisasiPeta,

    % Inisialisasi list untuk menyimpan giliran pemain
    createAvailableIDs(Jumlah, AvailableIDs),
    asserta(remaining_ids(AvailableIDs)),

    % Mulai game dari pemain pertama
    printHijau('Permainan dimulai, cik!'), nl, nl,
    assertz(gameMulai),
    setGiliran, nl,

    % Tampilkan pemain
    tampilkanPemain, nl,
    
    write('Silakan gunakan perintah `help` untuk mendapatkan daftar perintah yang tersedia.'), nl, nl,
    help
    % Jumlah pemain tidak valid
    ;   printMerah('Yang bener aja lah, cik, jumlah pemain harus berupa angka di antara 2 dan 4!'), nl
    ).

help :-
    write('Daftar perintah yang tersedia:'), nl,
    printBold('startGame'), write(' - Memulai permainan.'), nl,
    printBold('cekGiliran'), write(' - Menampilkan giliran pemain terkini.'), nl,
    printBold('cekInfo'), write(' - Melihat informasi pemain.'), nl,
    printBold('katakanPeta'), write(' - Menampilkan peta.'), nl,
    printBold('pasangTrap'), write(' - Memasang trap.'), nl,
    printBold('investasi'), write(' - Melakukan investasi.'), nl,
    printBold('papanInvestasi'), write(' - Melihat daftar investasi.'), nl,
    printBold('nextGiliran'), write(' - Melanjutkan ke giliran pemain berikutnya.'), nl.

%%%%%%%%%%%%%%%% PEMAIN MANAGEMENT
% Buat assign data pemain
setPemain(Nama) :- 
    getRandID(ID),
    default_poin(Poin),
    default_trap(Trap),
    default_cards(Kartu),
    assertz(pemain(ID, Nama, Poin, Trap, Kartu)).

% Input pemain
inputPemains(N) :- N > 0, inputPemainsHelper(N, 0).

%% Fungsi pembantu untuk input pemain
inputPemainsHelper(N, N) :- write('Semua pemain telah berhasil dimasukkan!'), nl, nl. % Basis
inputPemainsHelper(N, Count) :-
    Count < N, % Continue if not all players are inputted
    format('Masukkan nama pemain ~d: ', [Count + 1]),
    read(Nama),
    (   
        atom(Nama), \+ pemain(_, Nama, _, _, _)
    ->  setPemain(Nama),
        NewCount is Count + 1
    ;   printMerah('Nama tidak valid atau sudah digunakan! Silakan masukkan nama lain diawali dengan huruf kecil.'), nl,
        NewCount = Count
    ),
    inputPemainsHelper(N, NewCount).

% Menampilkan daftar pemain
tampilkanPemain :-
    write('Daftar pemain:'), nl,
    sortPemainByID(Sorted),
    tampilkanPemainList(Sorted).

% Menampilkan daftar tiap pemain
tampilkanPemainList([]).
tampilkanPemainList([(ID, Nama, Poin, Trap, Cards)|Rest]) :-
    format('Nomor urut: ~d, Nama: ~w, Poin: ~d, Trap: ~d, Kartu: ~w~n', [ID, Nama, Poin, Trap, Cards]),
    tampilkanPemainList(Rest).

% Mengurutkan pemain berdasarkan ID
sortPemainByID(Sorted) :-
    findall((ID, Nama, Poin, Trap, Cards), pemain(ID, Nama, Poin, Trap, Cards), PemainList),
    insertionSort(PemainList, Sorted).

% Insertion sort 
insertionSort([], []).
insertionSort([Head|Tail], Sorted) :-
    insertionSort(Tail, TempSorted),
    insertByID(Head, TempSorted, Sorted).

% Insertion sort helper
insertByID((ID1, Nama1, Poin1, Trap1, Cards1), [], [(ID1, Nama1, Poin1, Trap1, Cards1)]).
insertByID((ID1, Nama1, Poin1, Trap1, Cards1), [(ID2, Nama2, Poin2, Trap2, Cards2)|Rest], [(ID1, Nama1, Poin1, Trap1, Cards1), (ID2, Nama2, Poin2, Trap2, Cards2)|Rest]) :-
    ID1 =< ID2, !.
insertByID(Elem, [Head|Tail], [Head|Rest]) :-
    insertByID(Elem, Tail, Rest).

%%%%%%%%%%%%%%%% ID
% Generator list remaining_ids untuk menampung ID yang tersedia berdasarkan jumlah pemain
createAvailableIDs(Jumlah, AvailableIDs) :-
    findall(ID, between(1, Jumlah, ID), AvailableIDs).

% Menginisiasi list remaining_ids sebagai fact baru
initializeAvailableIDs(Jumlah) :-
    createAvailableIDs(Jumlah, AvailableIDs),
    shuffleList(AvailableIDs, ShuffledIDs), % Udh telanjur bikin ginian, eh ternyata random_permutation boleh dipake
    assertz(remaining_ids(ShuffledIDs)).

% Ambil id terdepan dari list remaining_ids
getRandID(ID) :-
    remaining_ids([ID|SkrgAvailableIDs]),
    retract(remaining_ids(_)),
    assertz(remaining_ids(SkrgAvailableIDs)).

%%%%%%%%%%%%%%%% BANNER

cetakUntaBanner :-
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠁⠀⠀⠀⠙⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⣠⣴⠖⠒⠺⣿⣯⠟⢿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠜⠁⠀⠀⠀⠀⠀⠀⠀⠙⠳⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⣾⣭⣿⠃⠀⠀⠈⠁⢀⡎⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠒⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠲⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠛⠉⠉⠓⠲⣶⠴⠚⠀⠀⢷⠀⠀⠀⠀⠀⠀⠀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠈⣦⠀⠀⠀⠈⢧⡀⠀⠀⢀⣠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠱⡄⠀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠉⠛⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡆⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⡇⠀⠀⠀⢸⡿⣧⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠘⡇⠀⠀⠀⠀⠸⣄⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠁⠀⢻⠀⠀⠀⠘⡇⢩⠑⡆⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠒⠀⠀⠒⢲⠛⢦⣀⠀⠀⠀⠹⡆⢀⣀⣀⣀⣠⠴⠋⢸⡇⠀⠀⢘⡇⠀⠀⠀⣧⠘⢦⡏⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠀⢀⡟⠙⡄⠀⠀⡏⠉⠁⠀⠀⠀⠀⠀⠈⢧⠀⠀⡾⠻⣄⠀⠀⠘⣆⠀⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⡾⠀⠀⢱⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠀⣧⠀⠈⢳⣄⠀⠘⢦⠀⠀⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⢸⠁⠀⠀⠈⡇⠀⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠀⠸⡄⠀⠀⠘⢷⡀⠈⢳⡄⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⡜⠀⠀⠀⠀⢳⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⣰⠃⠀⠀⠀⠀⢹⡀⢸⡇⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⡼⠁⠀⠀⠀⠀⠈⢧⠀⣷⠀⠀⠀⠀⠀⠀⠀⢸⠁⣰⠃⠀⠀⠀⠀⠀⠀⢇⠈⡇⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠁⡼⠀⠀⠀⠀⠀⠀⠀⠘⡄⢻⠀⠀⠀⠀⠀⠀⠀⡈⢀⠇⠀⠀⠀⠀⠀⠀⠀⠈⡄⢷⠀'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠃⠸⡄⠀⠀⠀⠀⠀⠀⡇⢸⡀⠀⠀⠀⠀⠀⠀⠀⢰⠃⠈⡆'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢀⡶⠠⣇⠀⠀⠀⠀⢀⣼⠁⢸⡇⠀⠀⠀⠀⠀⠀⠀⡼⠂⠀⡇'),nl,
printKuning('                                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡯⡦⠤⠞⠁⠀⠀⠀⠀⠀⠀⢰⣯⣦⡤⢽⠃⠀⠀⠀⢛⣛⠒⠖⠋⠀⠀⠀⠀⠀⠀⢸⡡⣦⠤⠞'),nl.

cetakStartBanner :-
printMerah('        CCCCCCCCCCCCC                                                                 lllllll      UUUUUUUU     UUUUUUUU                     '), nl,
printMerah('     CCC::::::::::::C                                                                 l:::::l      U::::::U     U::::::U                    '), nl,
printMerah('   CC:::::::::::::::C                                                                 l:::::l      U::::::U     U::::::U                    '), nl,
printMerah('  C:::::CCCCCCCC::::C                                                                 l:::::l      UU:::::U     U:::::UU                    '), nl,
printMerah(' C:::::C       CCCCCC   aaaaaaaaaaaaa       mmmmmmm    mmmmmmm        eeeeeeeeeeee     l::::l       U:::::U     U:::::U ppppp   ppppppppp   '), nl,
printBiru('C:::::C                 a::::::::::::a    mm:::::::m  m:::::::mm    ee::::::::::::ee   l::::l       U:::::D     D:::::U p::::ppp:::::::::p  '), nl,
printBiru('C:::::C                 aaaaaaaaa:::::a  m::::::::::mm::::::::::m  e::::::eeeee:::::ee l::::l       U:::::D     D:::::U p:::::::::::::::::p '), nl,
printBiru('C:::::C                          a::::a  m::::::::::::::::::::::m e::::::e     e:::::e l::::l       U:::::D     D:::::U pp::::::ppppp::::::p'), nl,
printBiru('C:::::C                   aaaaaaa:::::a  m:::::mmm::::::mmm:::::m e:::::::eeeee::::::e l::::l       U:::::D     D:::::U  p:::::p     p:::::p'), nl,
printBiru('C:::::C                 aa::::::::::::a  m::::m   m::::m   m::::m e:::::::::::::::::e  l::::l       U:::::D     D:::::U  p:::::p     p:::::p'), nl,
printKuning('C:::::C                a::::aaaa::::::a  m::::m   m::::m   m::::m e::::::eeeeeeeeeee   l::::l       U:::::D     D:::::U  p:::::p     p:::::p'), nl,
printKuning(' C:::::C       CCCCCC a::::a    a:::::a  m::::m   m::::m   m::::m e:::::::e            l::::l       U::::::U   U::::::U  p:::::p    p::::::p'), nl,
printKuning('  C:::::CCCCCCCC::::C a::::a    a:::::a  m::::m   m::::m   m::::m e::::::::e          l::::::l      U:::::::UUU:::::::U  p:::::ppppp:::::::p'), nl,
printKuning('   CC:::::::::::::::C a:::::aaaa::::::a  m::::m   m::::m   m::::m  e::::::::eeeeeeee  l::::::l       UU:::::::::::::UU   p::::::::::::::::p '), nl,
printKuning('     CCC::::::::::::C  a::::::::::aa:::a m::::m   m::::m   m::::m   ee:::::::::::::e  l::::::l         UU:::::::::UU     p::::::::::::::pp  '), nl,
printHijau('        CCCCCCCCCCCCC   aaaaaaaaaa  aaaa mmmmmm   mmmmmm   mmmmmm     eeeeeeeeeeeeee  llllllll           UUUUUUUUU       p::::::pppppppp    '), nl,
printHijau('                                                                                                                         p:::::p            '), nl,
printHijau('                                                                                                                         p:::::p            '), nl,
printHijau('                                                                                                                        p:::::::p           '), nl,
printHijau('                                                                                                                        p:::::::p           '), nl,
write('                                                                                                                        p:::::::p           '), nl,
write('                                                                                                                        ppppppppp           '), nl.