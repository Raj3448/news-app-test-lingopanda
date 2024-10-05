import 'package:firebase_auth/firebase_auth.dart';
import 'package:newshub/core/services/firebase_auth_service.dart';
import 'package:newshub/core/util/token_manager.dart';
import 'package:newshub/view_models/user_model.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  Future<Either<String, UserModel>> signUp(
      String email, String password, String name) async {
    try {
      final user = await _firebaseAuthService.signUp(email, password);
      if (user != null) {
        await _firebaseAuthService
            .storeUserData(UserModel(uid: user.uid, name: name, email: email));
        TokenManager().saveToken(await user.getIdToken() ?? user.uid);
        return Right(UserModel(uid: user.uid, name: name, email: email));
      } else {
        return const Left('Sign-up failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left('Sign-up failed: ${e.toString()}');
    }
  }

  Future<Either<String, UserModel>> signIn(
      String email, String password) async {
    try {
      final user = await _firebaseAuthService.signIn(email, password);
      if (user != null) {
        TokenManager().saveToken(await user.getIdToken() ?? user.uid);
        return Right(UserModel(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? ''));
      } else {
        return const Left('Sign-in failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left('Sign-in failed: ${e.toString()}');
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuthService.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left('Sign-out failed: ${e.toString()}');
    }
  }
}
