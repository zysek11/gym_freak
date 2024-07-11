import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import 'package:provider/provider.dart';

import '../../../Language/LanguageProvider.dart';
import '../../../Theme/DarkThemeProvider.dart';
import '../../../Theme/Styles.dart';
import '../../../database_classes/Profile.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  Profile? _profile;
  bool _isLoading = true;

  Future<void> _loadProfile() async {
    Profile? profile = await DatabaseHelper().getProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 10),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello, ',
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Jaapokki',
                          color: Colors.black, // czarny kolor dla "Hello, "
                        ),
                      ),
                      TextSpan(
                        text: '${_profile!.name}!',
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Jaapokki',
                          color: Color(0xFF2A8CBB), // niebieski kolor dla imienia
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A8CBB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200, // Adjust the height according to your needs
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      "BEGIN\nTHE\nWORKOUT",
                                      style: TextStyle(
                                        height: 1.6,
                                        fontSize: 45,
                                        fontFamily: 'Jaapokki',
                                        color: Colors.white, // kolor dla tekstu
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image.asset(
                                      'assets/gymmy/4th.png',
                                      height: 200, // dostosuj rozmiar obrazka
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // button border radius
                                  ),
                                ),
                                onPressed: () {
                                  // Your button action here
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'GET IN',
                                        style: TextStyle(
                                          color: Color(0xFF2A8CBB),
                                          fontSize: 40,
                                          fontFamily: 'Jaapokki',
                                          // button text color
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/right_arrow.png',
                                      width: 40, // dostosuj rozmiar obrazka
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFBB592A),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200, // Adjust the height according to your needs
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      "ANALYZE\nTHE\nSTATS",
                                      style: TextStyle(
                                        height: 1.6,
                                        fontSize: 45,
                                        fontFamily: 'Jaapokki',
                                        color: Colors.white, // kolor dla tekstu
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image.asset(
                                      'assets/gymmy/3rd.png',
                                      height: 200, // dostosuj rozmiar obrazka
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // button border radius
                                  ),
                                ),
                                onPressed: () {
                                  // Your button action here
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'CHECK',
                                        style: TextStyle(
                                          color: Color(0xFFBB592A),
                                          fontSize: 40,
                                          fontFamily: 'Jaapokki',
                                          // button text color
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/right_arrow2.png',
                                      width: 40, // dostosuj rozmiar obrazka
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
