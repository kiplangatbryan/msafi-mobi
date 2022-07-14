import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/http_services.dart';

class CustomizeStore extends StatefulWidget {
  const CustomizeStore({Key? key}) : super(key: key);

  @override
  State<CustomizeStore> createState() => _CustomizeStoreState();
}

class _CustomizeStoreState extends State<CustomizeStore> {
  List<XFile>? imageFileList = [];
  bool selectedImageState = false;

  final _picker = ImagePicker();

  _displayPickImageDialog() async {
    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage();
      setState(() {
        imageFileList = pickedFileList;
        selectedImageState = true;
      });
    } catch (e) {
      customSnackBar(context: context, message: e.toString(), onPressed: () {});
    }
  }

  _resetAndPickImages() async {
    setState(() {
      imageFileList = [];
    });
    await _displayPickImageDialog();
  }

  Future<void> getLostData() async {}

  Future<int> createOrUpdateStore() async {
    var url = Uri.parse('');
    final store = context.read<MartConfig>();
    final token = await checkAndValidateAuthToken();

    // print(data);
    // return 1;
    // final body = json.encode(data);

    final dio = Dio();
    FormData formData = FormData();
    //  compile our images
    for (var file in imageFileList!) {
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])?.split('/');
      formData.files.add(
        MapEntry(
          "avatar",
          await MultipartFile.fromFile(
            file.path,
            contentType: MediaType(
              mimeTypeData![0],
              mimeTypeData[1],
            ),
          ),
        ),
      );
    }

    formData.fields.add(MapEntry("name", store.uname));
    formData.fields.add(MapEntry("address", store.uaddress));
    formData.fields.add(MapEntry("description", store.udescription));
    formData.fields.add(MapEntry("pricing", json.encode(store.upricing)));
    formData.fields.add(MapEntry("phone", store.bsphone));
    formData.fields.add(MapEntry("locations", json.encode(store.ulocations)));
    print(formData.fields);

    try {
      // send data to server
      final response = await dio.post('${baseUrl()}/store/createStore',
          // data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 201) {
        return 0;
      } else {
        return 1;
      }
    } catch (err) {
      print(err);
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: .3,
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          "Customize",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: selectedImageState
              ? SingleChildScrollView(
                  child: afterImages(
                    onSubmit: createOrUpdateStore,
                    onPressed: _resetAndPickImages,
                    imageFileList: imageFileList,
                  ),
                )
              : SingleChildScrollView(
                  child: beforeImages(
                    onPressed: _displayPickImageDialog,
                  ),
                ),
        ),
      ),
    );
  }
}

class afterImages extends StatelessWidget {
  Function onPressed;
  Function onSubmit;
  afterImages({
    required this.onPressed,
    required this.onSubmit,
    Key? key,
    required this.imageFileList,
  }) : super(key: key);

  final List<XFile>? imageFileList;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Selected Images",
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 30,
        ),
        GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
          ),
          physics: const ScrollPhysics(),
          children: List.generate(
            imageFileList!.length,
            (index) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(
                      File(imageFileList![index].path),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          textAlign: TextAlign.center,
          "These images will be your Frontier.\nTo reset the selection? click reset button",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () => onPressed(),
          child: Text(
            "Reset Selection",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        customExtendButton(
          ctx: context,
          child: Text(
            "Proceed",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: kTextLight),
          ),
          onPressed: () async {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => const ProductSelection(),
            //   ),
            // );
            await onSubmit();
          },
        ),
      ],
    );
  }
}

class beforeImages extends StatelessWidget {
  Function onPressed;

  beforeImages({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: Lottie.asset(
            "assets/lottie/image-point.json",
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          textAlign: TextAlign.center,
          "Images are very important\nselect a maximum of three images that will sell you",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 50,
        ),
        customExtendButton(
          ctx: context,
          child: Text(
            'Choose images',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: kTextLight,
                ),
          ),
          onPressed: () => onPressed(),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          textAlign: TextAlign.center,
          "* Ensure you include an external view of the store",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.red,
                fontSize: 15,
              ),
        ),
      ],
    );
  }
}
