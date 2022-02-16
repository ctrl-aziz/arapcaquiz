import 'package:arapcaquiz/pages/home/home_page.dart';
import 'package:arapcaquiz/pages/welcome_page.dart';
import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    loadSvgs();
    super.initState();
  }

  final List<String> assets = [
    "assets/svg/01.svg",
    "assets/svg/02.svg",
    "assets/svg/03.svg",
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainProvider>(create: (_) => MainProvider()),
      ],
      builder: (context, _){
         bool? _isNewUser = Provider.of<MainProvider>(context).isNewUser;
         if (kDebugMode) {
           print("_isNewUser $_isNewUser");
           print("User id: ${Provider.of<MainProvider>(context).user}");
         }
        return MaterialApp(
          title: 'Arapça Quiz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
                bodyText1: GoogleFonts.oswald(),
                bodyText2: GoogleFonts.oswald()
            ),
          ),
          home: AnimatedSplashScreen(
            splash: Icons.flutter_dash,
            splashIconSize: 70.0,
            nextScreen: _isNewUser == null || _isNewUser ? const WelcomePage() : const HomePage(),
          ),
        );
      },
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
