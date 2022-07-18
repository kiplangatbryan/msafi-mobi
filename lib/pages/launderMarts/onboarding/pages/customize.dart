// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/http_services.dart';
import '../../../../providers/user.provider.dart';

class CustomizeStore extends StatefulWidget {
  const CustomizeStore({Key? key}) : super(key: key);

  @override
  State<CustomizeStore> createState() => _CustomizeStoreState();
}

class _CustomizeStoreState extends State<CustomizeStore> {
  List<XFile>? imageFileList = [];
  bool selectedImageState = false;
  bool success = true;
  bool loading = false;
  final _picker = ImagePicker();

  _displayPickImageDialog() async {
    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage();
      if (pickedFileList != null) {
        setState(() {
          imageFileList = pickedFileList;
          selectedImageState = true;
        });
      }
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

  createOrUpdateStore() async {
    setState(() {
      loading = true;
    });
    final store = context.read<MartConfig>();
    final token = await checkAndValidateAuthToken();

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

    final payment = {
      "paybill": "",
      "enabled": false,
    };
    formData.fields.add(MapEntry("name", store.uname));
    formData.fields.add(MapEntry("address", store.uaddress));
    formData.fields.add(MapEntry("description", store.udescription));
    formData.fields.add(MapEntry("pricing", json.encode(store.upricing)));
    formData.fields.add(MapEntry("phone", store.bsphone));
    formData.fields.add(MapEntry("locations", json.encode(store.ulocations)));
    formData.fields.add(MapEntry("payment", json.encode(payment)));

    // print(formData.fields);

    try {
      // send data to server
      Response resp = await dio.post('${baseUrl()}/store/createStore',
          data: formData,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type":
                "multipart/form-data; boundary=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MmM2NWU0M2FlOWZmNDM5ZjBiZDcxMGIiLCJpYXQiOjE2NTc4MTQxMjksImV4cCI6MTY1NzgxNTkyOSwidHlwZSI6ImFjY2VzcyJ9.IqrkKLUREzNV8JaXabWk3HYweh12PHZ5kpDgoZq_kio",
            "Authorization": "Bearer $token"
          }));

      if (resp.statusCode == 201) {
        setState(() {
          loading = false;
          success = true;
        });
        await _proceed();
      } else {
        setState(() {
          loading = false;
          success = false;
        });
      }
      // if (response) {}
    } catch (err) {
      setState(() {
        loading = false;
        success = false;
      });
    }
  }

  fetchUser() async {
    final token = await checkAndValidateAuthToken();
    final dio = Dio();
    try {
      Response response = await dio.get('${baseUrl()}/auth/fetch-user',
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        customSnackBar(
            context: context, message: "Invalid response", onPressed: () {});
      }
    } catch (err) {
      customSnackBar(
          context: context, message: "Server comms failed", onPressed: () {});
    }
  }

  _proceed() async {
    // fetch user data
    final user = await fetchUser();

    if (user != null) {
      await context.read<User>().createUser(user);
      context.read<MartConfig>().populateStore(user['stores'][0]);

      return Navigator.of(context)
          .pushNamedAndRemoveUntil('/mart-home', (route) => false);
    }
    customSnackBar(
        context: context,
        message: "There was a problem try again",
        onPressed: () {});
    // naviagate to home
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                selectedImageState
                    ? afterImages(
                        onPressed: _resetAndPickImages,
                        imageFileList: imageFileList,
                      )
                    : beforeImages(
                        onPressed: _displayPickImageDialog,
                      ),
                selectedImageState
                    ? customExtendButton(
                        background: Colors.red,
                        ctx: context,
                        child: !loading
                            ? !success
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Retry",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: kTextLight),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Icon(Icons.redo_rounded),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Upload and Finish",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: kTextLight),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Icon(Icons.check),
                                    ],
                                  )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Creating ...   ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kTextLight,
                                        ),
                                  ),
                                  const SizedBox(width: 20),
                                  const CircularProgressIndicator(
                                    color: kTextLight,
                                  ),
                                ],
                              ),
                        onPressed: () async {
                          await createOrUpdateStore();
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class afterImages extends StatelessWidget {
  Function onPressed;
  afterImages({
    required this.onPressed,
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
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 18,
              ),
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
          height: 30,
        ),
      ],
    );
  }
}

class beforeImages extends StatelessWidget {
  final Function onPressed;

  const beforeImages({
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
