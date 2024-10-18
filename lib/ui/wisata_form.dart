import 'package:flutter/material.dart';
import '../bloc/wisata_bloc.dart';
import '../widget/warning_dialog.dart';
import '/model/wisata.dart';
import 'wisata_page.dart';

class WisataForm extends StatefulWidget {
  Wisata? wisata;
  WisataForm({Key? key, this.wisata}) : super(key: key);

  @override
  _WisataFormState createState() => _WisataFormState();
}

class _WisataFormState extends State<WisataForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH WISATA";
  String tombolSubmit = "SIMPAN";

  final _destinationTextboxController = TextEditingController();
  final _locationTextboxController = TextEditingController();
  final _attractionTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.wisata != null) {
      setState(() {
        judul = "UBAH WISATA";
        tombolSubmit = "UBAH";
        _destinationTextboxController.text = widget.wisata!.destination!;
        _locationTextboxController.text = widget.wisata!.location!;
        _attractionTextboxController.text = widget.wisata!.attraction!;
      });
    } else {
      judul = "TAMBAH WISATA";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.yellow[700], // Yellow AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _destinationTextField(),
                SizedBox(height: 16),
                _locationTextField(),
                SizedBox(height: 16),
                _attractionTextField(),
                SizedBox(height: 32),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _destinationTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Destination",
        labelStyle: TextStyle(color: Colors.yellow[800]),
        filled: true,
        fillColor: Colors.yellow[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _destinationTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Destination must be filled";
        }
        return null;
      },
    );
  }

  Widget _locationTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Location",
        labelStyle: TextStyle(color: Colors.yellow[800]),
        filled: true,
        fillColor: Colors.yellow[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _locationTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Location must be filled";
        }
        return null;
      },
    );
  }

  Widget _attractionTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Attraction",
        labelStyle: TextStyle(color: Colors.yellow[800]),
        filled: true,
        fillColor: Colors.yellow[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _attractionTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Attraction must be filled";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      child: Text(tombolSubmit),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.yellow[700],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.wisata != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  Future<void> simpan() async {
  setState(() {
    _isLoading = true;
  });

  try {
    Wisata createWisata = Wisata(id: null);
    createWisata.destination = _destinationTextboxController.text;
    createWisata.location = _locationTextboxController.text;
    createWisata.attraction = _attractionTextboxController.text;

    await WisataBloc.addWisata(wisata: createWisata);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const WisataPage()));
  } catch (error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "Simpan gagal, silahkan coba lagi",
      ));
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  void ubah() {
    setState(() {
      _isLoading = true;
    });

    Wisata updateWisata = Wisata(id: widget.wisata!.id!);
    updateWisata.destination = _destinationTextboxController.text;
    updateWisata.location = _locationTextboxController.text;
    updateWisata.attraction = _attractionTextboxController.text;

    WisataBloc.updateWisata(wisata: updateWisata).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const WisataPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });

    setState(() {
      _isLoading = false;
    });
  }
}
