import 'package:flutter/material.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool _isNotificationOn = true;
  Future NotificationConfirmMessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            icon: Icon(
              Icons.warning,
              color: Colors.green,
              size: 50,
              weight: 50,
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            contentPadding: const EdgeInsets.all(30),
            actionsPadding: const EdgeInsets.only(bottom: 30,left: 20,right: 20),
            content: Text(
              "Are you sure you want to turn off notification",
              textAlign: TextAlign.center,
            ),
            actions: [
                Flex(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: Axis.horizontal, children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _isNotificationOn = true;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 10,),
                     Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _isNotificationOn = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        elevation: 0,
                      ),
                    ),
                  ]),
              // )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          "Notification Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Align(
              child: Text("Push notifications"),
              alignment: Alignment.centerLeft,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              height: 50,
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Receive notification"),
                  Switch(
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade200,
                      activeTrackColor: Colors.green,
                      value: _isNotificationOn,
                      onChanged: (value) {
                        setState(() {
                          _isNotificationOn = value;
                        });
                        if (_isNotificationOn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "You turned on notifications",
                                  style: TextStyle(color: Colors.white),
                                )),
                          );
                        } else {
                          NotificationConfirmMessage(context);
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
