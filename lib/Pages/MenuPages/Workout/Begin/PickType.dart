import 'package:flutter/material.dart';

import '../../../../database_classes/Group.dart';
import 'LastInfo.dart';

class PickType extends StatefulWidget {
  final Groups pg;
  const PickType({super.key, required this.pg});

  @override
  State<PickType> createState() => _PickTypeState();
}

class _PickTypeState extends State<PickType> {

  bool ffwSelected = true;
  bool sSelected = false;

  void swapSelections(){
    ffwSelected = !ffwSelected;
    sSelected = !sSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 30, bottom: 10,left: 25, right: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "PICK TYPE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: 'Jaapokki',
                // button text color
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                if(!ffwSelected){
                  setState(() {
                    swapSelections();
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.black),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            "Full Focus Workout",
                            style: TextStyle(
                              fontSize: 27,
                              color: Color(0xFF2A8CBB),
                              fontFamily: 'Jaapokki',
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ffwSelected
                                  ? Color(0xFF2A8CBB)
                                  : Colors.black,
                              width: 2,
                            ),
                            color: ffwSelected
                                ? Color(0xFF2A8CBB)
                                : Colors.transparent,
                          ),
                          width: 35,
                          height: 35,
                          child: ffwSelected
                              ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "All exercises will be divided into sets and listed by weight. They "
                            "will be shown in order as you perform them.",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Jaapokki',
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                if(!sSelected){
                  setState(() {
                    swapSelections();
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.black),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            "Simple Workout",
                            style: TextStyle(
                              fontSize: 27,
                              color: Color(0xFF2A8CBB),
                              fontFamily: 'Jaapokki',
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sSelected
                                  ? Color(0xFF2A8CBB)
                                  : Colors.black,
                              width: 2,
                            ),
                            color: sSelected
                                ? Color(0xFF2A8CBB)
                                : Colors.transparent,
                          ),
                          width: 35,
                          height: 35,
                          child: sSelected
                              ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Follows all exercises for a workout, wchich is done in the background."
                            "When the job is done, you can add any changes to the summary.",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Jaapokki',
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB),
                  backgroundColor: Colors.white,
                  // button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // button border radius
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  LastInfo(pg: widget.pg,type: ffwSelected)),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'NEXT STEP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Jaapokki',
                          // button text color
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/right_arrow.png',
                      width: 30, // dostosuj rozmiar obrazka
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
