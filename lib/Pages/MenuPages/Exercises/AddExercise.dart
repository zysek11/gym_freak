import 'package:flutter/material.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {

  String selectedImage = 'assets/workout_icons/typeL0.png'; // Domyślny obrazek
  int selectedImageIndex = 0;

  final List<String> images = List.generate(
    8,
        (index) => 'assets/workout_icons/typeL$index.png',
  );

  final List<String> categories = ["Back  ", "Biceps  ", "Chest  ", 'Triceps  ', "ABS  ",
    "Legs  ", "Shoulders  ",'Stretching  ', 'Other  '];
  String selectedCategory = 'Back  ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Color(0xFFF8F8F8), // Tło kontenera, możesz zmienić kolor
                        child: Center(
                          child: Image.asset(
                            selectedImage, // Zmień na rzeczywistą ścieżkę do obrazka
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("1. Pick icon",style: TextStyle(fontSize: 22),),),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  String path = images[index];
                                  path = path.replaceAll('L', '');
                                  print("sciezka: "+path);
                                  selectedImage = path;
                                  selectedImageIndex = index;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedImageIndex == index ? Color(0xFFA5EEFF) : Color(0xFFF8F8F8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(images[index])
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("2. Give a name",style: TextStyle(fontSize: 22),),),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("3. Choose a type",style: TextStyle(fontSize: 22),),),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              items: categories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(
                                    category,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Color(0xFF2A8CBB), // button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // button border radius
                  ),
                ),
                onPressed: () {
                  // Your button action here
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'ADD EXERCISE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Jaapokki',
                          // button text color
                        ),
                      ),
                    ],
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
