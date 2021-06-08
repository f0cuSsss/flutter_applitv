import 'package:flutter/material.dart';
import 'package:Applitv/screens/HomeScreen.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            // color: Colors.yellow,
            child: Image.asset('assets/no_internet_connection.png'),
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width * 0.45,
            child: RaisedButton(
              color: Colors.green[300],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text('Try again ...'),
            ),
          )
        ],
      ),
    );
  }
}
