import 'package:flutter/material.dart';
import 'WelcomePage.dart';
import 'slider_item.dart';
import 'slider_item_widget.dart';

class WelcomePageState extends State<WelcomePage> {
  List<SliderItem> sliderItems = [
    SliderItem(
      imageUrl: "https://i.pinimg.com/564x/01/45/35/014535c9bdb94a079a51fc5e6bfd7c7e.jpg",
      title: "TrackBangla",
      subtitle: "Explore",
      index: 0,
    ),
    SliderItem(
      imageUrl: "https://i.pinimg.com/564x/a1/76/73/a176734e7a6a6a81c58c871607a92536.jpg",
      title: "TrackBangla",
      subtitle: "Hotel Booking",
      index: 1,
    ),
    SliderItem(
      imageUrl: "https://i.pinimg.com/564x/77/52/b9/7752b963771e7a6b80f8348ba807e27c.jpg",
      title: "TrackBangla",
      subtitle: "Grab Your Foods",
      index: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: sliderItems.length,
        itemBuilder: (_, index) {
          return SliderItemWidget(sliderItem: sliderItems[index]);
        },
      ),
    );
  }
}
