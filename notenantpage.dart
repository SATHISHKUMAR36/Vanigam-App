import 'package:flutter/material.dart';

class NoTenantPage extends StatelessWidget {
  String content;
  NoTenantPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Image.asset(
            "assets/images/ndf.png",
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              content ,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}
