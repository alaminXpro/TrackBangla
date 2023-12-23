import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'app_large_text.dart';
import 'app_text.dart';
import 'responsive_button.dart';
import 'slider_item.dart';

class SliderItemWidget extends StatelessWidget {
  final SliderItem sliderItem;

  const SliderItemWidget({super.key, required this.sliderItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(sliderItem.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLargeText(sliderItem.title, Colors.black),
                AppText(sliderItem.subtitle, Colors.black54, size: 25),
                SizedBox(height: 20),
                Container(
                  width: 250,
                  child: AppText(
                    "Discover joy in every bite, book your stay, and explore the flavors of the world.",
                    Colors.black54,
                    size: 16,
                  ),
                ),
                SizedBox(height: 420),
                ResponsiveButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.login);
                  },
                  imageUrl: 'https://i.pinimg.com/564x/6d/64/2e/6d642e54172df5cd3f1cb88fa73278fb.jpg',
                  size: 20.0,
                  color: Colors.white,
                )
              ],
            ),
            Column(
              children: List.generate(3, (indexDots) {
                return Container(
                  margin: const EdgeInsets.only(right: 2),
                  width: 8,
                  height: indexDots == sliderItem.index ? 25 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: indexDots == sliderItem.index ? Colors.deepPurple : Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
