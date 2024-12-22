% facts static
:- dynamic(urutanUnta/1).

% facts dynamic
urutanUntaPoints(1, [50, 10, 5, 0]). 
urutanUntaPoints(2, [30, 10, 5, 0]). 
urutanUntaPoints(_, [20, 10, 5, 0]). 


finishGame :-
(   gameMulai
    ->  katakanPeta, 
        retract(gameMulai),
        getUrutanUnta,
        % tampilkanPemain,

        calculateInvestasiPoints,
        calculatePoints,
        printHijau('Permainan telah selesai!'), nl, !
    ;   write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl
).    

calculatePoints :-
    findall((ID, Nama, Poin), pemain(ID, Nama, Poin, _, _), Players), 
    format('Hasil akhir permainan: ~n', []),
    displayFinalPoints(Players),
    determineWinner(Players).
    
displayFinalPoints([]).
displayFinalPoints([(ID, Nama, Poin)|Rest]) :-
    format('Pemain ~w (ID: ~d) memiliki ~d poin.~n', [Nama, ID, Poin]),
    displayFinalPoints(Rest).

determineWinner(Players) :-
    findMaxPoints(Players, MaxPoints),
    findall(Nama, (isMember((_, Nama, MaxPoints), Players)), Winners),
    (   Winners = [Winner]
    ->  format('Pemenangnya adalah ~w dengan ~d poin!~n', [Winner, MaxPoints])
;   format('Permainan berakhir seri. Pemenang bersama adalah: ~w dengan ~d poin!~n', [Winners, MaxPoints])
).

findMaxPoints([], 0).
findMaxPoints([(_, _, Poin)|Rest], MaxPoints) :-
    findMaxPoints(Rest, MaxRest),
    MaxPoints is max(Poin, MaxRest).

custom_sort(List, SortedList) :-
    custom_sort(List, [], SortedList).

custom_sort([], Acc, Acc).

custom_sort([(Warna, Nilai)|Tail], Acc, SortedList) :-
    insert_sorted((Warna, Nilai), Acc, NewAcc),
    custom_sort(Tail, NewAcc, SortedList).

insert_sorted((Warna, Nilai), [], [(Warna, Nilai)]).
insert_sorted((Warna, Nilai), [(Warna1, Nilai1)|Tail], [(Warna, Nilai), (Warna1, Nilai1)|Tail]) :- Nilai >= Nilai1, !.
insert_sorted((Warna, Nilai), [Head|Tail], [Head|NewTail]) :- insert_sorted((Warna, Nilai), Tail, NewTail).

getUrutanUnta :-
    getNilaiUnta(merah, NilaiMerah),
    getNilaiUnta(kuning, NilaiKuning),
    getNilaiUnta(hijau, NilaiHijau),
    getNilaiUnta(biru, NilaiBiru),
    List = [(merah, NilaiMerah), (kuning, NilaiKuning), (hijau, NilaiHijau), (biru, NilaiBiru)],
    custom_sort(List, SortedList),
    % write('Sorted List'), write(SortedList),
    extract_strings(SortedList, Result),
    retractall(urutanUnta(_)),
    assertz(urutanUnta(Result)).

extract_strings([], []).
extract_strings([(String, _)|Tail], [String|ResultTail]) :- % Recursive case
    extract_strings(Tail, ResultTail).

getNilaiUnta(Warna, Nilai) :-
    peta(Map),
    getKodePetakUnta(Map, Warna, KodePetak),
    getIdxByKode(KodePetak, IndexPetak),
    getElmtIdxInStack(Warna, IndeksDiStack),
    (
        IndexPetak = 0 -> Nilai is 16 * 6 + IndeksDiStack
        ;   Nilai is IndexPetak * 6 + IndeksDiStack
    ).

% Legacy code: Default pemenang untuk development.
% inisialisasiUrutanUnta:- 
%     retractall(urutanUnta(_)),
%     default_cards(ListPemenang),
%     assertz(urutanUnta(ListPemenang)).

%%%%%%%%%% INVESTASI %%%%%%%%%%
calculateInvestasiPoints :- 
    listInvestasi(ListInvestasi),
    ( ListInvestasi = [(merah, []),
                        (kuning, []),
                        (hijau, []),
                        (biru, [])]
        -> write('Tidak ada investasi yang dilakukan.'), nl
        ;   % write('Calculating points...'), nl,
            % write('Rankings: '), write(RankingsUnta), nl,
            % write('Players: '), write(Players), nl,
            write('Investments: '), write(ListInvestasi), nl,
            calculateInvestasiPointsHelper(ListInvestasi)
        ).

calculateInvestasiPointsHelper([]).
calculateInvestasiPointsHelper([(Color, Investors)|T]) :-
    % write('Warna: '), write(Warna), nl,
    % write('Investors: '), write(Investors), nl,
    (   Investors \= []  
        ->  
        findall((ID, Nama, Poin), pemain(ID, Nama, Poin, _, _), Players),
        urutanUnta(SortedUnta),
        getElmtIdx(Color, SortedUnta, Idx),
        NewIdx is Idx + 1,
        urutanUntaPoints(NewIdx, Points),
        assign_points(Players, Investors, Points)
        % write(T), nl,
        % write(SortedUnta),nl,
        % write('Rank : '), write(NewIdx), nl,
        % write('Color : '), write(Color), nl,
        % write('Array Points: '), write(Points), nl,
        % write('Investor : '), write(Investors), nl,
    ;   true
    ),
    calculateInvestasiPointsHelper(T).
    

assign_points(_, [], _).
assign_points(Players, [Investor|T], [P|RestPoints]) :-
    update_player_points(Players, Investor, P),
    assign_points(Players, T, RestPoints).

update_player_points([(ID, Nama, CurrentPoin)|_], ID, Points) :-
    NewPoin is CurrentPoin + Points,
    % write('ID : '), write(ID),nl,
    % write('Current Points:'), write(CurrentPoin),nl,
    % write('Added Points:'), write(Points),nl,

    retract(pemain(ID, Nama, CurrentPoin, _, _)),
    assertz(pemain(ID, Nama, NewPoin, _, _)).

update_player_points([_|T], ID, Points) :-
    update_player_points(T, ID, Points).
