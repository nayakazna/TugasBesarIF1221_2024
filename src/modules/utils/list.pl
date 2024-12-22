% Memuat facts dan rules untuk list processing

% Panjang list
len([], 0):- !.
len([_|Tail], Len) :- len(Tail, PrevLen), Len is PrevLen + 1.

% Cek apakah elemen ada di list
isMember(Elmt, [Elmt|_]).
isMember(Elmt, [_|Tail]) :- isMember(Elmt, Tail).

% Getter elemen ke-i di list
getElmt([Element|_], 0, Element) :- !.
getElmt([_|Tail], Idx, Element):- Idx > 0, NewIdx is Idx - 1, getElmt(Tail, NewIdx, Element).

% akan mengembalikan Index pertama elemen yang ditemukan dalam List
getElmtIdx(Element, [Element|_], 0).  % Basis: jika elemen ditemukan di awal list, indexnya adalah 0
getElmtIdx(Element, [_|Tail], Index) :-
    getElmtIdx(Element, Tail, NewIndex),  % Rekursi pada sisa list
    Index is NewIndex + 1.  % Menambahkan 1 ke indeks yang ditemukan

% Sisipkan elemen ke depan list
insertFirst(Elmt, [], [Elmt]) :- !.
insertFirst(Elmt, List, [Elmt|List]) :- !.

% Sisipkan elemen pada indeks idx di list
insertAt(Elmt, 0, List, [Elmt|List]) :- !.
insertAt(Elmt, Index, [Head|Tail], [Head|Res]) :- Index > 0, NewIndex is Index - 1, insertAt(Elmt, NewIndex, Tail, Res).

% Sisipkan elemen ke akhir list
insertLast(Elmt, [], [Elmt]) :- !.
insertLast(Elmt, [Head|Tail], [Head|Res]) :- insertLast(Elmt, Tail, Res), !.

% Hapus elemen pertama dari list
delFirst([], []) :- !.
delFirst([_|Tail], Tail) :- !.

% Hapus elemen di indeks ke-i dari list
delAt([], _, []) :- !.
delAt([_|Tail], 0, Tail) :- !.
delAt([Head|Tail], Idx, [Head|Res]) :- Idx > 0, NewIdx is Idx - 1, delAt(Tail, NewIdx, Res).

% Hapus elemen terakhir dari list
delLast([], []) :- !.
delLast([Head|Tail], [Head|Res]) :- delLast(Tail, Res).

% Hapus elemen dari list
del([Elmt|Tail], Elmt, Tail) :- !.
del([Head|Tail], Elmt, [Head|Res]) :- del(Tail, Elmt, Res).

% Ganti elemen di list
replace([], _, _, []) :- !.
replace([_|T], 0, X, [X|T]) :- !.
replace([H|T], Idx, X, [H|Res]) :- Idx > 0, NewIdx is Idx - 1, replace(T, NewIdx, X, Res).


% Gabungkan dua list
konkat([], List, List) :- !.
konkat([Head|Tail], List, [Head|Res]) :- konkat(Tail, List, Res).

% Potong list (potong kuenya potong kuenya potong kuenya sekarang juga)
split(List, 0, [], List) :- !.
split([Head|Tail], N, [Head|Res1], Res2) :- N > 0, NewN is N - 1, split(Tail, NewN, Res1, Res2).

% Shuffle list
shuffleList([], []) :- !. % Basis.
shuffleList(List, [Elmt|Shuffled]) :- % Rekursi
    len(List, Len), Len > 0,
    random(0, Len, Idx),
    getElmt(List, Idx, Elmt),
    del(List, Elmt, Rest),
    shuffleList(Rest, Shuffled).

% Puter list
rotateLeft([H|T], NewList) :- append(T, [H], NewList).

% Menulis list pakai separator koma dan spasi
writeStack(L) :- write('['), writeStackBody(L), write(']').
writeStackBody([]) :- write(' '), !.
writeStackBody([H]) :- write(H), !.
writeStackBody([H|T]) :- write(H), write(', '), writeStackBody(T), !. 

writeSF(L) :- write('['), writeSFBody(L), write(']').
writeSFBody([]) :- write(' '), !.
writeSFBody([H]) :- write(H), !.
writeSFBody([H|T]) :- write(H), write(' '), writeSFBody(T), !. 

convert_id_to_name(ID) :-
    (   pemain(ID, Name, _, _, _) ->
        format('~w~n', [Name])
    ;   write('ID tidak ditemukan.'), nl
    ).

% Fungsi untuk mengubah string menjadi kapital
to_kapital([], []).
to_kapital([H|T], [HK|TK]) :-
    char_code(H, Code),
    (Code >= 97, Code =< 122 -> % kode ASCII untuk 'a' sampai 'z'
        HKCode is Code - 32, % kode ASCII untuk 'A' sampai 'Z'
        char_code(HK, HKCode)
    ;
        HK = H
    ),
    to_kapital(T, TK).
