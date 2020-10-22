import 'package:flutter/material.dart';

import 'package:films_app_flutter/src/widgets/card_swiper_widget.dart';
import 'package:films_app_flutter/src/providers/films_provider.dart';
import 'package:films_app_flutter/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final filmsProvider = new FilmsProviders();

  @override
  Widget build(BuildContext context) {
    filmsProvider.getPopulars();
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swipeCards(), _footer(context)],
          ),
        ));
  }

  Widget _swipeCards() {
    return FutureBuilder(
      future: filmsProvider.getInCinema(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(films: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
              stream: filmsProvider.popularsStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                      films: snapshot.data,
                      nextPage: filmsProvider.getPopulars);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
