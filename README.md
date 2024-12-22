[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/U1aIlUUU)
# Sekapur Sirih
Sebelum saya otak-atik **sedikit**, program ini semula dibuat oleh kelompok Piton Acatrix 24 Aseli Ngawi dari kelas K2 Teknik Informatika (IF) ITB 2023 dengan rincian anggota:
| Nama | NIM |
| ---- | --- |
| Zulfaqqar Nayaka Athadiansyah | 13523094 |
| Raka Daffa Iftikhaar | 13523018 |
| Ahsan Malik Al Farisi | 13523074 | 
| Farrel Athalla Putra | 13523118 |

# Tentang
![](https://m.media-amazon.com/images/I/81ZBWwOQHkL.jpg)
Repositori ini berisi kode sumber dari tiruan permainan papan Camel Up yang ditulis dalam bahasa Prolog sebagai praktikum dari mata kuliah IF1221 Logika Komputasional. Inti dari game ini sebenarnya mirip judi (dalam lingkup ini diperhalus menjadi "investasi") pacuan kuda, bedanya yang balapan di sini adalah unta. Permainan ini dilakukan pada papan sirkular seperti papan monopoli yang berukuran 5 * 5.

Ada empat warna unta yang mengikuti balapan, yakni merah, biru, hijau, dan kuning. Unta digerakkan secara acak menggunakan dadu berwarna, yang warnanya pun dipilih secara acak. Tiap pemain dapat berinvestasi pada unta yang menurut mereka akan menjadi juara. Hal yang membuat permainan ini lebih menarik adalah pemain dapat memasang jebakan yang membuat unta bergerak maju atau mundur ketika tiba di petak yang ia pasangi jebakan. Selain itu, ketika seekor unta bergerak menuju petak yang sudah berisi unta lain, ia akan menaiki unta tersebut. Tiap kali unta paling bawah bergerak maju, tumpukan unta di atasnya pun terbawa. 

Permainan berakhir ketika satu unta berhasil mencapai petak start kembali. Akan tetapi, jika unta yang tiba dalam keadaan bertumpuk, justru unta paling atas yang menang!

# Instalasi
Program ini dibuat untuk dijalankan dengan GNU Prolog via terminal di Linux (gunakan WSL untuk Windows) ketimbang via interpreter interaktif. Unduh dan pasang [GNU Prolog](http://www.gprolog.org) di perangkat Anda dengan perintah
```
sudo apt install gprolog
```

Kemudian, salin repositori ini dengan menjalankan perintah
```
git clone https://github.com/praktikum-if1221-logika-komputasional/praktikum-if1221-logika-komputasional-piton-24-aseli-ngawi.git
```

Pada konsol GNU Prolog, ganti direktori kerja (_working directory_) menuju folder repositori ini dengan `cd path/ke/repo`. Selanjutnya, jalankan program utama dengan perintah

```
['src/main.pl'].
```

![tada!](image.png)
