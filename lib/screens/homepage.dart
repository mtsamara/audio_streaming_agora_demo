import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audio_streaming_agora_demo/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _channelName = TextEditingController();
  late List<bool> isSelected;
  int selectedPage = 0;
  ClientRole _role = ClientRole.Audience;

  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.laptop),
                          hintText: 'Channel Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Channel name is a required field';
                          } else {
                            return null;
                          }
                        },
                        controller: _channelName,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'User Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User name is a required field';
                          } else {
                            return null;
                          }
                        },
                        controller: _userName,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ToggleButtons(
                borderRadius: BorderRadius.circular(15),
                borderWidth: 2,
                borderColor: Colors.black,
                selectedBorderColor: Colors.black,
                selectedColor: Colors.white,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.87 / 2,
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: Text('Audience',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.87 / 2,
                    padding: const EdgeInsets.all(8),
                    child: const Center(child: Text('Broadcaster')),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                    selectedPage = index;
                  });
                  if (selectedPage == 0) {
                    setState(() {
                      _role = ClientRole.Audience;
                    });
                  } else {
                    setState(() {
                      _role = ClientRole.Broadcaster;
                    });
                  }
                  print(selectedPage);
                },
                fillColor: Colors.grey,
                isSelected: isSelected,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.16,
                child: ElevatedButton(
                  // color: Colors.blue,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _handleMicPermission();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CallScreen(
                                channelName: _channelName.text,
                                userName: _userName.text,
                                role: _role,
                              )));
                    }
                  },
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _handleMicPermission() async {
    final status = await Permission.microphone.request();
    print(status);
  }
}
