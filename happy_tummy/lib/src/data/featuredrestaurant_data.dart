class Featured_Restaurant{
  final String id;
  final String name;
  final String imagePath;
  final double ratings;

  Featured_Restaurant ({this.id,this.name,this.imagePath,this.ratings });
}

final featured = [
  Featured_Restaurant(
    id: '1',
    name: "Trisara",
    imagePath: 'assets/images/trisara.jpeg',
    ratings: 99.0,
  ),
  Featured_Restaurant(
    id: '2',
    name: "Durbar",
    imagePath: 'assets/images/noimage.png',
    ratings: 99.0,
  ),

];
