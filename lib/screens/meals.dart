import 'package:flutter/material.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:meals/screens/meals_details.dart';
import 'package:meals/widgets/meal_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealsScreen extends ConsumerWidget {
  const MealsScreen({
    super.key,
    required this.meals,
    this.title,
  });
  final String? title;
  final List<Meal> meals;

  void _onSelectMeal(Meal meal, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailsScreen(
        meal: meal,
      ),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = RefreshIndicator(
      onRefresh: () async {
        ref.watch(mealsProvider.notifier).reloadMeals();
      },
      child: ListView.builder(
        itemBuilder: (context, index) => MealItem(
          meal: meals[index],
          onSelecteMeal: (meal) {
            _onSelectMeal(meal, context);
          },
        ),
        itemCount: meals.length,
      ),
    );
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'uhhh no meals here',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Try tapping to another category',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            )
          ],
        ),
      );
    }
    if (title == null) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
