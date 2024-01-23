import 'package:flutter/material.dart';
import 'package:gsoc/home.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 1,
              ),
              const Text("Intelligent Autozoom",
                  style: TextStyle(fontSize: 30)),
              const SizedBox(
                height: 10,
              ),

              const Spacer(
                flex: 1,
              ),
              const Text("Take-home qualification tasks",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const Text(
                  "Task: Camera with intelligent autozoom in Flutter By CCExtractor",
                  style: TextStyle(fontSize: 15)),
              const SizedBox(
                height: 30,
              ),
              const Text("Description", style: TextStyle(fontSize: 15)),
              const Text(
                  "Write a Flutter app that lets you take pictures of anything and autozooms to the right size to pick up an object that is in view. For example: Take a collection of dogs, or cats (there are probably pretrained models for this, it's up to you to look them up). If your app is used to take a picture of a dog, then the zoom should be automatically adjusted to take a picture of the dog in foreground, even if the dog is a bit far.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15)),
              const Spacer(
                flex: 1,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: MaterialButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(title: 'Model Testing')),
                      );
                    },
                    child: const Text("Let's Start"),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ThirdModel(),
              //         ),
              //       );
              //     },
              //     child: const Text('Start'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
