// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:image_picker/image_picker.dart';

// class CustomzeStore extends StatefulWidget {
//   const CustomzeStore({Key? key}) : super(key: key);

//   @override
//   State<CustomzeStore> createState() => _CustomzeStoreState();
// }

// class _CustomzeStoreState extends State<CustomzeStore> {
//   List<XFile>? imageList;
//   dynamic _pickImageError;
//   String? retrievalDataError;

//   void _setImageFromFile(XFile? value) {
//     imageList = value == null ? null : <XFile>[value];
//   }

//   Future<void> getLostData() async {
//   final LostDataResponse response =
//       await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   if (response.files != null) {
//     for (final XFile file in response.files) {
//       _handleFile(file);
//     }
//   } else {
//     _handleError(response.exception);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Sca.ffold(
//       appBar: AppBar(
//         bottomOpacity: .3,
//         elevation: 1,
//         backgroundColor: Theme.of(context).canvasColor,
       
//         title: Text(
//           "Getting Started",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
            
//           ],
//         ) ,
//       ),
//     );
//   }
// }
