class Wisata {
  int? id;
  String? destination;
  String? location;
  String? attraction;

  Wisata({this.id, this.destination, this.location, this.attraction});

  factory Wisata.fromJson(Map<String, dynamic> obj) {
  return Wisata(
    id: obj['id'] is int ? obj['id'] : int.tryParse(obj['id'].toString() ?? '0'), // Convert id to int
    destination: obj['destination']?.toString(), // Ensure it's a string
    location: obj['location']?.toString(), // Ensure it's a string
    attraction: obj['attraction']?.toString(), // Ensure it's a string
  );
}


  get imageUrl => null;
}
