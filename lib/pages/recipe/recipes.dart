import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/recipes/recipes.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../scoped-models/main.dart';

class RecipesPage extends StatefulWidget {
  final MainModel model;

  RecipesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RecipesPageState();
  }
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchRecipes();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Choose"),
            ),
            Image.asset('assets/placeholder_logo.png', height: 100.0),
            Divider(),
            IngredientsListTile(),
            Divider(),
            RecipesAdminListTile(),
            Divider(),
            IngredientsAdminListTile(),
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Recipes Found!'));
        if (model.displayedRecipes.length > 0 && !model.isLoading) {
          content = Recipes();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchRecipes, child: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('App de nutrición'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              IconData favoriteIcon = model.displayRecipesFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border;
              return IconButton(
                icon: Icon(favoriteIcon),
                onPressed: () {
                  model.toggleRecipeDisplayMode();
                },
              );
            },
          ),
        ],
      ),
      // body: RecipeManager(startingRecipe:'Food Tester')
      body: _buildRecipesList(),
    );
  }
}
