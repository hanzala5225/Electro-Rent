//
// import 'package:flutter/material.dart';
//
// class AppointmentRequestsScreen extends StatelessWidget {
//   const AppointmentRequestsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  DraggableScrollableSheet(
//         initialChildSize: 0.5,
//         minChildSize: 0.5,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(70),
//                   topRight: Radius.circular(70),
//                 ),
//               ),
//               padding: EdgeInsets.only(left: 40,right: 40, top: 30),
//               child:  SingleChildScrollView(
//                 controller: scrollController,
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Appointment Requests"),
//                     SizedBox(height: 10,),
//
//                   ],
//                 ),
//               )
//           );
//         },
//       ),
//     );
//   }
// }
