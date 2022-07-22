import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/helpers/http_services.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http_parser/http_parser.dart';

import '../../../components/form_components.dart';
import '../../../helpers/custom_shared_pf.dart';
import '../../../providers/system.provider.dart';
import '../../../providers/user.provider.dart';
import '../../../themes/main.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  Person? userInfo;
  XFile? imageFile;

  String imageUrl = "";

  final _picker = ImagePicker();

  @override
  void initState() {
    userInfo = context.read<User>().user;
    super.initState();
  }

  _pickImages() async {
    try {
      final pickImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickImage != null) {
        setState(() {
          imageFile = pickImage;
        });
        await _uploadProfilePhoto();
      }
    } catch (err) {
      print(err);
    }
  }

  _uploadProfilePhoto() async {
    FormData formData = FormData();
    final token = await checkAndValidateAuthToken(context);
    final mimeTypeData =
        lookupMimeType(imageFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
    formData.files.add(
      MapEntry(
        "avatar",
        await MultipartFile.fromFile(
          imageFile!.path,
          contentType: MediaType(
            mimeTypeData![0],
            mimeTypeData[1],
          ),
        ),
      ),
    );
    try {
      Response response =
          await httHelper().post('/users/change-profile-picture',
              data: formData,
              options: Options(headers: {
                "Accept": "application/json",
                "Content-Type":
                    "multipart/form-data; boundary=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MmM2NWU0M2FlOWZmNDM5ZjBiZDcxMGIiLCJpYXQiOjE2NTc4MTQxMjksImV4cCI6MTY1NzgxNTkyOSwidHlwZSI6ImFjY2VzcyJ9.IqrkKLUREzNV8JaXabWk3HYweh12PHZ5kpDgoZq_kio",
                "Authorization": "Bearer $token"
              }));

      if (response.statusCode == 201) {
        setState(() {
          imageUrl = response.data['imgUrl'];
        });
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        customSnackBar(
            context: context, message: "connection Timedout", onPressed: () {});
      }
      if (ex.type == DioErrorType.sendTimeout) {
        customSnackBar(context: context, message: "Could not reach server");
      } else {
        customSnackBar(context: context, message: "Bad Request");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    imageUrl == ""
                        ? Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage('assets/app/user.png')),
                                borderRadius: BorderRadius.circular(80)),
                          )
                        : Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage('${baseUrl()}/$imageUrl'),
                                ),
                                borderRadius: BorderRadius.circular(80)),
                          ),
                    Positioned(
                      bottom: 20,
                      right: 125,
                      child: CircleAvatar(
                        minRadius: 20,
                        maxRadius: 28,
                        child: IconButton(
                          onPressed: () async {
                            await _pickImages();
                          },
                          icon: const Icon(
                            Icons.camera_outlined,
                            size: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              CustomBtnLink(
                callback: () {
                  showMaterialModalBottomSheet(
                    expand: true,
                    context: context,
                    useRootNavigator: true,
                    builder: (context) => ChangeUsername(),
                  );
                },
                title: userInfo!.name,
                subtitle: "Tap to change username",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomBtnLink(
                callback: () {},
                title: userInfo!.email,
                subtitle: "Tap to change email",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomBtnLink(
                callback: () {},
                title: userInfo!.role,
                subtitle: "Tap to change password",
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: customExtendButton(
                    ctx: context,
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: kTextLight,
                          ),
                    ),
                    onPressed: () async {
                      final status = await CustomSharedPreferences().logout();
                      if (status) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeUsername extends StatelessWidget {
  const ChangeUsername({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              textAlign: TextAlign.center,
              "Edit Your Username",
              style: Theme.of(context).textTheme.headline6),
          const SizedBox(
            height: 100,
          ),
          customTextField(
            hint: "Enter a new name",
            label: "username",
            inputType: TextInputType.text,
            icon: Icon(Icons.person_add_alt_1_outlined),
            validator: (val) {},
            onChanged: (val) {},
            onSubmit: (val) {},
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: customSmallBtn(
              ctx: context,
              child: Text(
                "Change",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: kTextLight,
                    ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class NavigateToProfile extends StatelessWidget {
  const NavigateToProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 25,
                  maxRadius: 30,
                  child: Text(
                    context.read<User>().name[0].toUpperCase(),
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: kTextLight,
                        ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${context.read<User>().name}\n",
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.7),
                        ),
                      ),
                      TextSpan(
                        text: "view profile",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBtnLink extends StatelessWidget {
  String title;
  String subtitle;
  Function callback;

  CustomBtnLink({
    required this.title,
    required this.subtitle,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
