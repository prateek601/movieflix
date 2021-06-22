import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movieflix/MovieClass.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageNo = 1;
  var response;

  var modelClass;

  List<Map> list = [];

  var _controller = ScrollController();
  List moviesList = [];

  bool bottom = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          // You're at the top.
          print('top');
        } else {
          setState(() {
            bottom = true;
          });

          print('bottom');
          if (response != null) {
            if (modelClass.hasNext) {
              pageNo++;
              getData();
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20242b),
      body: SafeArea(
        child: response == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _controller,
                          shrinkWrap: true,
                          itemCount: moviesList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF000000),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 20,
                                          right: 20,
                                          bottom: 10),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: 170,
                                            child: OptimizedCacheImage(
                                              imageUrl:
                                                  moviesList[index].backdrop,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Text(
                                        moviesList[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xFF404040),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (moviesList[index]
                                                        .userReaction ==
                                                    1) {
                                                  moviesList[index]
                                                      .userReaction = 0;
                                                } else {
                                                  moviesList[index]
                                                      .userReaction = 1;
                                                }
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                moviesList[index]
                                                            .userReaction ==
                                                        1
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: moviesList[index]
                                                            .userReaction ==
                                                        1
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                if (moviesList[index]
                                                        .userReaction ==
                                                    2) {
                                                  moviesList[index]
                                                      .userReaction = 0;
                                                } else {
                                                  moviesList[index]
                                                      .userReaction = 2;
                                                }
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                moviesList[index]
                                                            .userReaction ==
                                                        2
                                                    ? Icons.thumb_up
                                                    : Icons.thumb_up_off_alt,
                                                color: moviesList[index]
                                                            .userReaction ==
                                                        2
                                                    ? Colors.blue
                                                    : Colors.white,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                if (moviesList[index]
                                                        .userReaction ==
                                                    3) {
                                                  moviesList[index]
                                                      .userReaction = 0;
                                                } else {
                                                  moviesList[index]
                                                      .userReaction = 3;
                                                }
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                moviesList[index]
                                                            .userReaction ==
                                                        3
                                                    ? Icons.thumb_down
                                                    : Icons
                                                        .thumb_down_alt_outlined,
                                                color: moviesList[index]
                                                            .userReaction ==
                                                        3
                                                    ? Color(0xffE19500)
                                                    : Colors.white,
                                                size: 40,
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    bottom
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          )
                        : Container()
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> getData() async {
    response = await http.get(
        Uri.parse('https://criddle.app/exercises/infinite_list?page=$pageNo'),
        headers: {
          'Authorization': 'Token e3def5620bf3990cd84b86d8b82b7d6fecdf0faa'
        });
    setState(() {
      modelClass = welcomeFromJson(response.body);
      moviesList.addAll(modelClass.data);
      bottom = false;
    });
  }
}
