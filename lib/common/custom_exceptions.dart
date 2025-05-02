class IncorrectOtpAfterVerification implements Exception{
  final String errorMessage;
  final double submitCoolDownEnd;

  IncorrectOtpAfterVerification({required this.errorMessage, required this.submitCoolDownEnd});

}


class OtpAttemptsSurpassed implements Exception{
    final String errorMessage;

  OtpAttemptsSurpassed({required this.errorMessage});

}