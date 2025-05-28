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

class OldPasswordIncorrect{
    final String errorMessage;

  OldPasswordIncorrect({required this.errorMessage});
}