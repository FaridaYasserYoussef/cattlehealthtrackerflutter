class IncorrectOtpAfterVerification implements Exception{
  final String errorMessage;
  final double submitCoolDownEnd;

  IncorrectOtpAfterVerification({required this.errorMessage, required this.submitCoolDownEnd});

}


class OtpAttemptsSurpassed implements Exception{
    final String errorMessage;

  OtpAttemptsSurpassed({required this.errorMessage});

}

class OtpNotSet implements Exception{
  final String errorMessage;

  OtpNotSet({required this.errorMessage});

}

class OldPasswordIncorrect implements Exception{
    final String errorMessage;

  OldPasswordIncorrect({required this.errorMessage});
}

class FailedToSendPasswordResetEmail implements Exception{
  final String errorMessage;

  FailedToSendPasswordResetEmail({required this.errorMessage});

}

class PasswordResetEmailAddressNotFound implements Exception{
  final String errorMessage;

  PasswordResetEmailAddressNotFound({required this.errorMessage});

}