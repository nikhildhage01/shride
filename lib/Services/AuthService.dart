import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService{

    FirebaseAuth _auth = FirebaseAuth.instance;

    Stream<FirebaseUser> get user{
        return _auth.onAuthStateChanged;
    }
    //sing up
    Future registerWithEmailAndPass(String email,String pass) async{
        try{
            AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
            FirebaseUser firebaseUser = result.user;
            await DatabaseService(uid: firebaseUser.uid).updateProfile('','','','',firebaseUser.uid);
            return firebaseUser;
        }
        catch(e){
            print(e);
            return null;
        }
    }

    //sign in
    Future loginWithEmailAndPass(String email,String pass) async{
        try{
            AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
            FirebaseUser firebaseUser = result.user;
            return firebaseUser;
        }
        catch(e){
            print(e);
            return null;
        }
    }

    //sign out
    Future signOut() async{
        try{
            return await _auth.signOut();
        }
        catch(e){
            print(e);
        }
    }
}