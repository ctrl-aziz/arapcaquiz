import 'package:arapcaquiz/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SplashProvider>(
        create: (_) => SplashProvider(),
        builder: (context, _){
          return Consumer<SplashProvider>(
            builder: (context, splash, _){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 7,
                    child: PageView.builder(
                      controller: splash.pageController,
                      itemCount: splash.assets.length,
                      itemBuilder: (context, i){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(splash.assets[i]),
                            // Oswald
                            // Dancing Script
                            Flexible(
                              child: Text(
                                splash.titles[i],
                                style: GoogleFonts.architectsDaughter(
                                  fontSize: 25,
                                ),
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () async {
                        await splash.nexPage(context);
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.oswald(),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.red
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          splash.isLastPage
                              ?const Text("Başla")
                              :const Text("Sonra"),
                          splash.isLastPage
                              ? const SizedBox():const Icon(Icons.arrow_forward_ios),
                          const SizedBox(width: 10.0,),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
