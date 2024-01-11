import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/firebase/auth.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _signOut,
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await Auth().signOut();
  }
}
