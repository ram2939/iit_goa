// import 'package:flutter/material.dart';

// class EventCard extends StatelessWidget {
//   final Event event;
//   final bool approved;

//   EventCard({
//     this.event,
//     this.approved,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => EventDetailsScreen(
//               event: event,
//               approved: approved,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 2),
//               blurRadius: 6.0,
//             ),
//           ],
//         ),
//         margin: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               width: SizeConfig.screenWidth,
//               height: SizeConfig.blockSizeVertical * 16,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                 ),
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: CachedNetworkImageProvider(
//                     event.displayImage,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.blockSizeHorizontal * 3,
//                 vertical: SizeConfig.blockSizeVertical,
//               ),
//               child: Text(
//                 event.eventName,
//                 style: GoogleFonts.oswald(
//                   fontWeight: FontWeight.w600,
//                   fontSize: SizeConfig.blockSizeHorizontal * 4.5,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(
//                 left: SizeConfig.blockSizeHorizontal * 3,
//                 bottom: SizeConfig.blockSizeVertical,
//               ),
//               child: Row(
//                 children: <Widget>[
//                   Icon(Icons.location_city),
//                   Text(
//                     event.mode == "Offline" ? "Offline" : "Online",
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.only(
//                         left: SizeConfig.blockSizeHorizontal * 3.5,
//                         bottom: SizeConfig.blockSizeVertical,
//                       ),
//                       child: event.type == "parent"
//                           ? Text("Recurring Event")
//                           : Text("${event.startDate}, ${event.startTime}"),
//                     ),
//                     if (event.description != "")
//                       Container(
//                         padding: EdgeInsets.only(
//                           left: SizeConfig.blockSizeHorizontal * 3.5,
//                           bottom: SizeConfig.blockSizeVertical * 2,
//                         ),
//                         child: Text(event.description),
//                       ),
//                   ],
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(
//                     right: SizeConfig.blockSizeHorizontal * 4,
//                   ),
//                   child: Text(
//                     "₹${event.entryFees}",
//                     style: TextStyle(
//                       fontSize: SizeConfig.blockSizeHorizontal * 4.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
