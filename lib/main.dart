import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QueMap',
      theme: ThemeData(
        primaryColor: Color(0xFFF15A29),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF15A29),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFF15A29),
          secondary: Color(0xFFFF911D),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF15A29),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFFF911D), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFFF911D),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isAnonymousGlobally = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setAnonymousGlobal(bool value) {
    setState(() {
      _isAnonymousGlobally = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomePage(isAnonymousGlobal: _isAnonymousGlobally),
      MapPage(),
      ProfilePage(
        isAnonymousGlobal: _isAnonymousGlobally,
        onAnonymousGlobalChanged: _setAnonymousGlobal,
      ),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isAnonymousGlobal;

  HomePage({required this.isAnonymousGlobal});

  final List<Destination> savedDestinations = [
    destinations[0],
    destinations[2],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (c, e, s) => Icon(Icons.image, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text("QueWander Dashboard"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => SavedDestinationsScreen(
                        savedDestinations: savedDestinations,
                      ),
                ),
              );
            },
            tooltip: 'View Saved Destinations',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to QueWander!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFFF15A29),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => GeneralForumScreen(
                          isAnonymousDefault: isAnonymousGlobal,
                        ),
                  ),
                );
              },
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: Text('General Forum'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Top Destinations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF15A29),
              ),
            ),
            SizedBox(height: 16),
            ...destinations.map(
              (destination) => Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DestinationDetailScreen(
                                destination: destination,
                              ),
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            destination.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (c, e, s) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                destination.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF911D),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${destination.rating} ⭐',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng center = LatLng(13.95, 121.6);
  final LatLngBounds quezonBounds = LatLngBounds(
    LatLng(13.55, 121.15),
    LatLng(14.40, 122.45),
  );
  List<Marker> markers = [];
  TextEditingController _searchController = TextEditingController();
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _addDestinationMarkers();
  }

  void _addDestinationMarkers() {
    for (var dest in destinations) {
      if (dest.latitude != 0.0 && dest.longitude != 0.0) {
        markers.add(
          Marker(
            point: LatLng(dest.latitude, dest.longitude),
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${dest.name}')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DestinationDetailScreen(destination: dest),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFF15A29), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        dest.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (c, e, s) => Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Icon(Icons.location_on, color: Color(0xFFF15A29), size: 30),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  void _searchLocation(String query) {
    LatLng? foundLocation;
    String message = 'Location not found for "$query"';

    final matchingDestination = destinations.firstWhere(
      (dest) => dest.name.toLowerCase().contains(query.toLowerCase()),
      orElse:
          () => Destination(
            name: '',
            description: '',
            imageUrl: '',
            rating: 0.0,
            latitude: 0.0,
            longitude: 0.0,
          ),
    );

    if (matchingDestination.name.isNotEmpty &&
        matchingDestination.latitude != 0.0) {
      foundLocation = LatLng(
        matchingDestination.latitude,
        matchingDestination.longitude,
      );
      message = 'Navigating to ${matchingDestination.name}!';
    } else if (query.toLowerCase().contains('lucena')) {
      foundLocation = LatLng(13.93, 121.61);
      message = 'Navigating to Lucena City!';
    } else if (query.toLowerCase().contains('tayabas')) {
      foundLocation = LatLng(14.02, 121.57);
      message = 'Navigating to Tayabas City!';
    }

    if (foundLocation != null) {
      _mapController.move(foundLocation, 13.0);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (c, e, s) => Icon(Icons.image, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text("QueMap"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place in Quezon...',
                prefixIcon: Icon(Icons.search, color: Color(0xFFF15A29)),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                        : null,
              ),
              onChanged: (text) {
                setState(() {});
              },
              onSubmitted: _searchLocation,
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 10,
                minZoom: 9,
                maxZoom: 16,
                cameraConstraint: CameraConstraint.contain(
                  bounds: quezonBounds,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.que_map',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final bool isAnonymousGlobal;
  final Function(bool) onAnonymousGlobalChanged;

  ProfilePage({
    required this.isAnonymousGlobal,
    required this.onAnonymousGlobalChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isAnonymousGlobally;

  @override
  void initState() {
    super.initState();
    _isAnonymousGlobally = widget.isAnonymousGlobal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_rounded, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text("Profile"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFF15A29),
              child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "Peter Bob Domogma",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: Colors.grey[850],
              ),
            ),
            Text(
              "domogmapeterbob@gmail.com",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit Profile Pressed!')),
                );
              },
              icon: Icon(Icons.edit_rounded),
              label: Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 32),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFFF15A29),
                    ),
                    title: Text(
                      "General Forum",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => GeneralForumScreen(
                                isAnonymousDefault: _isAnonymousGlobally,
                              ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.inbox_rounded,
                      color: Color(0xFFF15A29),
                    ),
                    title: Text("Inbox", style: TextStyle(fontSize: 16)),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening Inbox...')),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text("Post Anonymously in Forums"),
                    subtitle: Text(
                      "Your name will not be displayed on your forum posts.",
                    ),
                    value: _isAnonymousGlobally,
                    onChanged: (bool value) {
                      setState(() {
                        _isAnonymousGlobally = value;
                      });
                      widget.onAnonymousGlobalChanged(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Anonymous posting set to $value'),
                        ),
                      );
                    },
                    secondary: Icon(
                      Icons.visibility_off_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.settings_rounded,
                      color: Color(0xFFF15A29),
                    ),
                    title: Text("Settings", style: TextStyle(fontSize: 16)),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening Settings...')),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                    ),
                    title: Text("Logout", style: TextStyle(fontSize: 16)),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Logging Out...')));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Destination {
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double latitude;
  final double longitude;

  Destination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });
}

List<Destination> destinations = [
  Destination(
    name: 'Kamay ni Hesus Shrine',
    description:
        'A renowned pilgrimage site featuring a 50-foot statue of Jesus.',
    imageUrl: 'assets/kamay_ni_hesus.jpg',
    rating: 4.8,
    latitude: 14.0725,
    longitude: 121.5240,
  ),
  Destination(
    name: 'Villa Escudero Plantations and Resort',
    description:
        'A historical plantation offering cultural experiences and a museum.',
    imageUrl: 'assets/villa_escudero.jpg',
    rating: 4.7,
    latitude: 14.0900,
    longitude: 121.3200,
  ),
  Destination(
    name: 'Cagbalete Island',
    description:
        'A serene island known for its white sand beaches and clear waters.',
    imageUrl: 'assets/cagbalete_island.jpg',
    rating: 4.6,
    latitude: 14.0500,
    longitude: 122.0500,
  ),
  Destination(
    name: 'Alibijaban Island',
    description: 'A hidden gem with pristine beaches and rich marine life.',
    imageUrl: 'assets/alibijaban_island.jpg',
    rating: 4.6,
    latitude: 13.5900,
    longitude: 122.5800,
  ),
  Destination(
    name: 'Ugu Bigyan Pottery',
    description: 'A famous pottery and art studio in Tiaong, Quezon.',
    imageUrl: 'assets/ugu_bigyan_pottery.jpg',
    rating: 4.5,
    latitude: 13.9800,
    longitude: 121.2900,
  ),
  Destination(
    name: 'St. Isidro Labrador Parish Church',
    description: 'A historical church located in Lucban.',
    imageUrl: 'assets/st_isidro_church.jpg',
    rating: 4.4,
    latitude: 14.1000,
    longitude: 121.5600,
  ),
  Destination(
    name: 'Sunshine Farm Philippines',
    description:
        'A farm promoting inclusive employment and sustainable agriculture.',
    imageUrl: 'assets/sunshine_farm.jpg',
    rating: 4.3,
    latitude: 14.0100,
    longitude: 121.2700,
  ),
  Destination(
    name: 'Alphaland Balesin Island Club',
    description: 'An exclusive island resort offering luxury accommodations.',
    imageUrl: 'assets/balesin_island.jpg',
    rating: 4.9,
    latitude: 14.4000,
    longitude: 122.6000,
  ),
  Destination(
    name: 'Quezon National Forest Park',
    description: 'A protected area with diverse flora and fauna.',
    imageUrl: 'assets/quezon_forest_park.jpg',
    rating: 4.5,
    latitude: 14.0000,
    longitude: 121.5000,
  ),
  Destination(
    name: 'Kanaway Beach',
    description: 'A tranquil beach destination ideal for relaxation.',
    imageUrl: 'assets/kanaway_beach.jpg',
    rating: 4.2,
    latitude: 13.9000,
    longitude: 122.1000,
  ),
];

class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;

  DestinationDetailScreen({required this.destination});

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.name),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isSaved ? Color(0xFFFF911D) : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isSaved
                        ? 'Saved ${widget.destination.name}!'
                        : 'Removed ${widget.destination.name} from saved.',
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: _isSaved ? 'Remove from saved' : 'Save destination',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.destination.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder:
                    (c, e, s) => Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 80,
                      ),
                    ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.destination.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF15A29),
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.destination.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                SizedBox(width: 4),
                Text(
                  'Rating: ${widget.destination.rating}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RatingsAndReviewsScreen(
                            destinationName: widget.destination.name,
                          ),
                    ),
                  ),
              icon: Icon(Icons.reviews_rounded),
              label: Text('View Ratings & Reviews'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFFFF911D),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                bool isAnonymousFromProfile = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DestinationForumScreen(
                          destination: widget.destination,
                          isAnonymousDefault: isAnonymousFromProfile,
                        ),
                  ),
                );
              },
              icon: Icon(Icons.forum_rounded),
              label: Text('Join Discussion for ${widget.destination.name}'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFFF15A29),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingsAndReviewsScreen extends StatefulWidget {
  final String destinationName;

  RatingsAndReviewsScreen({required this.destinationName});

  @override
  State<RatingsAndReviewsScreen> createState() =>
      _RatingsAndReviewsScreenState();
}

class _RatingsAndReviewsScreenState extends State<RatingsAndReviewsScreen> {
  final List<Map<String, String>> reviews = [
    {
      'author': 'Mina Salapare',
      'text': 'Ang ganda ng lugar! Super worth it bisitahin.',
      'rating': '5',
    },
    {
      'author': 'Sheree Ann Malapajo',
      'text': 'Gusto ko bumalik ulit. Sobrang nakamamangha ang views dito.',
      'rating': '4',
    },
    {
      'author': 'Earl Dane Deseo',
      'text': 'Great for family trips, daming activities for kids!',
      'rating': '5',
    },
    {
      'author': 'Aira Jeanelle',
      'text': 'Medyo crowded pero okay lang, enjoy pa rin ang experience.',
      'rating': '3',
    },
    {
      'author': 'Peter Bob Domogma',
      'text': 'Tahimik at nakakarelax. Perfect getaway talaga.',
      'rating': '5',
    },
    {
      'author': 'Mina Salapare',
      'text': 'Ang sarap ng mga pagkain dito sa malapit!',
      'rating': '4',
    },
    {
      'author': 'Sheree Ann Malapajo',
      'text':
          'Kailangan pa ng mas maraming amenities, but the natural beauty is superb.',
      'rating': '3',
    },
    {
      'author': 'Earl Dane Deseo',
      'text': 'Super nice place, perfect for unwinding. Babalik kami for sure!',
      'rating': '5',
    },
    {
      'author': 'Aira Jeanelle',
      'text':
          'Bit challenging ang daan, but the destination is worth it. Ganda!',
      'rating': '4',
    },
    {
      'author': 'Peter Bob Domogma',
      'text':
          'Nag-enjoy ang buong family. Highly recommended for a quick escape.',
      'rating': '5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews for ${widget.destinationName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'User Feedback',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review by ${review['author']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            review['text']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Rating: ${review['rating']} / 5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumMessage {
  final String author;
  final String text;
  final DateTime timestamp;
  final bool isAnonymous;
  final String? associatedLocation;

  ForumMessage({
    required this.author,
    required this.text,
    required this.timestamp,
    this.isAnonymous = false,
    this.associatedLocation,
  });
}

class GeneralForumScreen extends StatefulWidget {
  final bool isAnonymousDefault;

  GeneralForumScreen({this.isAnonymousDefault = false});

  @override
  State<GeneralForumScreen> createState() => _GeneralForumScreenState();
}

class _GeneralForumScreenState extends State<GeneralForumScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ForumMessage> _messages = [
    ForumMessage(
      author: 'Peter Bob Domogma',
      text:
          'Hello everyone! Excited to explore Quezon. Ang daming magagandang lugar dito!',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    ForumMessage(
      author: 'Anonymous',
      text:
          'Kamay ni Hesus is a must-visit for pilgrims. Nakaka-bless talaga doon.',
      timestamp: DateTime.now().subtract(Duration(minutes: 45)),
      isAnonymous: true,
      associatedLocation: 'Kamay ni Hesus Shrine',
    ),
    ForumMessage(
      author: 'Sheree Ann Malapajo',
      text:
          'Anyone planning a trip to Cagbalete Island soon? Gusto ko na ulit mag-beach!',
      timestamp: DateTime.now().subtract(Duration(minutes: 15)),
      associatedLocation: 'Cagbalete Island',
    ),
    ForumMessage(
      author: 'Mina Salapare',
      text: 'Must try ang pancit habhab sa Lucban! Super sarap.',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      associatedLocation: 'St. Isidro Labrador Parish Church',
    ),
    ForumMessage(
      author: 'Earl Dane Deseo',
      text:
          'Sobrang ganda ng Villa Escudero, lalo na yung falls dining experience. Highly recommended!',
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      associatedLocation: 'Villa Escudero Plantations and Resort',
    ),
    ForumMessage(
      author: 'Aira Jeanelle',
      text:
          'Hello, team! Anyone here from Lucena? Planning to visit next month.',
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      associatedLocation: 'Lucena City',
    ),
  ];

  bool _isAnonymous = false;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _isAnonymous = widget.isAnonymousDefault;
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(
          ForumMessage(
            author: 'Peter Bob Domogma',
            text: _messageController.text,
            timestamp: DateTime.now(),
            isAnonymous: _isAnonymous,
            associatedLocation: _selectedLocation,
          ),
        );
        _messageController.clear();
        _selectedLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('General Forum')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ForumMessageTile(message: message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Referencing Location (Optional)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  value: _selectedLocation,
                  items: [
                    DropdownMenuItem(value: null, child: Text('None')),
                    ...destinations.map((dest) {
                      return DropdownMenuItem(
                        value: dest.name,
                        child: Text(dest.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _sendMessage,
                      mini: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.send_rounded, color: Colors.white),
                      tooltip: 'Send Message',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationForumScreen extends StatefulWidget {
  final Destination destination;
  final bool isAnonymousDefault;

  DestinationForumScreen({
    required this.destination,
    this.isAnonymousDefault = false,
  });

  @override
  State<DestinationForumScreen> createState() => _DestinationForumScreenState();
}

class _DestinationForumScreenState extends State<DestinationForumScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ForumMessage> _messages = [];

  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _isAnonymous = widget.isAnonymousDefault;
    _messages.add(
      ForumMessage(
        author: 'Mina Salapare',
        text:
            'Just visited ${widget.destination.name}! It was amazing! Ang ganda talaga dito.',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        associatedLocation: widget.destination.name,
      ),
    );
    _messages.add(
      ForumMessage(
        author: 'Anonymous',
        text:
            'The best time to visit is early morning to avoid crowds. Mas peaceful pag maaga.',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        isAnonymous: true,
        associatedLocation: widget.destination.name,
      ),
    );
    _messages.add(
      ForumMessage(
        author: 'Peter Bob Domogma',
        text: 'Napakasarap ng local food sa area! Must try talaga.',
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        associatedLocation: widget.destination.name,
      ),
    );
    _messages.add(
      ForumMessage(
        author: 'Sheree Ann Malapajo',
        text: 'Planning to go next month! Any tips for first-timers?',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        associatedLocation: widget.destination.name,
      ),
    );
    _messages.add(
      ForumMessage(
        author: 'Earl Dane Deseo',
        text:
            'Super init ngayon, but the beach is still worth it. Bring lots of water!',
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        associatedLocation: widget.destination.name,
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(
          ForumMessage(
            author: 'Peter Bob Domogma',
            text: _messageController.text,
            timestamp: DateTime.now(),
            isAnonymous: _isAnonymous,
            associatedLocation: widget.destination.name,
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discussion for ${widget.destination.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ForumMessageTile(message: message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText:
                          'Share your thoughts about ${widget.destination.name}...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.send_rounded, color: Colors.white),
                  tooltip: 'Send Message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForumMessageTile extends StatelessWidget {
  final ForumMessage message;

  ForumMessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.isAnonymous ? 'Anonymous' : message.author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (message.associatedLocation != null &&
                          message.associatedLocation!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Chip(
                            label: Text(
                              message.associatedLocation!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  DateFormat('MMM d, hh:mm a').format(message.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              message.text,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedDestinationsScreen extends StatelessWidget {
  final List<Destination> savedDestinations;

  SavedDestinationsScreen({required this.savedDestinations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Destinations')),
      body:
          savedDestinations.isEmpty
              ? Center(
                child: Text(
                  'No saved destinations yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: savedDestinations.length,
                itemBuilder: (context, index) {
                  final destination = savedDestinations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DestinationDetailScreen(
                                    destination: destination,
                                  ),
                            ),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                destination.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (c, e, s) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destination.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    destination.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF911D),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${destination.rating} ⭐',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
