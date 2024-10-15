import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';

class TimerCardComponent extends StatefulWidget {
  final Color bgColor;
  final bool breakActive;
  final bool duringActive;
  const TimerCardComponent({Key? key, required this.bgColor, required this.breakActive, required this.duringActive}) : super(key: key);

  @override
  _TimerCardComponentState createState() => _TimerCardComponentState();
}

class _TimerCardComponentState extends State<TimerCardComponent> {
  late TrainingManager manager;

  @override
  void initState() {
    super.initState();
    manager = TrainingManager.tManager;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.bgColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Display group name and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  manager.selectedGroup.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                Image.asset(
                  manager.selectedGroup.iconPath,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // StreamBuilder to display the global time
            StreamBuilder<int>(
              stream: manager.globalTimeStream,
              initialData: manager.returnFullTime().inSeconds,
              builder: (context, snapshot) {
                final elapsedTime = snapshot.data ?? 0;
                final minutes = (elapsedTime ~/ 60).toString().padLeft(2, '0');
                final seconds = (elapsedTime % 60).toString().padLeft(2, '0');
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Color(0xfff0f0f0),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        "Total Time",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Jaapokki',
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/icons/clock.png",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "$minutes:$seconds",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Jaapokki',
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                );
              },
            ),
            if(widget.breakActive || widget.duringActive) const SizedBox(height: 20),
            // Conditionally display the break timer
            if(widget.breakActive)
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (!manager.breakTimerOn) {
                      manager.breakTimerOn = true;
                      manager.startBreakTimer(); // Start the break timer on tap
                    } else {
                      manager.resetBreakTimer();
                      manager.breakTimerOn =
                          false; // Stop the break timer if already running
                    }
                  });
                },
                child: manager.breakTimerOn
                    ? StreamBuilder<int>(
                        stream: manager.breakTimeStream,
                        initialData: manager.returnBreakTime().inSeconds,
                        builder: (context, snapshot) {
                          final breakTime = snapshot.data ?? 0;
                          final minutes =
                              (breakTime ~/ 60).toString().padLeft(2, '0');
                          final seconds =
                              (breakTime % 60).toString().padLeft(2, '0');
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: Color(0xfff0f0f0),
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(width: 15,),
                                  Text(
                                    "Break",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Jaapokki',
                                    ),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/icons/procrastination.png",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 20),  // Space between the image and text
                                  Text(
                                    "$minutes:$seconds",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Jaapokki',
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15.0),  // Padding for the right side of the icon
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.grey,  // Optional: Add color to the icon
                                        size: 26,  // Adjust icon size as needed
                                      ),
                                    ),
                                  ),
                                ],
                              )

                          );
                        },
                      )
                    : Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Color(0xfff0f0f0),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/procrastination.png",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "Add break time",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Jaapokki',
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            if(widget.duringActive)
              StreamBuilder<int>(
                stream: manager.timeStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final breakTime = snapshot.data ?? 0;
                  final minutes =
                  (breakTime ~/ 60).toString().padLeft(2, '0');
                  final seconds =
                  (breakTime % 60).toString().padLeft(2, '0');
                  return Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: Color(0xfff0f0f0),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(width: 15,),
                          Text(
                            "Series",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Jaapokki',
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            "assets/icons/jump_rope.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 20),  // Space between the image and text
                          Text(
                            "$minutes:$seconds",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Jaapokki',
                            ),
                          ),
                          SizedBox(width: 20,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),  // Padding for the right side of the icon
                              child: Icon(
                                Icons.cancel,
                                color: Colors.grey,  // Optional: Add color to the icon
                                size: 26,  // Adjust icon size as needed
                              ),
                            ),
                          ),
                        ],
                      )

                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
