import 'package:flutter/material.dart';

import 'package:films_app_flutter/src/models/film_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Film> films;
  final Function nextPage;

  MovieHorizontal({@required this.films, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _cards(context),
        itemCount: films.length,
        itemBuilder: (BuildContext context, i) => _card(context, films[i]),
      ),
    );
  }

  Widget _card(BuildContext context, Film film) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                fit: BoxFit.cover,
                height: 137.0,
                image: NetworkImage(film.getPosterImage())),
          ),
          SizedBox(),
          Text(
            film.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  List<Widget> _cards(BuildContext context) {
    return films.map((film) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 137.0,
                  image: NetworkImage(film.getPosterImage())),
            ),
            SizedBox(),
            Text(
              film.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
