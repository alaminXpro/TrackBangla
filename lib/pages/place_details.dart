import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:trackbangla/blocs/bookmark_bloc.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/core/utils/sign_in_dialog.dart';
import 'package:trackbangla/models/place.dart';
import 'package:trackbangla/widgets/bookmark_icon.dart';
import 'package:trackbangla/widgets/comment_count.dart';
import 'package:trackbangla/widgets/custom_cache_image.dart';
import 'package:trackbangla/widgets/love_count.dart';
import 'package:trackbangla/widgets/love_icon.dart';
import 'package:trackbangla/widgets/other_places.dart';
import 'package:trackbangla/widgets/todo.dart';
import 'package:provider/provider.dart';


class PlaceDetails extends StatefulWidget {

  final Place data;
  final String tag;

  const PlaceDetails({super.key, required this.data, required this.tag});

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {

  @override
  void initState() { 
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value) async{
      //context.read<AdsBloc>().initiateAds();
    });
  }

  String collectionName = 'places';


  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(collectionName, widget.data.timestamp);
    }
  }


  

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(collectionName, widget.data.timestamp);
    }
  }

  
  @override
  Widget build(BuildContext context) {

    final SignInBloc sb = context.watch<SignInBloc>();
    


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              
              children: <Widget>[
                Hero(
                  tag: widget.tag,
                    child: Container(
                      color: Colors.white,
                      child: Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                    
                        color: Colors.white,
                        
                      ),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16/9,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          onPageChanged: (index, reason) {
                            // Handle page change
                          },
                        ),
                        items: [
                          CustomCacheImage(imageUrl: widget.data.imageUrl1),
                          CustomCacheImage(imageUrl: widget.data.imageUrl2),
                          CustomCacheImage(imageUrl: widget.data.imageUrl3),
                        ],
                      ),
                  ),
                    ),
                ),

                
                Positioned(
                  top: 20,
                  left: 15,
                  child: SafeArea(
                      child: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          LineIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                   
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on, size: 20, color: Colors.grey,),
                      Expanded(child: Text(widget.data.location, style: TextStyle(fontSize: 13, color: Colors.grey[600],),maxLines: 2, overflow: TextOverflow.ellipsis,   )),
                      
                      IconButton(
                                icon: BuildLoveIcon(
                                    collectionName: collectionName,
                                    uid: sb.uid,
                                    timestamp: widget.data.timestamp),
                                onPressed: () {
                                  handleLoveClick();
                                }),
                            IconButton(
                                icon: BuildBookmarkIcon(
                                    collectionName: collectionName,
                                    uid: sb.uid,
                                    timestamp: widget.data.timestamp),
                                onPressed: () {
                                  handleBookmarkClick();
                                }),

                    ],
                  ),
                  Text(widget.data.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.grey[800])),
                  
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    height: 3,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  ),
                  Row(children: <Widget>[

                    LoveCount(
                            collectionName: collectionName,
                            timestamp: widget.data.timestamp),

                    SizedBox(width: 20,),
                    Icon(Icons.comment, color: Colors.grey, size: 20,),
                    SizedBox(width: 2,),
                    CommentCount(collectionName: collectionName, timestamp: widget.data.timestamp)
                  ],),

                  SizedBox(height: 30,),
                  
                  Html(data: '''${widget.data.description}''',
                  style: {
                    "p": Style(
                      fontSize: FontSize(16),
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500
                    )
                  },
                  ),
                  SizedBox(height: 30,),
                  TodoWidget(placeData: widget.data),
                  SizedBox(height: 15,),
                  OtherPlaces(stateName: widget.data.state, timestamp: widget.data.timestamp,),
                  SizedBox(height: 15,),
                ],
              ),
              
              )

            
          ],
        ),
      ),
    );
  }
}




