import '../models/place.dart';

class PlaceRepository {
  final List<Place> _places = [];

  PlaceRepository() {
    _places.addAll([

      // ================= BEACHES (10) =================
      Place('b1','Unawatuna Beach','Golden sand beach','Beach','Galle',50,
          imagePath:'assets/images/unawatuna.jpg',hotels:['Ocean View','Sunset Resort'],rating:4.5),
      Place('b2','Mirissa','Whale watching beach','Beach','Matara',60,
          imagePath:'assets/images/mirissa.jpg',hotels:['Mirissa Bay','Seaside Inn'],rating:4.7),
      Place('b3','Bentota','Luxury beach','Beach','Bentota',70,
          imagePath:'assets/images/bentota.jpg',hotels:['AVANI','Cinnamon Bentota'],rating:4.6),
      Place('b4','Hikkaduwa','Coral reefs','Beach','Hikkaduwa',55,
          imagePath:'assets/images/hikkaduwa.jpg',hotels:['Coral Sands','Hikka Bliss'],rating:4.4),
      Place('b5','Arugam Bay','Surfing hotspot','Beach','Pottuvil',65,
          imagePath:'assets/images/arugambay.jpg',hotels:['Surf Lodge','Bay Vista'],rating:4.8),
      Place('b6','Nilaveli','Calm beach','Beach','Trincomalee',45,
          imagePath:'assets/images/nilaveli.jpg',hotels:['Nilaveli Resort','Blue Wave'],rating:4.5),
      Place('b7','Pasikuda','Shallow waters','Beach','Batticaloa',50,
          imagePath:'assets/images/pasikuda.jpg',hotels:['Amaya','Uga Bay'],rating:4.6),
      Place('b8','Kalpitiya','Dolphin watching','Beach','Puttalam',55,
          imagePath:'assets/images/kalpitiya.jpg',hotels:['Dolphin Beach','Kite Resort'],rating:4.4),
      Place('b9','Tangalle','Peaceful beach','Beach','Tangalle',48,
          imagePath:'assets/images/tangalle.jpg',hotels:['Anantara','Palm Paradise'],rating:4.5),
      Place('b10','Weligama','Surf bay','Beach','Weligama',52,
          imagePath:'assets/images/weligama.jpg',hotels:['Bay Resort','Surf Villa'],rating:4.6),

      // ================= CULTURE (10) =================
      Place('c1','Sigiriya','Rock fortress','Culture','Sigiriya',40,
          imagePath:'assets/images/sigiriya.jpg',hotels:['Rock View','Sky Resort'],rating:4.7),
      Place('c2','Polonnaruwa','Ancient ruins','Culture','Polonnaruwa',30,
          imagePath:'assets/images/polonnaruwa.jpg',hotels:['Heritage','Cultural Stay'],rating:4.3),
      Place('c3','Anuradhapura','Sacred city','Culture','Anuradhapura',35,
          imagePath:'assets/images/anuradhapura.jpg',hotels:['Rajarata','Sacred City'],rating:4.6),
      Place('c4','Kandy','Temple of Tooth','Culture','Kandy',45,
          imagePath:'assets/images/kandy.jpg',hotels:['Queens','Earl’s Regency'],rating:4.5),
      Place('c5','Dambulla Cave Temple','Cave temple','Culture','Dambulla',30,
          imagePath:'assets/images/dambulla.jpg',hotels:['Golden Temple','Heritage'],rating:4.4),
      Place('c6','Galle Fort','Colonial fort','Culture','Galle',40,
          imagePath:'assets/images/gallefort.jpg',hotels:['Fort Bazaar','Heritage Galle'],rating:4.6),
      Place('c7','Kelaniya Temple','Buddhist temple','Culture','Kelaniya',25,
          imagePath:'assets/images/kelaniya.jpg',hotels:['River Face','Temple View'],rating:4.3),
      Place('c8','Yapahuwa','Rock fortress','Culture','Kurunegala',28,
          imagePath:'assets/images/yapahuwa.jpg',hotels:['Yapahuwa Lodge','Rock Inn'],rating:4.2),
      Place('c9','Aluvihare','Scripture temple','Culture','Matale',25,
          imagePath:'assets/images/aluvihare.jpg',hotels:['Matale Rest','Temple Inn'],rating:4.1),
      Place('c10','Thuparamaya','Oldest stupa','Culture','Anuradhapura',20,
          imagePath:'assets/images/thuparamaya.jpg',hotels:['Ancient City','Stupa View'],rating:4.4),

      // ================= SAFARI (10) =================
      Place('s1','Yala','Leopard safari','Safari','Yala',200,
          imagePath:'assets/images/yala.jpg',hotels:['Safari Lodge','Wildlife Resort'],rating:4.8),
      Place('s2','Udawalawe','Elephants','Safari','Udawalawe',150,
          imagePath:'assets/images/udawalawe.jpg',hotels:['Elephant Trail','Safari Camp'],rating:4.7),
      Place('s3','Wilpattu','Natural lakes','Safari','Wilpattu',180,
          imagePath:'assets/images/wilpattu.jpg',hotels:['Forest Lodge','Nature Stay'],rating:4.6),
      Place('s4','Minneriya','Elephant gathering','Safari','Minneriya',160,
          imagePath:'assets/images/minneriya.jpg',hotels:['Lake Lodge','Safari Inn'],rating:4.5),
      Place('s5','Kumana','Bird sanctuary','Safari','Kumana',140,
          imagePath:'assets/images/kumana.jpg',hotels:['Bird Park','Eco Stay'],rating:4.4),
      Place('s6','Bundala','Wetland birds','Safari','Hambantota',130,
          imagePath:'assets/images/bundala.jpg',hotels:['Wetland Lodge','Bird Resort'],rating:4.3),
      Place('s7','Gal Oya','Boat safari','Safari','Ampara',170,
          imagePath:'assets/images/galoya.jpg',hotels:['Gal Oya Lodge','Nature Camp'],rating:4.6),
      Place('s8','Lunugamvehera','Wildlife park','Safari','Hambantota',145,
          imagePath:'assets/images/lunugamvehera.jpg',hotels:['Wild Lodge','Safari Rest'],rating:4.2),
      Place('s9','Maduru Oya','Elephant park','Safari','Mahiyanganaya',150,
          imagePath:'assets/images/maduruoya.jpg',hotels:['Jungle Stay','Eco Lodge'],rating:4.3),
      Place('s10','Wasgamuwa','Biodiversity park','Safari','Wasgamuwa',155,
          imagePath:'assets/images/wasgamuwa.jpg',hotels:['Wasgamuwa Lodge','Wild Camp'],rating:4.4),

      // ================= NATURE (10) =================
      Place('n1','Ella','Mountain village','Nature','Ella',50,
          imagePath:'assets/images/ella.jpg',hotels:['Mountain View','Ella Rock'],rating:4.8),
      Place('n2','Horton Plains','World’s End','Nature','Nuwara Eliya',60,
          imagePath:'assets/images/horton.jpg',hotels:['Nature Lodge','Highland Inn'],rating:4.7),
      Place('n3','Knuckles','Hiking trails','Nature','Matale',80,
          imagePath:'assets/images/knuckles.jpg',hotels:['Eco Camp','Mountain Hut'],rating:4.6),
      Place('n4','Sinharaja','Rainforest','Nature','Deniyaya',70,
          imagePath:'assets/images/sinharaja.jpg',hotels:['Rainforest Lodge','Eco Retreat'],rating:4.8),
      Place('n5','Nuwara Eliya','Tea country','Nature','Nuwara Eliya',55,
          imagePath:'assets/images/nuwaraeliya.jpg',hotels:['Grand Hotel','Tea Bungalow'],rating:4.5),
      Place('n6','Riverston','Mist mountains','Nature','Matale',65,
          imagePath:'assets/images/riverston.jpg',hotels:['Riverston Rest','Cloud Stay'],rating:4.6),
      Place('n7','Bambarakanda Falls','Highest waterfall','Nature','Badulla',40,
          imagePath:'assets/images/bambarakanda.jpg',hotels:['Falls View','Nature Inn'],rating:4.5),
      Place('n8','Meemure','Remote village','Nature','Kandy',45,
          imagePath:'assets/images/meemure.jpg',hotels:['Village Stay','Eco Home'],rating:4.7),
      Place('n9','Pidurangala','Rock hike','Nature','Sigiriya',35,
          imagePath:'assets/images/pidurangala.jpg',hotels:['Rock Base','Nature Stay'],rating:4.6),
      Place('n10','Belihuloya','River & hills','Nature','Ratnapura',42,
          imagePath:'assets/images/belihuloya.jpg',hotels:['River Resort','Green View'],rating:4.4),
    ]);
  }

  List<Place> all() => List.unmodifiable(_places);
}


