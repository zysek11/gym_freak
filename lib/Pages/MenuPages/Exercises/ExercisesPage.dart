import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/AddExercise.dart';
import 'package:provider/provider.dart';

import '../../../Language/LanguageProvider.dart';
import '../../../Theme/DarkThemeProvider.dart';
import '../../../Theme/Styles.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {

  int default_type = 0;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:16.0,left: 16,right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'search exercise or group',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search,size: 30,),
                    onPressed: () {
                      // Your search action here
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              color: Color(0xFF2A8CBB),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        default_type = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: default_type == 0 ? Color(0xff24779E) : Color(0xFF2A8CBB),
                      ),
                      child: Text("Exercises", style: TextStyle(fontSize: 22,
                      color: Colors.white, fontWeight: FontWeight.w600),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        default_type = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: default_type == 1 ? Color(0xff24779E) : Color(0xFF2A8CBB),
                      ),
                      child: Text("Groups", style: TextStyle(fontSize: 22,
                          color: Colors.white, fontWeight: FontWeight.w600),),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    child: Row(
                      children: [
                        Text("Sorting    ",style: TextStyle(fontSize: 22),),
                        Icon(Icons.keyboard_arrow_down_rounded,size: 22,)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExercise()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(45)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Image.asset(
                        'assets/icons/add_icon.png',
                        width: 45, // dostosuj rozmiar obrazka
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            )
            // Add more widgets here
          ],
        ),
      ),
    );
  }
}
