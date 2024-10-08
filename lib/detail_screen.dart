import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/model/meal_detail.dart';
import 'package:food_app/network/api_service.dart';

var informationTextStyle = const TextStyle(fontFamily: 'Oxygen');

class DetailScreen extends StatefulWidget {
  final Meal meal;

  const DetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MealDetail?> mealDetail;

  @override
  void initState() {
    super.initState();
    mealDetail = fetchMealsById(widget.meal.id);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FutureBuilder<MealDetail?>(
          future: mealDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching meal details'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No meal details found'));
            } else {
              if (constraints.maxWidth > 800) {
                return DetailWebPage(meal: snapshot.data!);
              } else {
                return DetailMobilePage(meal: snapshot.data!);
              }
            }
          },
        );
      },
    );
  }
}

class DetailMobilePage extends StatelessWidget {
  final MealDetail meal;

  const DetailMobilePage({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  meal.strMealThumb,
                  fit: BoxFit.cover,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const FavoriteButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                meal.strMeal,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Staatliches',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Icon(Icons.restaurant),
                      const SizedBox(height: 8.0),
                      Text(
                        meal.strCategory,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Icon(Icons.flag),
                      const SizedBox(height: 8.0),
                      Text(
                        meal.strArea,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Icon(Icons.badge),
                      const SizedBox(height: 8.0),
                      Text(
                        meal.idMeal,
                        style: informationTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: const CounterButton(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                onPressed: () {},
                child: const Text("Add To Cart"),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                meal.strInstructions,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Oxygen',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailWebPage extends StatefulWidget {
  final MealDetail meal;

  const DetailWebPage({Key? key, required this.meal}) : super(key: key);

  @override
  _DetailWebPageState createState() => _DetailWebPageState();
}

class _DetailWebPageState extends State<DetailWebPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: kIsWeb ? null : AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 64,
          ),
          child: Center(
            child: SizedBox(
              width: screenWidth <= 1200 ? 800 : 1200,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Food Application Detail',
                      style: TextStyle(
                        fontFamily: 'Staatliches',
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.meal.strMealThumb,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const CounterButton(),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.yellow,
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Add To Cart"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    widget.meal.strMeal,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: 'Staatliches',
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          const Icon(Icons.restaurant),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            widget.meal.strCategory,
                                            style: informationTextStyle,
                                          ),
                                        ],
                                      ),
                                      const FavoriteButton(),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.flag),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        widget.meal.strArea,
                                        style: informationTextStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.badge),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        widget.meal.idMeal,
                                        style: informationTextStyle,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(
                                      widget.meal.strInstructions,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Oxygen',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CounterButton extends StatefulWidget {
  const CounterButton({Key? key}) : super(key: key);

  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (counter != 0) {
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 10,
                color: const Color(0xFFB0B0B0).withOpacity(0.2),
              ),
            ],
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF7643),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: _decrementCounter,
            child: Icon(Icons.remove, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '$counter',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 10,
                color: const Color(0xFFB0B0B0).withOpacity(0.2),
              ),
            ],
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF7643),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: _incrementCounter,
            child: Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
