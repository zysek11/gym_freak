import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/WorkoutPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database_classes/DatabaseHelper.dart';
import '../../database_classes/Profile.dart';
import '../MenuPages/MainPage.dart';

class StarterFour extends StatefulWidget {
  const StarterFour({super.key});

  @override
  State<StarterFour> createState() => _StarterFourState();
}

class _StarterFourState extends State<StarterFour> {

  final TextEditingController _controller = TextEditingController();

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userExist', true);

    String name = _controller.text;

    // Tworzenie profilu z imieniem, reszta pól ustawiona na domyślne wartości
    Profile profile = Profile(
      name: name,
      age: 0,
      weight: 0.0,
      height: 0.0,
      date: DateTime.now(),
    );

    // Zapisywanie profilu do bazy danych
    await DatabaseHelper().insertProfile(profile);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Logo na górze
            SizedBox(height: 25,),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 50, fontFamily: 'JaapokkiEnhance'),
                children: [
                  TextSpan(text: 'Gym', style: TextStyle(color: Colors.black)),
                  TextSpan(text: 'FREAK', style: TextStyle(color: Color(0xFF2A8CBB))),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child:
                    Column(
                      children: [
                        Container(
                          height: 250,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 28, fontFamily: 'Jaapokki', color: Colors.black),
                                      children: [
                                        TextSpan(text: "And finally\nyou can set "),
                                        TextSpan(text: "\nyour goals."
                                            "\nHow should I \ncall you?"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Image.asset(
                                    'assets/gymmy/5th.png', // Ścieżka do twojego logo
                                    width: 150,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                          child: Container(
                            height: 70,
                            child: TextField(
                              controller: _controller,
                              style: TextStyle(
                                fontFamily: 'Jaapokki', // Ustawienie czcionki dla tekstu wprowadzanego przez użytkownika
                                fontSize: 24,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Jaapokki', // Ustawienie czcionki dla hint text
                                  fontSize: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2A8CBB), // Niebieski kolor obramowania
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2A8CBB), // Niebieski kolor obramowania
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2A8CBB), // Niebieski kolor obramowania
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        RichText(
                          textAlign: TextAlign.left,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 28, fontFamily: 'Jaapokki', color: Colors.black),
                            children: [
                              TextSpan(text: "Later on, you can add more"),
                              TextSpan(text: "\ndetails about you, such as"
                                  "\nage, height or weight."),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () async {
                    if(_controller.text.isNotEmpty){
                      await _saveUser();
                      if(mounted){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const MainPage(),
                            ));
                      }
                    }
                    else {
                      const snackBar = SnackBar(
                        content: Text('Please enter your name.',style: TextStyle(color: Colors.black),),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFFFFFFFF),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Zmniejszenie zaokrąglenia rogów
                    ),
                  ),
                  child: Text(
                    'Go next!',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Jaapokki',
                      color: Colors.white, // Kolor czcionki
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
