import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movieflix/MovieClass.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

void main() {
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
  List moviesList=[];

  bool bottom=false;

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
            bottom=true;
          });

          print('bottom');
          if(response!=null){
            if(modelClass.hasNext){
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
        child:response == null?
            Center(child: CircularProgressIndicator()):
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(crossAxisAlignment:  CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                    shrinkWrap: true,
                    itemCount:moviesList.length,
                    itemBuilder: (context, index) {

                      bool like =false;
                      bool fav =false;
                      bool unlike =false;
                      bool tapped =false;
                      int indexOfList =0;
                      for(int i = 0 ; i<list.length ; i++){
                        if(index == list[i]['tappedIndex']){
                          like= list[i]['like'];
                          fav= list[i]['fav'];
                          unlike= list[i]['unlike'];
                          indexOfList=i;
                          tapped=true;
                          break;
                        }
                      }
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
                                    top: 20, left: 20, right: 20, bottom: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                       Container(
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
                                padding: const EdgeInsets.only(left: 20, bottom: 20),
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
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFF404040),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if(tapped && fav){
                                            list.removeAt(indexOfList);
                                          }else{
                                            if(list.isNotEmpty&&tapped){
                                              list.removeAt(indexOfList);
                                            }
                                            list.add({
                                              'tappedIndex': index,
                                              'fav': true,
                                              'like': false,
                                              'unlike': false
                                            });
                                          }
                                          setState(() {
                                          });
                                        },
                                        icon: Icon(
                                         fav?Icons.favorite: Icons.favorite_border,
                                          color: fav?Colors.red:Colors.white,
                                          size: 40,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          if(tapped && like){
                                            list.removeAt(indexOfList);
                                          }else{
                                            if(list.isNotEmpty&&tapped){
                                              list.removeAt(indexOfList);
                                            }

                                            list.add({
                                              'tappedIndex': index,
                                              'fav': false,
                                              'like': true,
                                              'unlike': false
                                            });
                                          }

                                          setState(() {

                                          });
                                        },
                                        icon: Icon(
                                         like?Icons.thumb_up: Icons.thumb_up_off_alt,
                                          color: like? Colors.blue:Colors.white,
                                          size: 40,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          if(tapped && unlike){
                                            list.removeAt(indexOfList);
                                          }else{
                                            if(list.isNotEmpty&&tapped){
                                              list.removeAt(indexOfList);
                                              // list.add({
                                              //   'tappedIndex': index,
                                              //   'fav': false,
                                              //   'like': false,
                                              //   'unlike': true
                                              // });
                                            }
                                            // list.removeAt(indexOfList);
                                            list.add({
                                            'tappedIndex': index,
                                            'fav': false,
                                            'like': false,
                                            'unlike': true
                                          });
                                          }

                                          setState(() {

                                          });
                                        },
                                        icon: Icon(
                                         unlike?Icons.thumb_down: Icons.thumb_down_alt_outlined,
                                          color: unlike?Color(0xffE19500):Colors.white,
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
              bottom?Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ):Container()
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
     bottom=false;
    });
  }
}
