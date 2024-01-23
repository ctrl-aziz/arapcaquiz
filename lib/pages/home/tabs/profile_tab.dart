import 'package:arapcaquiz/providers/main_provider.dart';
import 'package:arapcaquiz/services/database.dart';
import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          backgroundImage: Svg(
            "assets/svg/m-3.svg",
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
            percent: (provider.successRate >= 100000.0 ? 100000.0 : provider.successRate) / 100000.0,
            center: Text(
              "${provider.successRate}",
              style: GoogleFonts.oswald(),
            ),
            barRadius: const Radius.circular(20.0),
            progressColor: Colors.red,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 15.0,),
            FutureBuilder<int>(
              future: Database.id(provider.user).userWords,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return const Text(
                    "Hata(P_S_01): Lütfen uygulama kaptip yeniden açınız tekrar hata olursa bildirim yapınız",
                    maxLines: 10,
                  );
                }
                return CustomTrText(
                  text: "Kazandığnız kelimeler: ${snapshot.data}",
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
