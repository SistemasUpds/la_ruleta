import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'dart:math';

class YourWidget extends StatefulWidget {
  const YourWidget({super.key});
  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  final StreamController<int> _selectedStreamController =
      StreamController<int>.broadcast();
  Stream<int> get selectedStream => _selectedStreamController.stream;

  int selected = 0;
  int rotation_count = 10;
  final List<int> point = List<int>.filled(8, 0);
  final List<String> items = [
    'CUADERNO', //1 DE 20 -- 20
    'LLAVERO', //1 DE 3 -- 80
    'ESTUCHE O LAPICERO', //1 DE 2 --300
    'LIBRETA', //1 DE 5  -- 100
    '1/2 BECA', //1 DE 20 -- 20
    'BECA FUNDESIDS', //1 DE 10 -- 20
    '1/2 BECA', //1 DE 30 -- 20
    'TOMA TODO', //1 DE 10 -- 100
  ];

  int spins = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BakcGround.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = spinWheel();
                point[selected] = point[selected] + 1;
                _selectedStreamController.add(selected);
                spins++;
              });
            },
            child: FortuneWheel(
              styleStrategy: const AlternatingStyleStrategy(),
              rotationCount: rotation_count,
              onFling: () {
                setState(() {
                  selected = Random().nextInt(items.length);
                  point[selected] = point[selected] + 1;
                  _selectedStreamController.add(selected);
                });
              },
              selected: selectedStream,
              items: [
                for (var it in items)
                  FortuneItem(
                    child: Text(
                      it,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int spinWheel() {
    int randomNumber = Random().nextInt(50); // Número aleatorio entre 0 y 99
    if (spins % 20 == 0) {
      // Cada 20 giros, selecciona 'CUADERNO'
      return 0; // 'CUADERNO'
    } else if (spins % 5 == 0) {
      // Cada 5 giros, selecciona 'LLAVERO' o 'LIBRETA'
      /*if (randomNumber < 50) {
        return 7; // 'TOMA TODO'
      } else {*/
      return 1; // 'LLAVERO'
      //}
    } else if (spins % 2 == 0) {
      // Cada 2 giros, selecciona aleatoriamente entre 'ESTUCHE O LAPICERO' y 'TOMA TODO'
      return randomNumber < 25 ? 3 : 7;
    } else if (spins % 7 == 0) {
      // Cada 10 giros, selecciona un regalo poco común
      if (randomNumber < 20) {
        return 5; // 'BECA FUNDESIDS'
      } else if (randomNumber < 10 + 30) {
        return 6; // '1/2 BECA'
      } /*else if (randomNumber < 10 + 30 + 10) {
        return 7; // 'TOMA TODO'
      }*/
    }
    // Selecciona un regalo común
    return 2; // 'ESTUCHE O LAPICERO'
  }

  @override
  void dispose() {
    _selectedStreamController.close();
    super.dispose();
  }
}
