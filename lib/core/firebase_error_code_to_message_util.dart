String firebaseErrorCodetoErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Please enter valid email';

    case 'user-disabled':
      return 'This account is currently disabled! Please contact admin';
    case 'network-request-failed':
      return 'No Internet Connection';
    case 'wrong-password':
      return 'Please Enter correct password';
    case 'user-not-found':
      return 'Email is not in our records';
    case 'too-many-requests':
      return 'Too many attempts please try later';
    case 'invalid-credential':
      return 'Wrong credentials';
    case 'email-already-in-use':
      return 'This email already has an account';
    case 'operation-not-allowed':
      return 'Seems an issue with account. Please contact admin';
    case 'weak-password':
      return 'Password is weak. Please set a strong password';
    case 'INVALID_LOGIN_CREDENTIALS':
      return 'Invalid credentials!! Please check email and password combination';

    default:
      return 'Oops!! Something went wrong, please try again';
  }
}
