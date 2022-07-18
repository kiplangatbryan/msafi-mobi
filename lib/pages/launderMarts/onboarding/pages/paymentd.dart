// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../components/snackback_component.dart';
// import '../../../../helpers/http_services.dart';
// import 'package:http/http.dart' as http;

// import '../../../../providers/orders.providers.dart';

// class payment extends StatefulWidget {
//   const payment({Key? key}) : super(key: key);

//   @override
//   State<payment> createState() => _paymentState();
// }

// class _paymentState extends State<payment> {
//   bool loading = false;
//   bool success = false;
//   String paymenId = "";

//   Future<void> createOrder() async {
//     final token = await checkAndValidateAuthToken();
//     setState(() {
//       loading = true;
//     });
//     var url = Uri.parse('${baseUrl()}/store/createOrder');
//     // ignore: use_build_context_synchronously
//     final order = context.read<Order>();
//     final body = {
//       "amount": order.amount,
//       "stationId": order.stationId,
//       "clothes": order.clothesArray,
//       "storeId": order.storeId,
//       "expectedPickUp": order.expectedDate,
//     };
//     final headers = {
//       "Authorization": "Bearer $token",
//     };

//     try {
//       // send data to server
//       final response = await http
//           .post(
//             url,
//             body: body,
//             headers: headers,
//           )
//           .timeout(
//             const Duration(seconds: 10),
//           );

//       List data = json.decode(response.body);

//       if (response.statusCode == 201) {
//         // ignore: use_build_context_synchronously
//         if (data.length > 3) {
//           setState(() {
//             // _sizePreview = 3;
//             loading = false;
//             success = true;
//           });
//         } else {
//           setState(() {
//             loading = false;
//             success = false;
//           });
//         }
//         // ignore: use_build_context_synchronously
//         // context.read<Order>().

//         Future.delayed(
//             const Duration(seconds: 1),
//             () => {
//                   setState(() {
//                     loading = false;
//                   })
//                 });
//       } else {
//         // _postErrors("Email or password is Incorrect");
//       }
//     } on SocketException {
//       customSnackBar(
//           context: context, message: "Unable to connect", onPressed: () {});
//     } on TimeoutException catch (e) {
//       customSnackBar(
//           context: context, message: "Connection Timeout", onPressed: () {});
//     } on Error catch (e) {
//       // print(e);
//       setState(() {
//         success = false;
//         loading = false;
//       });
//       customSnackBar(
//           context: context, message: "{$e.toString()}", onPressed: () {});
//     }
//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Payment",
//           style: Theme.of(context).textTheme.headline6,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_outlined,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 30,
//           horizontal: 20,
//         ),
//         child: Column(
//           children: [
//             Text("Payment Method",
//                 style: Theme.of(context).textTheme.headline6),
//             const SizedBox(
//               height: 25,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 20,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Mpesa",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   const Icon(Icons.person),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
