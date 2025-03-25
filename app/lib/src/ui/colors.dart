// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

const double kColorItemHeight = 48;

class Palette {
  Palette({required this.name, required this.primary, required this.accent, this.threshold = 900});

  final String name;
  final MaterialColor primary;
  final MaterialAccentColor accent;
  final int? threshold; // titles for indices > threshold are white, otherwise black

  bool get isValid => name != null && primary != null && threshold != null;
}

final List<Palette> allPalettes = <Palette>[
  Palette(
      name: 'RED',
      primary: Colors.red,
      accent: Colors.redAccent,
      threshold: 300),
  Palette(
      name: 'PINK',
      primary: Colors.pink,
      accent: Colors.pinkAccent,
      threshold: 200),
  Palette(
      name: 'PURPLE',
      primary: Colors.purple,
      accent: Colors.purpleAccent,
      threshold: 200),
  Palette(
      name: 'DEEP PURPLE',
      primary: Colors.deepPurple,
      accent: Colors.deepPurpleAccent,
      threshold: 200),
  Palette(
      name: 'INDIGO',
      primary: Colors.indigo,
      accent: Colors.indigoAccent,
      threshold: 200),
  Palette(
      name: 'BLUE',
      primary: Colors.blue,
      accent: Colors.blueAccent,
      threshold: 400),
  Palette(
      name: 'LIGHT BLUE',
      primary: Colors.lightBlue,
      accent: Colors.lightBlueAccent,
      threshold: 500),
  Palette(
      name: 'CYAN',
      primary: Colors.cyan,
      accent: Colors.cyanAccent,
      threshold: 600),
  Palette(
      name: 'TEAL',
      primary: Colors.teal,
      accent: Colors.tealAccent,
      threshold: 400),
  Palette(
      name: 'GREEN',
      primary: Colors.green,
      accent: Colors.greenAccent,
      threshold: 500),
  Palette(
      name: 'LIGHT GREEN',
      primary: Colors.lightGreen,
      accent: Colors.lightGreenAccent,
      threshold: 600),
  Palette(
      name: 'LIME',
      primary: Colors.lime,
      accent: Colors.limeAccent,
      threshold: 800),
  Palette(name: 'YELLOW', primary: Colors.yellow, accent: Colors.yellowAccent),
  Palette(name: 'AMBER', primary: Colors.amber, accent: Colors.amberAccent),
  Palette(
      name: 'ORANGE',
      primary: Colors.orange,
      accent: Colors.orangeAccent,
      threshold: 700),
  Palette(
      name: 'DEEP ORANGE',
      primary: Colors.deepOrange,
      accent: Colors.deepOrangeAccent,
      threshold: 400),
];

class ColorItem extends StatelessWidget {
  const ColorItem({
    Key? key,
    required this.index,
    required this.color,
    this.prefix = '',
  })  : assert(index != null),
        assert(color != null),
        assert(prefix != null),
        super(key: key);

  final int index;
  final Color color;
  final String prefix;

  String colorString() =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        height: kColorItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: color,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(prefix),
              Text(colorString()),
            ],
          ),
        ),
      ),
    );
  }
}

class PaletteTabView extends StatelessWidget {
  PaletteTabView({Key? key, required this.colors, required this.onChangeSwatch})
      : assert(colors != null && colors.isValid),
        super(key: key);

  final Palette colors;
  final ValueChanged<Color> onChangeSwatch;

  static const List<int> primaryKeys = <int>[
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900
  ];
  static const List<int> accentKeys = <int>[100, 200, 400, 700];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle whiteTextStyle =
    textTheme.bodyMedium!.copyWith(color: Colors.white);
    final TextStyle blackTextStyle =
    textTheme.bodyMedium!.copyWith(color: Colors.black);
    return Scrollbar(
        child: ListView(
          itemExtent: kColorItemHeight,
          children: <Widget>[
            ...primaryKeys.map<Widget>((int index) {
              return DefaultTextStyle(
                style: index > colors.threshold! ? whiteTextStyle : blackTextStyle,
                child: InkWell(
                    onTap: () => onChangeSwatch(colors.primary),
                    child: ColorItem(index: index, color: colors.primary[index]!)),

              );
            }),
            if (colors.accent != null)
              ...accentKeys.map<Widget>((int index) {
                return DefaultTextStyle(
                  style: index > colors.threshold! ? whiteTextStyle : blackTextStyle,
                  child: InkWell(
                      onTap: () => onChangeSwatch(colors.accent),
                      child: ColorItem(
                          index: index, color: colors.accent[index]!, prefix: 'A')),
                );
              }),
          ],
        ));
  }
}

class ColorsDemo extends StatelessWidget {
  final ValueChanged<Palette> onChangeSwatch;
  ColorsDemo({Key? key, required this.onChangeSwatch}) : super(key: key);

  static const String routeName = '/colors';

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle whiteTextStyle =
    textTheme.bodyMedium!.copyWith(color: Colors.white);
    final TextStyle blackTextStyle =
    textTheme.bodyMedium!.copyWith(color: Colors.black);

    return DefaultTabController(
      length: allPalettes.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title:  Text(AppLocalizations.of(context).translate("colors")),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Scrollbar(
            child: ListView.builder(
              itemExtent: kColorItemHeight,
              itemCount: allPalettes.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return DefaultTextStyle(
                  style: 400 > allPalettes[index].threshold!
                      ? whiteTextStyle
                      : blackTextStyle,
                  child: InkWell(
                      onTap: () => onChangeSwatch(allPalettes[index]),
                      child: ColorItem(
                        index: 0,
                        color: allPalettes[index].accent,
                        prefix: allPalettes[index].name,
                      )),
                );
              },
            )),
      ),
    );
  }
}