import 'package:arapcaquiz/pages/welcome_page.dart';
import 'package:arapcaquiz/widgets/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    loadSvgs().then((value) {
      CustomNavigator.pushReplacement(context, const WelcomePage());
    });
    super.initState();

  }

  final List<String> assets = [
    "assets/svg/01.svg",
    "assets/svg/02.svg",
    "assets/svg/03.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Logo",
              style: TextStyle(
                fontSize: 40
              ),
            ),
            Text(
              "Arapça Quiz",
              style: GoogleFonts.oswald(),
            ),
            const SizedBox(height: 10.0,),
            const CircularProgressIndicator(
              color: Color(0xff267DB2),
            ),
          ],
        ),
      ),
    );
  }

  Future loadSvgs()async{
    late Future result;
    for(int i = 0; i < assets.length; i++){
      result = precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, assets[i]), null);
    }
    return result;
  }
}
