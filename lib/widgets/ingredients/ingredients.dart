import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './ingredient_card.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class Ingredients extends StatelessWidget {
  Widget _buildIngredientList(BuildContext context, List<Ingredient> ingredients) {
    var size = MediaQuery.of(context).size;

    double itemHeight = 0.0;
    double itemWidth = 0.0;
    int crossAxisCount = 0;

    if (size.width < 500) {
      crossAxisCount = 2;
      /*24 is for notification bar on Android*/
      itemHeight = (size.height - kToolbarHeight - 24) / 2.0;
      itemWidth = size.width / crossAxisCount;
    } else {
      crossAxisCount = 3;
      itemHeight = (size.height - kToolbarHeight - 24) / 1.1;
      itemWidth = size.width / crossAxisCount;
    }


    Widget ingredientCards;
    if (ingredients.length > 0) {
      ingredientCards = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemBuilder: (BuildContext context, int index) =>
            IngredientCard(ingredients[index], index),
        itemCount: ingredients.length,
      );
    } else {
      ingredientCards = Center(
        child: Text("No Ingredients found, please add some"),
      );
    }
    return ingredientCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildIngredientList(context, model.displayedIngredients);
      },
    );
  }
}