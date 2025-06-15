import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final List<Map<String, String>> weatherData = [
    {'city': 'Thiruvananthapuram', 'temp': '27°C'},
    {'city': 'Kochi', 'temp': '27°C'},
    {'city': 'Kottayam', 'temp': '27°C'},
  ];

  final List<String> allDistricts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Kochi',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  void _addDistrict() {
    List<String> remainingDistricts =
        allDistricts
            .where(
              (district) =>
                  !weatherData.any((data) => data['city'] == district),
            )
            .toList();

    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView(
            children:
                remainingDistricts.map((district) {
                  return ListTile(
                    title: Text(district),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        weatherData.add({'city': district, 'temp': '27°C'});
                      });
                    },
                  );
                }).toList(),
          ),
    );
  }

  void _removeDistrict(int index) {
    setState(() {
      weatherData.removeAt(index);
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Logged out")));
                  // Add your actual logout logic here.
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF58A7F4),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/clouds.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weather',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _logout,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _addDistrict,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: weatherData.length,
                    itemBuilder: (context, index) {
                      final city = weatherData[index]['city']!;
                      final temp = weatherData[index]['temp']!;
                      return Dismissible(
                        key: Key(city),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _removeDistrict(index);
                        },
                        child: WeatherCard(city: city, temperature: temp),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String city;
  final String temperature;

  const WeatherCard({super.key, required this.city, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      child: ListTile(
        leading: Text(
          temperature,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        title: Text(city, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(
          Icons.wb_cloudy,
          size: 32,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}

