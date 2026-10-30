import 'package:flutter/material.dart';

void main(){
  runApp(const MyWidget());
}
class MyWidget extends StatefulWidget {
  const MyWidget ({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String message = "Flutter Intern Blog";
  void changeMessage(){
  setState((){
  message ='Welcome to Intern Blog!';
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Intern Blog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 238, 238),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 155, 32, 32),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 40),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Icon(Icons.person),
                  const SizedBox(width: 10),
                  Text(
                    'Aung Aung',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    const SizedBox(width: 20),
                    Text('Admin'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: changeMessage,
                  child: const Text(
                    'Click Me',
                    style: TextStyle(fontSize: 20),
                  ),
                  ),
                  const SizedBox(width: 40),
                   ElevatedButton(
                    onPressed: changeMessage,
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20),
                  ),
                  ),
          
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}