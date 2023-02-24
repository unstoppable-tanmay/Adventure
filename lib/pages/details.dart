import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatelessWidget {
  final Map items;
  const Details({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // For Hiding The Status Bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Material(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Material(
            child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight / 1.7,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: items["img"],
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: SizedBox(
                    width: context.screenWidth - 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: VxCircle(
                              radius: 45,
                              backgroundColor: Vx.white,
                              child: const Icon(Icons.arrow_back_rounded),
                            )),
                        InkWell(
                            onTap: () async {
                              try {
                                await launchUrl(Uri.parse(items["loc"]));
                              } catch (e) {
                                VxToast.show(context,
                                    msg: "URL can't be launched. $e");
                              }
                            },
                            child: VxCircle(
                              radius: 45,
                              backgroundColor: Vx.white,
                              child: const Icon(Icons.location_on_rounded),
                            )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: context.screenHeight / 1.847,
                    child: VxArc(
                      height: 40,
                      arcType: VxArcType.CONVEX,
                      edge: VxEdge.TOP,
                      child: Container(
                        color: Vx.white,
                        width: context.screenWidth,
                        height: 40,
                      ),
                    )),
                // Positioned(
                //     top: context.screenHeight / 1.8,
                //     child: Container(
                //       width: context.screenWidth,
                //       height: 30,
                //       decoration: const BoxDecoration(
                //           color: Vx.white,
                //           borderRadius: BorderRadius.only(
                //               topLeft: Radius.circular(45),
                //               topRight: Radius.circular(45))),
                //     ))
              ],
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 400),
              width: context.screenWidth,
              decoration: const BoxDecoration(
                color: Vx.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      items["name"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 37,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      items["desc"],
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.poppins(fontSize: 18, color: Vx.gray400),
                    ).px12()
                  ]).px16(),
            )
          ],
        )),
      ),
    );
  }
}
