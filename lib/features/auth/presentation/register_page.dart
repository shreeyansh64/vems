import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Register Page')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(decoration: InputDecoration(labelText: 'Email')),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: Text("Get OTP")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
