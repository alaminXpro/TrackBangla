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
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      //context.read<AdsBloc>().initiateAds();
    });
  }

  String collectionName = 'places';
  int _current = 0;

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onLoveIconClick(collectionName, widget.data.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onBookmarkIconClick(collectionName, widget.data.timestamp);
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
                          height: 320,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: [
                          Image.network(
                            widget.data.imageUrl1,
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            widget.data.imageUrl2,
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            widget.data.imageUrl3,
                            fit: BoxFit.cover,
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
                //Slider indicator
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3, // Replace with the number of slides
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        margin: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 2.0,
                        ),
                        height: 8.0,
                        width: _current == index ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _current == index ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
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
              padding:
                  EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: Text(
                        widget.data.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
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
                  Text(widget.data.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800])),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    height: 3,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.data.loves.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'people like this',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.data.commentsCount.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Html(
                    data: '''${widget.data.description}''',
                    style: {
                      "p": Style(
                          fontSize: FontSize(16),
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500)
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TodoWidget(placeData: widget.data),
                  SizedBox(
                    height: 15,
                  ),
                  OtherPlaces(
                    stateName: widget.data.state,
                    timestamp: widget.data.timestamp,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
