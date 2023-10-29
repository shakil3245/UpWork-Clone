// class newwidgets extends StatefulWidget {
//   const newwidgets({Key? key}) : super(key: key);
//
//   @override
//   State<newwidgets> createState() => _newwidgetsState();
// }
//
// class _newwidgetsState extends State<newwidgets> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: snapshot.data!.docs.map((DocumentSnapshot document) {
//         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//         return InkWell(
//           onTap: (){},
//           onLongPress: (){},
//           child: Card(child: ListTile(
//             // leading: Container(
//             //   padding: const EdgeInsets.only(right: 12),
//             //   decoration:
//             //   const BoxDecoration(border: Border(right: BorderSide(width: 1))),
//             //   child: Image.network(data["userImage"]),
//             // ),
//             title: Text(data["jobTitle"],maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),),
//             subtitle: Column(
//               children: [
//                 Text(data["name"],
//                   style: const TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),),
//                 Text(data["jobDescription"],maxLines: 4,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 18, color: Colors.black,),),
//
//               ],),
//             trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,),
//
//           ),),
//         );
//       }).toList(),
//     );
//   }
// }
