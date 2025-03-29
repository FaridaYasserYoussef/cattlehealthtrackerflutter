import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_api_data_source.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';

class ServiceLocator {
  static AuthenticationDataSource authenticationDataSource = AuthenticationApiDataSource();
}