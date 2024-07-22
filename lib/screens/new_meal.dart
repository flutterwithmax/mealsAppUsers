import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:http/http.dart' as http;

class NewMealScreen extends StatefulWidget {
  const NewMealScreen({super.key});

  @override
  State<NewMealScreen> createState() => _NewMealScreenState();
}

class _NewMealScreenState extends State<NewMealScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedTitle = '';
  String _selectedUrl = '';
  int _duration = 1;

  bool _isItalian = false;
  bool _isQuickAndEasy = false;
  bool _isHamburgers = false;
  bool _isGerman = false;
  bool _isLightAndLovely = false;
  bool _isExotic = false;
  bool _isBreakfast = false;
  bool _isAsian = false;
  bool _isFrench = false;
  bool _isSummer = false;
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _isVegetarian = false;
  bool _isVegan = false;
  Complexity _selectedComplexity = Complexity.simple;
  Affordability _selectedAffordability = Affordability.affordable;

  List<String> ingredients = [];

  List<String> steps = [];
  List<String> categories = [];

  void _updateCategories() {
    categories.clear();
    if (_isItalian) categories.add('c1');
    if (_isQuickAndEasy) categories.add('c2');
    if (_isHamburgers) categories.add('c3');
    if (_isGerman) categories.add('c4');
    if (_isLightAndLovely) categories.add('c5');
    if (_isExotic) categories.add('c6');
    if (_isBreakfast) categories.add('c7');
    if (_isAsian) categories.add('c8');
    if (_isFrench) categories.add('c9');
    if (_isSummer) categories.add('c10');
    print(categories);
  }

  void _saveMeal() async {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose on of the categories'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https('mealsapp-2a5df-default-rtdb.firebaseio.com',
          'userdadded-meals.json');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'categories': categories,
            'title': _selectedTitle,
            'imageUrl': _selectedUrl,
            'ingredients': ingredients,
            'steps': steps,
            'duration': _duration,
            'complexity': _selectedComplexity.name,
            'affordability': _selectedAffordability.name,
            'isGlutenFree': _isGlutenFree,
            'isLactoseFree': _isLactoseFree,
            'isVegan': _isVegan,
            'isVegetarian': _isVegetarian,
          }));
      print(response.statusCode);
      print(response.body);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new meal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                    maxLength: 50,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (newValue) {
                      _selectedTitle = newValue!;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 300) {
                        return 'Please enter valid url';
                      }
                      return null;
                    },
                    maxLength: 300,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(labelText: 'Image Url'),
                    onSaved: (newValue) {
                      _selectedUrl = newValue!;
                    },
                  ),
                  TextFormField(
                    initialValue: '10',
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Please enter valid number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        const InputDecoration(labelText: 'Duration in minutes'),
                    onSaved: (newValue) {
                      _duration = int.parse(newValue!);
                    },
                  ),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      onSaved: (newValue) {
                        ingredients = newValue!.split(',');
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter valid letters';
                        }
                        return null;
                      },
                      maxLines: null,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Put a comma to set next step'),
                    ),
                  ),
                  Text(
                    'Steps',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      onSaved: (newValue) {
                        steps = newValue!.split(',');
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter valid letters';
                        }
                        return null;
                      },
                      maxLines: null,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Put a comma to set a next ingredient'),
                    ),
                  ),
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 5.0, // Spacing between checkboxes
                    children: <Widget>[
                      FilterChip(
                        label: const Text(
                          'Gluten Free',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        selected: _isGlutenFree,
                        onSelected: (bool selected) {
                          setState(() {
                            _isGlutenFree = selected;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text(
                          'Lactose Free',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        selected: _isLactoseFree,
                        onSelected: (bool selected) {
                          setState(() {
                            _isLactoseFree = selected;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text(
                          'Vegetarian',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        selected: _isVegetarian,
                        onSelected: (bool selected) {
                          setState(() {
                            _isVegetarian = selected;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text(
                          'Vegan',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        selected: _isVegan,
                        onSelected: (bool selected) {
                          setState(() {
                            _isVegan = selected;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Complexity',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoSegmentedControl<Complexity>(
                    children: const {
                      Complexity.simple: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Simple',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Complexity.challenging: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Challenging',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Complexity.hard: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Hard',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    },
                    onValueChanged: (Complexity value) {
                      setState(() {
                        _selectedComplexity = value;
                      });
                    },
                    groupValue: _selectedComplexity,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Affordability',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoSegmentedControl<Affordability>(
                    children: const {
                      Affordability.affordable: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Affordable',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Affordability.pricey: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Pricey',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Affordability.luxurious: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Luxurious',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    },
                    onValueChanged: (Affordability value) {
                      setState(() {
                        _selectedAffordability = value;
                      });
                    },
                    groupValue: _selectedAffordability,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CheckboxListTile(
                    title: const Text('Italian'),
                    value: _isItalian,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isItalian = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Quick & Easy'),
                    value: _isQuickAndEasy,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isQuickAndEasy = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Hamburgers'),
                    value: _isHamburgers,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isHamburgers = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('German'),
                    value: _isGerman,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isGerman = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Light & Lovely'),
                    value: _isLightAndLovely,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isLightAndLovely = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Exotic'),
                    value: _isExotic,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isExotic = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Breakfast'),
                    value: _isBreakfast,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isBreakfast = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Asian'),
                    value: _isAsian,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isAsian = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('French'),
                    value: _isFrench,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isFrench = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Summer'),
                    value: _isSummer,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isSummer = newValue ?? false;
                        _updateCategories();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _saveMeal,
                        child: const Text('Submit'),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
