import 'package:cattlehealthtracker/authentication/repository/authentication_repository.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/common/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates>{
    AuthenticationRepository repository;

  AuthenticationCubit(): repository = AuthenticationRepository(dataSource: ServiceLocator.authenticationDataSource), super(AuthenticationInitialState());
    
  
}