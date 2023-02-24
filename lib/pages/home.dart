import 'package:Adventure/pages/details.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List _items = [];
typedef MyBuilder = void Function(
    BuildContext context, void Function() switchData);
bool networks = true;

class Home extends StatelessWidget {
  late void Function() myMethod;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Material(
        child: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const AppBar(),
            const SizedBox(
              height: 20,
            ),
            const Search(),
            const SizedBox(
              height: 20,
            ),
            Swiper(
              builder: (BuildContext context, void Function() switchData) {
                myMethod = switchData;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   "Find More Cities...",
            //   style: GoogleFonts.poppins(
            //       fontSize: 27, color: Vx.gray800, fontWeight: FontWeight.w500),
            // ),
            SlidingSwitch(
              value: false,
              width: 230,
              onChanged: (bool value) {
                // print(_items[0]);
                myMethod.call();
              },
              height: 50,
              animationDuration: const Duration(milliseconds: 400),
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              textOff: "Odisha",
              textOn: "India",
              contentSize: 22,
              colorOn: const Color.fromARGB(255, 13, 13, 13),
              colorOff: const Color.fromARGB(255, 13, 13, 13),
            ),
          ],
        ),
      ),
    ));
  }
}

class Swiper extends StatefulWidget {
  final MyBuilder builder;
  const Swiper({
    super.key,
    required this.builder,
  });

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
// Fetch content from the json file

  bool ind = false;

  Future<void> readJsonOdisha() async {
    final String response =
        await rootBundle.loadString('assets/data/odisha.json');
    final data = await json.decode(response);
    _items = data;
  }

  Future<void> readJsonIndia() async {
    final String response =
        await rootBundle.loadString('assets/data/india.json');
    final data = await json.decode(response);
    _items = data;
  }

  void switchData() {
    setState(() {
      ind ? {readJsonOdisha(), ind = false} : {readJsonIndia(), ind = true};
    });
  }

  @override
  void initState() {
    super.initState();
    readJsonOdisha();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, switchData);
    if (_items.isEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: context.screenHeight / 1.6,
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (!networks) {
      return SizedBox(
        width: double.maxFinite,
        height: context.screenHeight / 1.6,
        child: const Center(
            child: Text(
          "Network Not Available",
          style: TextStyle(color: Vx.red300, fontSize: 30),
        )),
      );
    } else {
      return VxSwiper.builder(
        itemCount: _items.isEmpty ? 10 : _items.length,
        height: context.screenHeight / 1.6,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOut,
        pauseAutoPlayOnTouch: const Duration(milliseconds: 500),
        enlargeCenterPage: true,
        isFastScrollingEnabled: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _items.isEmpty
              ? Container(
                  height: context.screenHeight / 1.6,
                  decoration: BoxDecoration(
                    color: Vx.randomOpaqueColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container())
              : DropShadow(
                  blurRadius: 7,
                  offset: const Offset(0, 10),
                  spread: 1.1,
                  opacity: .7,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(
                                    items: _items[index],
                                  )));
                    },
                    child: Stack(children: [
                      Container(
                        height: context.screenHeight / 1.6,
                        decoration: BoxDecoration(
                          color: Vx.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _items[index]["img"],
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                        // Image.network(
                        //   _items[index]["img"],
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.05, 0.4, 0.4, 0.5],
                              colors: [
                                Vx.black.withAlpha(230),
                                Vx.black.withAlpha(60),
                                Vx.black.withAlpha(60),
                                Colors.transparent
                              ],
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Vx.gray400,
                              size: 35,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "${_items[index]["name"]}",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Vx.white),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_items[index]["dist"]}",
                                    style: const TextStyle(
                                        fontSize: 20, color: Vx.gray400),
                                  )
                                ]),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
        },
      );
    }
  }
}

class Search extends StatelessWidget {
  const Search({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth / 1.2,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Vx.white,
          borderRadius: BorderRadius.circular(context.screenHeight),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: const Offset(0, 10),
                color: Vx.black.withAlpha(20)),
          ],
          border: Border.all(width: 2, color: Vx.gray100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Icon(Icons.search_rounded),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Working Soon...",
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w400, color: Vx.gray400),
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Text(
          "Explore",
          style: GoogleFonts.poppins(
              fontSize: 45, fontWeight: FontWeight.w500, color: Vx.gray700),
        ),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 16,
                    child: Container(
                      constraints:
                          BoxConstraints(maxHeight: context.screenHeight / 2.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Info",
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                                color: Vx.gray800),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "We are Trying Hard to adding new places and adding soome more feature in it so stay connected and explore world...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Vx.gray500),
                          ).px8(),
                          const SizedBox(
                            height: 17,
                          ),
                          RichText(
                            text: const TextSpan(
                              text: 'Version : ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Vx.gray800),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '1.0.0',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Vx.gray500)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Connect : ",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Vx.gray800),
                              ),
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse(
                                      //'https://wa.me/1234567890' //you use this url also
                                      'whatsapp://send?phone=7008651763', //put your number here
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ).p16(),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.notification_important_rounded,
                size: 35, color: Vx.gray600))
      ],
    ).px24();
  }
}
