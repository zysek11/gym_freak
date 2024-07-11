import 'package:flutter/material.dart';

import '../../../database_classes/Group.dart';

class AddGroup extends StatefulWidget {
  final bool edit;
  final Groups? group;

  const AddGroup({super.key,required this.edit, this.group});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {

  late String selectedImage; // Domyślny obrazek
  late int selectedImageIndex;

  final List<String> images = List.generate(
    8,
        (index) => 'assets/group_icons/typeL$index.png',
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedImage = 'assets/group_icons/typeL0.png';
    selectedImageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[100],
                          // Tło kontenera, możesz zmienić kolor
                          child: Center(
                            child: Image.asset(
                              selectedImage,
                              // Zmień na rzeczywistą ścieżkę do obrazka
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "1. Pick icon",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 10),
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
                                    print("sciezka: " + path);
                                    selectedImage = path;
                                    selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedImageIndex == index
                                        ? Color(0xFFA5EEFF)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(images[index]),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}
