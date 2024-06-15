import 'package:flutter/material.dart';

import 'Starter4.dart';

class StarterThree extends StatefulWidget {
  const StarterThree({super.key});

  @override
  State<StarterThree> createState() => _StarterThreeState();
}

class _StarterThreeState extends State<StarterThree> {
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              'assets/gymmy/6th.png', // Ścieżka do twojego logo
                              width: 150,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(fontSize: 28, fontFamily: 'Jaapokki', color: Colors.black),
                                children: [
                                  TextSpan(text: "You can start a\nworkout and"),
                                  TextSpan(text: "\nanalyze your"
                                      "\nprogress!"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: 325,
                      height: 325,
                      color: Colors.grey.shade200,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            // Przycisk na dole
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const StarterFour()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Zmniejszenie zaokrąglenia rogów
                    ),
                  ),
                  child: Text(
                    'Go to the last!',
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
    );
  }
}
