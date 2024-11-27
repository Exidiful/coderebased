class AppStrings {
  // Collections
  static const String usersCollection = 'Users';
  
  // Email Configuration
  static const String emailDomain = '@utb.edu.bh';
  static const String emailPrefix = 'BH';
  
  // Validation
  static const String studentIdPattern = r'^\d{8}$';
  
  // Timeouts
  static const int authTimeoutSeconds = 30;
  
  // Error Messages
  static const String invalidStudentIdMessage = 
      'Please enter a valid 8-digit student ID';
  static const String authTimeoutMessage = 
      'Request timed out. Please try again.';
  static const String userNotFoundError = 
      'No user found with this student ID';
  static const String wrongPasswordError = 
      'Wrong password provided';
  static const String invalidStudentIdError = 
      'Invalid student ID format';
  static const String emailInUseError = 
      'An account already exists with this student ID';
  static const String genericError = 
      'An error occurred. Please try again';
  static const String notAuthenticatedError = 
      'User is not authenticated';
  static const String weakPasswordError = 
      'Password should be at least 6 characters';
  static const String tooManyRequestsError = 
      'Too many attempts. Please try again later';
  static const String signOutError = 
      'Error signing out. Please try again';
}
