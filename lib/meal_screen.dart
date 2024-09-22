import 'package:flutter/material.dart';
import 'package:food_app/detail_screen.dart';
import 'package:food_app/model/area.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/network/api_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Meal>> futureMeals;
  late Future<List<Area>> futureArea;
  String? selectedArea;

  //jalanin pertama kali di inisiasi
  @override
  void initState() {
    super.initState();
    futureArea = fetchArea();
    futureMeals = fetchMealsByAreaDefaultJapanese();
  }

  //fungsi pencarian
  void _searchMeals() {
    if (selectedArea != null && selectedArea!.isNotEmpty) {
      setState(() {
        futureMeals = fetchMealsByAreaSearchInput(selectedArea!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Application'),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Area>>(
            future: futureArea,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // sedang menunggu atau fetching data
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // jika error
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // sedang ada data
                final areas = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    hint: const Text('Select Area'),
                    value: selectedArea,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedArea = newValue;
                      });
                    },
                    items: areas.map<DropdownMenuItem<String>>((Area area) {
                      return DropdownMenuItem<String>(
                        value: area.name,
                        child: Text(area.name),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
          ElevatedButton(
            onPressed: _searchMeals,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
            ),
            child: const Text('Search'),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final meals = snapshot.data!;

                  if (meals.isNotEmpty) {
                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth <= 600) {
                          return MealList(meals: meals);
                        } else {
                          return MealGrid(gridCount: 5, meals: meals);
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MealGrid extends StatelessWidget {
  final int gridCount;
  final List<Meal> meals;

  const MealGrid({Key? key, required this.gridCount, required this.meals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
        crossAxisCount: gridCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: meals.map((meal) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(meal: meal);
              }));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.white,
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  children: <Widget>[
                    // Image section
                    AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        meal.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Data section
                    Padding(
                      padding: const EdgeInsets.all(8.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            meal.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16, // Adjust font size for better fit
                            ),
                            overflow: TextOverflow.ellipsis, // Prevent overflow
                            maxLines: 1, // Limit to one line
                          ),
                          const SizedBox(
                              height: 4), // Space between name and ID
                          Text(
                            'Meal ID: ${meal.id}',
                            style: TextStyle(
                              fontSize: 12, // Smaller font size
                              color: Colors.grey.withOpacity(0.8),
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
        }).toList(),
      ),
    );
  }
}

class MealList extends StatelessWidget {
  final List<Meal> meals;

  const MealList({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final Meal meal = meals[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(meal: meal);
              }));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.white,
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        // Image section
                        AspectRatio(
                          aspectRatio: 2,
                          child: Image.network(
                            meal.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Data section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                meal.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(
                                  height: 4), // Space between name and ID
                              Text(
                                'Meal ID: ${meal.id}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Favorite icon positioned at the top right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            // Handle favorite action
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.restaurant,
                              color:
                                  Colors.yellow, // Change to your desired color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: meals.length,
      ),
    );
  }
}
