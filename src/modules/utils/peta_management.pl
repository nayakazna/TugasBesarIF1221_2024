% Getter petak 
getKodePetakUnta([(Kode, Isi, _)|_], Unta, Kode) :- isMember(Unta, Isi), !.
getKodePetakUnta([_|Rest], Unta, Kode) :- getKodePetakUnta(Rest, Unta, Kode).
getIdxByKode(Kode, Idx) :- peta(Map), getElmtIdx((Kode, _, _), Map, Idx). 
getStackByKode(Kode, Stack) :- peta(Map), getElmtIdx((Kode, _, _), Map, Idx), getElmt(Map, Idx, (_, Stack, _)).
getTrapByKode(Kode, Trap) :- peta(Map), getElmtIdx((Kode, _, _), Map, Idx), getElmt(Map, Idx, (_, _, Trap)).
getElmtIdxInStack(Warna, Idx) :- peta(Map), getKodePetakUnta(Map, Warna, Kode), getStackByKode(Kode, Stack), getElmtIdx(Warna, Stack, Idx).

% Inisiasi peta
inisialisasiPeta :-
    retractall(peta(_)),
    assertz(peta([
        (s_f, [biru, kuning, hijau, merah, putih, hytam], none),
        (a, [], none),
        (b, [], none),
        (c, [], none),
        (d, [], none),
        (e, [], none),
        (f, [], none),
        (g, [], none),
        (h, [], none),
        (i, [], none),
        (j, [], none),
        (k, [], none),
        (l, [], none),
        (m, [], none),
        (n, [], none),
        (o, [], none)])).