import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:http/http.dart' as http;

class MealsProviderNotifier extends StateNotifier<List<Meal>> {
  MealsProviderNotifier() : super([]) {
    _loadDb();
  }

  Future<void> _loadDb() async {
    final url = Uri.parse(
        'https://mealsapp-2a5df-default-rtdb.firebaseio.com/main-meals.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Meal> loadedMeals = [];

        data.forEach((mealId, mealData) {
          loadedMeals.add(Meal(
            id: mealId,
            categories: List<String>.from(mealData['categories']),
            title: mealData['title'],
            imageUrl: mealData['imageUrl'],
            ingredients: List<String>.from(mealData['ingredients']),
            steps: List<String>.from(mealData['steps']),
            duration: mealData['duration'],
            complexity: Complexity.values
                .firstWhere((e) => e.name == mealData['complexity']),
            affordability: Affordability.values
                .firstWhere((e) => e.name == mealData['affordability']),
            isGlutenFree: mealData['isGlutenFree'],
            isLactoseFree: mealData['isLactoseFree'],
            isVegan: mealData['isVegan'],
            isVegetarian: mealData['isVegetarian'],
          ));
        });

        state = loadedMeals;
      } else {
        // Handle error response
        print('Failed to load meals');
      }
    } catch (error) {
      print('Error loading meals: $error');
    }
  }

  Future<void> reloadMeals() async {
    await _loadDb();
  }
}

final mealsProvider = StateNotifierProvider<MealsProviderNotifier, List<Meal>>(
    (ref) => MealsProviderNotifier());
