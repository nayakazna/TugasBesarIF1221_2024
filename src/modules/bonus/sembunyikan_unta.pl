sembunyikanUnta :- \+gameMulai, write('Woilah, cik, permainan belum dimulai! Silakan mulai dengan perintah `startGame`.'), nl, !.
sembunyikanUnta :- giliranBeres, write('Giliran sudah beres, tunggu giliran berikutnya! Jalankan perintah `nextGiliran`.'), nl, !.
sembunyikanUnta :- unta_disembunyikan, write('Unta sudah disembunyikan! Tunggu sampai giliran berikutnya!'), nl, !.
sembunyikanUnta :-
    /*
    Fungsi sembunyikanUnta()
    
    Fungsi ini dipanggil saat pemain memilih untuk menyembunyikan unta
    Unta yang dipilih secara acak akan disembunyikan selama satu turn
    Kode petak dan tumpukan unta yang memuat unta yang akan disembunyikan (serta ketinggian unta dalam tumpukan tersebut) disimpan 
    dalam variabel KodeAsal, Stack, dan IdxUnta lalu diassert ke fakta kode_disembunyikan, stack_disembunyikan, dan idx_disembunyikan.
    */
    \+unta_disembunyikan,

    % Ambil warna secara acak
    kocokDadu(Warna, _),
    format('Unta ~w akan disembunyikan selama satu turn. ~n', [Warna]),
    
    % Simpan stack unta yang memuat unta yang akan disembunyikan
    peta(Map),
    getKodePetakUnta(Map, Warna, KodeAsal),
    getStackByKode(KodeAsal, Stack),
    getElmtIdxInStack(Warna, IdxUnta),

    assertz(kode_disembunyikan(KodeAsal)),
    assertz(stack_disembunyikan(Stack)),
    assertz(idx_disembunyikan(IdxUnta)),

    % Hapus unta dari petak
    delAt(Stack, IdxUnta, NewStack),
    
    % Update peta
    getElmtIdx((KodeAsal, _, _), Map, IdxKode),
    getElmt(Map, IdxKode, (_, _, Trap)),
    replace(Map, IdxKode, (KodeAsal, NewStack, Trap), NewMap),
    retract(peta(_)),
    assertz(peta(NewMap)),
    
    % Update fakta unta_disembunyikan
    assertz(unta_disembunyikan),
    !.

kembalikanUnta :-
    /*
    Fungsi kembalikanUnta()

    Fungsi ini dipanggil setelah unta yang disembunyikan selesai disembunyikan.
    Unta yang disembunyikan akan kembali ke petak semula.

    Cara memperbarui tumpukan unta setelah unta yang disembunyikan dikembalikan:
        Katakanlah unta yang disembunyikan adalah unta dengan warna X yang berada di petak dengan kode Y.
        Untuk memeriksa keadaan tumpukan unta pada petak Y setelah giliran selesai,
        kita cukup memeriksa apakah unta yang persis di atas X sudah berjalan atau belum.
        Kasus 1:
        Jika sudah berjalan, maka unta X akan menjadi unta teratas di petak Y.
            Perhatikan bahwa jika unta X sedari awal adalah unta teratas di petak Y, kita juga bisa lakukan hal yang sama.
        Kasus 2:
        Sementara itu, jika tidak, maka unta X akan kembali ke posisi semula.
    */
    
    % Ambil kode petak, stack, dan indeks unta yang disembunyikan
    kode_disembunyikan(KodeAsal),
    stack_disembunyikan(Stack),
    idx_disembunyikan(IdxUnta),

    % Periksa apakah unta-unta pada petak yang sama dengan unta yang disembunyikan telah berjalan
    (
        %% Kasus 1: 
        IdxUntaDiAtasnya is IdxUnta + 1,
        getElmt(Stack, IdxUntaDiAtasnya, WarnaDiAtasnya),
        (
            %% Kasus 1a: unta yang disembunyikan adalah unta teratas
            len(Stack, LenStack),
            IdxUntaDiAtasnya =:= LenStack;

            %% Kasus 1b: unta yang disembunyikan bukan unta teratas, tapi unta di atasnya sudah berjalan
            %%% Ambil stack unta sekarang
            getStackByKode(KodeAsal, StackSekarang),
            
            %%% Pastikan unta di atasnya sudah berjalan (tidak ada di stack unta sekarang)
            \+ isMember(WarnaDiAtasnya, StackSekarang)
        )
        %%%   unta yang disembunyikan akan menjadi unta teratas
        ->  
            %%% Ambil warna unta yang disembunyikan
            getElmt(Stack, IdxUnta, Warna),

            %%% Tambahkan unta ke petak
            insertLast(Warna, Stack, NewStack)
        ;
        %% Kasus 2: unta yang disembunyikan bukan unta teratas dan unta di atasnya belum berjalan
        %%% unta yang disembunyikan akan kembali ke posisi semula
        %%% kembalikan stack semula
        NewStack = Stack
    )
    %%% Update peta
    ->
    peta(Map),    
    getElmtIdx((KodeAsal, _, _), Map, IdxKode),
    getElmt(Map, IdxKode, (_, _, Trap)),
    replace(Map, IdxKode, (KodeAsal, NewStack, Trap), NewMap),
    retract(peta(_)),
    assertz(peta(NewMap)),
    
    %%% Hapus fakta unta_disembunyikan
    retract(unta_disembunyikan).