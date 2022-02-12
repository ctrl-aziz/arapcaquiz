import 'package:arapcaquiz/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({Key? key}) : super(key: key);

  final List<String> avatars = [
    "assets/svg/m-1.svg",
    "assets/svg/m-2.svg",
    "assets/svg/m-3.svg",
    "assets/svg/f-1.svg",
    "assets/svg/f-2.svg",
    "assets/svg/f-3.svg",
  ];

  @override
  Widget build(BuildContext context) {
    final _successRate = Provider.of<AuthProvider>(context).successRate;
    final _wordsHave = Provider.of<AuthProvider>(context).wordsHave;
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          backgroundImage: Svg(
            avatars[2],
          ),
        ),
        const SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 110,
            animation: true,
            animationDuration: 1000,
            lineHeight: 20.0,
            leading: Text(
              "Başarı oranı:",
              style: GoogleFonts.oswald(),
            ),
            percent: _successRate / 1000000.0,
            center: Text(
              "$_successRate",
              style: GoogleFonts.oswald(),
            ),
            barRadius: const Radius.circular(20.0),
            progressColor: Colors.red,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 15.0,),
            Text(
              "Kazandığnız kelimeler: $_wordsHave",
              style: GoogleFonts.oswald(),
            ),
          ],
        ),
      ],
    );
  }
}
