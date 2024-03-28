import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';

final User currentUser = AuthService().currentUser!;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;
