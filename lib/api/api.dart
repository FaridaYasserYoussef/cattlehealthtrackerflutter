class API{
  static const hostConnect = "https://due-crista-arabic-historiograhy-bab865db.koyeb.app";// uncommented when redeploying
  // static const hostConnect = "http://192.168.1.16:8000";// commented when redeploying

  static const refreshTokenEnpoint = "/api/token/refresh/";
  static const hostConnectAuthentication = "/auth";
  static const hostConnectAuthenticationLogin = "$hostConnectAuthentication/custom_login";
  static const hostConnectAuthenticationOtp = "$hostConnectAuthentication/otp";
  static const hostConnectAuthenticationResendOtp = "$hostConnectAuthentication/resend_otp";
  static const hostConnectAuthenticationChangePassword= "$hostConnectAuthentication/change_password";
  static const hostConnectAuthenticationToggle2fa = "$hostConnectAuthentication/toggle_2fa";
  static const hostConnectAuthenticationLogout = "$hostConnectAuthentication/logout";

}
