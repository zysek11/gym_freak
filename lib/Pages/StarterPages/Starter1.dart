import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/StarterPages/Starter2.dart';

class StarterOne extends StatefulWidget {
  const StarterOne({super.key});

  @override
  State<StarterOne> createState() => _StarterOneState();
}

class _StarterOneState extends State<StarterOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
            SizedBox(height: 55,),
            // Scrollowany widget pomiędzy
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/gymmy/1st.png', // Ścieżka do twojego logo
                        height: 350,
                      ),
                    ),
                    SizedBox(height: 40,),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(fontSize: 28, fontFamily: 'Jaapokki', color: Colors.black),
                        children: [
                          TextSpan(text: "Hello, my name is "),
                          TextSpan(text: 'Gymmy', style: TextStyle(color: Color(0xFF2A8CBB))),
                          TextSpan(text: ",\nI'm your gym partner."
                              "\nHow about taking a look\n around here? "),
                        ],
                      ),
                    ),
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
                      MaterialPageRoute(builder: (context) => const StarterTwo()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Zmniejszenie zaokrąglenia rogów
                    ),
                  ),
                  child: Text(
                    'Sure thing, let’s go!',
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
