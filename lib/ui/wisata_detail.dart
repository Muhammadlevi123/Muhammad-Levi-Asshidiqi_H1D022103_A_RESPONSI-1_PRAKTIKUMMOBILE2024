import 'package:flutter/material.dart';
import '../bloc/wisata_bloc.dart';
import '../widget/warning_dialog.dart';
import '/model/wisata.dart';
import '/ui/wisata_form.dart';
import 'wisata_page.dart';

// ignore: must_be_immutable
class WisataDetail extends StatefulWidget {
  Wisata? wisata;

  WisataDetail({Key? key, this.wisata}) : super(key: key);

  @override
  _WisataDetailState createState() => _WisataDetailState();
}

class _WisataDetailState extends State<WisataDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Wisata',
          style: TextStyle(
            fontFamily: 'Helvetica', // Menggunakan font Helvetica
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.yellow[700], // Warna kuning pada AppBar
      ),
      body: Container(
        color: Colors.yellow[50], // Warna kuning pada background body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Destinasi: ${widget.wisata!.destination}",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'Helvetica', // Font Helvetica
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Lokasi: ${widget.wisata!.location}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Helvetica', // Font Helvetica
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Atraksi: ${widget.wisata!.attraction}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Helvetica', // Font Helvetica
              ),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WisataForm(
                  wisata: widget.wisata!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            WisataBloc.deleteWisata(id: widget.wisata!.id!).then(
              (value) => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WisataPage()))
              },
              onError: (error) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                          description: "Hapus gagal, silahkan coba lagi",
                        ));
              },
            );
          },
        ),
        // Tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
