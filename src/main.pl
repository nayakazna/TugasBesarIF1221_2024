% Jalankan file ini dari root directory repositori, bukan dari src
% Hanya jalankan file ini, jangan jalankan file lainnya

% Facts static
default_poin(30).
default_trap(1).
default_cards([merah, kuning, hijau, biru]).
default_dadu_colors([merah, kuning, hijau, biru, hytamputih]).
dadu_faces([1, 2, 3, 4, 5, 6]).

% Facts dynamic
:- dynamic(pemain/5).
:- dynamic(giliran/1).
:- dynamic(giliranBeres/0).
:- dynamic(remaining_ids/1).
:- dynamic(remaining_dadu_colors/1).
:- dynamic(peta/1).
:- dynamic(gameMulai/0).

% Memuat modul .pl lain yang sudah dibikin dengan jerih payah T_T
:- include('src/modules/utils/list.pl').
:- include('src/modules/utils/peta_management.pl').
:- include('src/modules/utils/ansi.pl').
:- include('src/modules/turn/turn.pl').
:- include('src/modules/startgame.pl').
:- include('src/modules/dice.pl').
:- include('src/modules/turn/cek_info.pl').
:- include('src/modules/turn/display_map.pl').
:- include('src/modules/turn/jalankan_unta.pl').
:- include('src/modules/turn/pasang_trap.pl').
:- include('src/modules/turn/investasi.pl').
:- include('src/modules/endgame.pl').