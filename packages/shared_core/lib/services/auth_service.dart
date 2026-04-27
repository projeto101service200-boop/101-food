import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream do estado do usuário
  Stream<User?> get userStream => _auth.authStateChanges();

  // Login com Email e Senha
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getUserData(result.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  // Cadastro de Novo Cliente
  Future<UserModel?> registerCustomer({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      UserModel newUser = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
        phone: phone,
        role: UserRole.customer,
        status: UserStatus.active,
        createdAt: DateTime.now(),
      );

      await _db.collection('users').doc(newUser.uid).set(newUser.toMap());
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // Buscar dados do usuário no Firestore
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
