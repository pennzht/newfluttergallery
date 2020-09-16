import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


// BEGIN sharedZAxisTransitionDemo

class SharedZAxisTransitionDemo extends StatelessWidget {
  const SharedZAxisTransitionDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    Text(
                      'Shared z-axis',
                    ),
                    Text(
                      '(${'Settings icon button'})',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).push<void>(_createSettingsRoute());
                    },
                  ),
                ],
              ),
              body: const _RecipePage(),
            );
          },
        );
      },
    );
  }

  Route _createSettingsRoute() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const _SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          fillColor: Colors.transparent,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        );
      },
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    

    final settingsList = <_SettingsInfo>[
      _SettingsInfo(
        Icons.person,
        'Profile',
      ),
      _SettingsInfo(
        Icons.notifications,
        'Notifications',
      ),
      _SettingsInfo(
        Icons.security,
        'Privacy',
      ),
      _SettingsInfo(
        Icons.help,
        'Help',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          for (var setting in settingsList) _SettingsTile(setting),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile(this.settingData);
  final _SettingsInfo settingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(settingData.settingIcon),
          title: Text(settingData.settingsLabel),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class _SettingsInfo {
  const _SettingsInfo(this.settingIcon, this.settingsLabel);

  final IconData settingIcon;
  final String settingsLabel;
}

class _RecipePage extends StatelessWidget {
  const _RecipePage();

  @override
  Widget build(BuildContext context) {
    

    final savedRecipes = <_RecipeInfo>[
      _RecipeInfo(
        'Burger',
        'Burger recipe',
        'crane/destinations/eat_2.jpg',
      ),
      _RecipeInfo(
        'Sandwich',
        'Sandwich recipe',
        'crane/destinations/eat_3.jpg',
      ),
      _RecipeInfo(
        'Dessert',
        'Dessert recipe',
        'crane/destinations/eat_4.jpg',
      ),
      _RecipeInfo(
        'Shrimp',
        'Shrimp plate recipe',
        'crane/destinations/eat_6.jpg',
      ),
      _RecipeInfo(
        'Crab',
        'Crab plate recipe',
        'crane/destinations/eat_8.jpg',
      ),
      _RecipeInfo(
        'Beef sandwich',
        'Beef sandwich recipe',
        'crane/destinations/eat_10.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8.0),
          child: Text('Saved recipes'),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (var recipe in savedRecipes)
                _RecipeTile(recipe, savedRecipes.indexOf(recipe))
            ],
          ),
        ),
      ],
    );
  }
}

class _RecipeInfo {
  const _RecipeInfo(this.recipeName, this.recipeDescription, this.recipeImage);

  final String recipeName;
  final String recipeDescription;
  final String recipeImage;
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile(this._recipe, this._index);
  final _RecipeInfo _recipe;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 70,
          width: 100,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: Image.asset(
              _recipe.recipeImage,
              package: 'flutter_gallery_assets',
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              ListTile(
                title: Text(_recipe.recipeName),
                subtitle: Text(_recipe.recipeDescription),
                trailing: Text('0${_index + 1}'),
              ),
              const Divider(thickness: 2),
            ],
          ),
        ),
      ],
    );
  }
}

// END sharedZAxisTransitionDemo
// The following code allows the demo to be run
// as a standalone app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SharedZAxisTransitionDemo(),
    );
  }
}

