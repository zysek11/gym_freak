import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/MiniApps/BodyPage.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/MiniApps/SuppsPage.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import 'package:provider/provider.dart';

import '../../../Language/LanguageProvider.dart';
import '../../../Theme/DarkThemeProvider.dart';
import '../../../Theme/Styles.dart';
import '../../../database_classes/Profile.dart';
import 'Begin/PickWorkout.dart';

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
          padding:
              const EdgeInsets.only(bottom: 10),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 12,left: 10, bottom: 12),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/ui/pasek.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter
                            )
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "MINI APPS",
                            style: const TextStyle(
                              color:Colors.white,
                              fontSize: 27,
                              fontFamily: 'Jaapokki',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:  10.0, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Follow the progress, control your supps.",
                            style: const TextStyle(
                              color:Color(0xff101010),
                              fontSize: 18,
                              fontFamily: 'Jaapokki',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,  MaterialPageRoute(
                                  builder: (context) =>
                                      const BodyPage()),);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color(0x88b1f2ff),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 125,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/icons/tape-measure.png',
                                    fit: BoxFit.cover,
                                    height: 40,
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Body",
                                    style: const TextStyle(
                                      color:Color(0xff101010),
                                      fontSize: 18,
                                      fontFamily: 'Jaapokki',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                                Navigator.push(context,  MaterialPageRoute(
                                    builder: (context) =>
                                    const SuppsPage()),);
                                },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color(0x88b1f2ff),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 125,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/icons/vitamin.png',
                                    fit: BoxFit.cover,
                                    height: 40,
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Supps",
                                    style: const TextStyle(
                                      color:Color(0xff101010),
                                      fontSize: 18,
                                      fontFamily: 'Jaapokki',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30,),
                      Container(
                        padding: EdgeInsets.only(top: 12,left: 10, bottom: 12),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/ui/pasek.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter
                            )
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "PUSH THE LIMITS",
                            style: const TextStyle(
                              color:Colors.white,
                              fontSize: 27,
                              fontFamily: 'Jaapokki',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:  10.0, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Do your job and control the results.",
                            style: const TextStyle(
                              color:Color(0xff101010),
                              fontSize: 18,
                              fontFamily: 'Jaapokki',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 275,
                          width: 350,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A8CBB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 150,
                                // Adjust the height according to your needs
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        "BEGIN\nTHE\nWORKOUT",
                                        style: TextStyle(
                                          height: 1.6,
                                          fontSize: 35,
                                          fontFamily: 'Jaapokki',
                                          color: Colors
                                              .white, // kolor dla tekstu
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Image.asset(
                                        'assets/gymmy/4th.png',
                                        height:
                                            150, // dostosuj rozmiar obrazka
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color(0xFF2A8CBB),
                                    backgroundColor: Colors.white,
                                    // button text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // button border radius
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickWorkout()),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0),
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
                                        width:
                                            40, // dostosuj rozmiar obrazka
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
                      SizedBox(height: 20,),
                      Container(
                        height: 275,
                        width: 350,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFBB592A),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              // Adjust the height according to your needs
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      "ANALYZE\nTHE\nSTATS",
                                      style: TextStyle(
                                        height: 1.6,
                                        fontSize: 35,
                                        fontFamily: 'Jaapokki',
                                        color: Colors
                                            .white, // kolor dla tekstu
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image.asset(
                                      'assets/gymmy/3rd.png',
                                      height:
                                          150, // dostosuj rozmiar obrazka
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
                                  foregroundColor:
                                      const Color(0xFF2A8CBB),
                                  backgroundColor: Colors.white,
                                  // button text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // button border radius
                                  ),
                                ),
                                onPressed: () {
                                  // Your button action here
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0),
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
                                      width:
                                          40, // dostosuj rozmiar obrazka
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
