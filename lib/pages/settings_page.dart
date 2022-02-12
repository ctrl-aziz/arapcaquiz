import 'package:arapcaquiz/widgets/custom_tr_text.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: (){
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xff267DB2), size: 27,),
        ),
        title: const CustomTrText(
          text: "Ayarlar",
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const SizedBox(height: 20.0,),
          const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomTrText(
                  text: "Öneri ve hata bildirimi için bize ulaşın:",
                  fontSize: 17,
                ),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  CustomTrText(
                    text: "Gmail",
                    fontSize: 17,
                  ),
                  Icon(Icons.mail, size: 50, color: Color(0xffFF6A6B),),
                ],
              ),
              Column(
                children: [
                  const CustomTrText(
                    text: "Hotmail",
                    fontSize: 17,
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/img/outlook-logo.png", color: const Color(0xffFF6A6B),),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
