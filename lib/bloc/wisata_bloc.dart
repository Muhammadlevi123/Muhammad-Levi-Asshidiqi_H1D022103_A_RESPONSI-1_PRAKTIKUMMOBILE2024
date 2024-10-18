import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/wisata.dart';

class WisataBloc {
  // Mendapatkan list wisata
  static Future<List<Wisata>> getWisata() async {
    String apiUrl = ApiUrl.listWisata;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listWisata = (jsonObj as Map<String, dynamic>)['data'];
    List<Wisata> wisatas = [];
    for (int i = 0; i < listWisata.length; i++) {
      wisatas.add(Wisata.fromJson(listWisata[i]));
    }
    return wisatas;
  }

  // Menambahkan wisata baru
  static Future addWisata({Wisata? wisata}) async {
    String apiUrl = ApiUrl.createWisata;

    var body = {
      "destination": wisata!.destination,
      "location": wisata.location,
      "attraction": wisata.attraction
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Meng-update data wisata
  static Future updateWisata({required Wisata wisata}) async {
    String apiUrl = ApiUrl.updateWisata(wisata.id!);
    print(apiUrl);

    var body = {
      "destination": wisata.destination,
      "location": wisata.location,
      "attraction": wisata.attraction
    };
    var response = await Api().put(apiUrl, jsonEncode(body));

    
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Menghapus wisata
  static Future<bool> deleteWisata({int? id}) async {
    String apiUrl = ApiUrl.deleteWisata(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
