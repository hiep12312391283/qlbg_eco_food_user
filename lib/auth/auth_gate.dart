// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:qlbh_eco_food/features/home/view/home_page.dart';
// import 'package:qlbh_eco_food/features/login/view/login_page.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return  HomePage();
//           } else {
//             return LoginPage(
//               onTap: () {},
//             );
//           }
//         },
//       ),
//     );
//   }
// }
