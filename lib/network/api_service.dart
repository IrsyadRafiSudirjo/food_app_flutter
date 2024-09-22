import 'dart:convert';
import 'package:food_app/model/area.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/model/meal_detail.dart';
import 'package:http/http.dart' as http;

Future<List<Meal>> fetchMealsByAreaDefaultJapanese() async {
  final response = await http.get(Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php?a=American'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    //validasi bila datanya null
    if (json['meals'] == null) {
      return [];
    }

    final List mealsJson = json['meals'];
    return mealsJson.map((meal) => Meal.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}

Future<List<Meal>> fetchMealsByAreaSearchInput(String inputData) async {
  final response = await http.get(Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php?a=$inputData'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    //validasi bila datanya null
    if (json['meals'] == null) {
      return [];
    }

    final List mealsJson = json['meals'];
    return mealsJson.map((meal) => Meal.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}

Future<List<Area>> fetchArea() async {
  final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    //validasi bila datanya null
    if (json['meals'] == null) {
      return [];
    }

    final List mealsJson = json['meals'];
    return mealsJson.map((meal) => Area.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load area');
  }
}

Future<MealDetail> fetchMealsById(String id) async {
  final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    if (json['meals'] == null || (json['meals'] as List).isEmpty) {
      return MealDetail(
          idMeal: "0",
          strMeal: "strMeal",
          strCategory: "strCategory",
          strArea: "strArea",
          strInstructions: "strInstructions",
          strMealThumb: "strMealThumb");
    }

    return MealDetail.fromJson(json['meals'][0]);
  } else {
    throw Exception('Failed to load meal details');
  }
}
