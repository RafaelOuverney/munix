import 'package:flutter/material.dart';
// Removed unnecessary import as all elements are provided by 'package:flutter/material.dart'.
import 'package:munix/pages/home.dart';
import 'package:munix/pages/login.dart';
import 'package:munix/services/auth_service.dart';

class AuthLayout extends StatelessWidget{
  const AuthLayout({
    super.key,
    this.pageIfNotConnected,
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: authService, 
    builder: (context, authService, child) {
      return StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return pageIfNotConnected ?? const Login();
          }
        },
      );
    });
  }}