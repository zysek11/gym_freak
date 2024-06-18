import 'package:flutter/material.dart';

import 'Starter3.dart';

class StarterTwo extends StatefulWidget {
  const StarterTwo({super.key});

  @override
  State<StarterTwo> createState() => _StarterTwoState();
}

class _StarterTwoState extends State<StarterTwo> {
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
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(fontSize: 28, fontFamily: 'Jaapokki', color: Colors.black),
                                children: [
                                  TextSpan(text: "You can create\nyour exercises,"),
                                  TextSpan(text: "\nadd sets, weights,"
                                      "\nand all of the\ndetails "),
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
                              'assets/gymmy/9th.png', // Ścieżka do twojego logo
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
                      MaterialPageRoute(builder: (context) => const StarterThree()),
                    );
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
    );
  }
}
