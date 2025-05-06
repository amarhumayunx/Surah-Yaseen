import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surah_yaseen/widgets/AboutScreen/top_bar_about.dart';

import '../Colors/colors.dart';
import '../widgets/Dividerbar/dividerbar.dart';
import '../widgets/SurahTitle/surat_title.dart';
import '../widgets/Topbackground/top_background.dart';


class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightColorSec,
      body: Stack(
        children: [
          TopBackground(),
          SafeArea(
            child: Column(
              children: [
                TopBarAbout(),
                SizedBox(height: 10,),
                SizedBox(height: 5,),
                DividerBar(),
                SurahTitle(),
                SizedBox(height: 100),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Select Language",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          title: Text("English",
                          style: TextStyle(color: AppColors.whiteColor),
                          ),
                          onTap: () {
                            // Add language change logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text("Urdu",
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                          onTap: () {
                            // Add language change logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text("Arabic",
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                          onTap: () {
                            // Add language change logic here
                            Navigator.pop(context);
                          },
                        ),
                        // Add more languages if needed
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/*class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Language")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Language",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text("English"),
              onTap: () {
                // Add language change logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Urdu"),
              onTap: () {
                // Add language change logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Arabic"),
              onTap: () {
                // Add language change logic here
                Navigator.pop(context);
              },
            ),
            // Add more languages if needed
          ],
        ),
      ),
    );
  }
}
*/