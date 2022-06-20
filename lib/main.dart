// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/blocs/authentication_bloc.dart';
import 'package:firebase_login/blocs/login_bloc.dart';
import 'package:firebase_login/blocs/simple_bloc_observer.dart';
import 'package:firebase_login/events/authentication_event.dart';
import 'package:firebase_login/pages/home_page.dart';
import 'package:firebase_login/pages/login_page.dart';
import 'package:firebase_login/pages/splash_page.dart';
import 'package:firebase_login/repositories/user_repository.dart';
import 'package:firebase_login/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//In this lesson, we will build User Interface(UI)
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    //signout for testing firstly !

    return MaterialApp(
      title: 'Login with Firebase',
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
                            ..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if(authenticationState is AuthenticationStateSuccess) {
              return HomePage();
            } else if(authenticationState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(userRepository: _userRepository),
                child: LoginPage(userRepository: _userRepository,)//LoginPage,
              );
            }
            return SplashPage();
          },
        ),
      )
    );
  }
}