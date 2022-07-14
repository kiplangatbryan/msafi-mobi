import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:provider/provider.dart';

import '../../../../providers/user.provider.dart';
import '../../../../themes/main.dart';
import 'customize.dart';

class SelectedSpots extends StatefulWidget {
  final Map description;
  const SelectedSpots({required this.description, Key? key}) : super(key: key);

  @override
  State<SelectedSpots> createState() => _SelectedSpotsState();
}

class _SelectedSpotsState extends State<SelectedSpots> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController cursor = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  bool isSelected = false;
  XFile? selectedImage;

  imageSelector() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        selectedImage = pickedFile;
        isSelected = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _updateLocations() {
    final form = _formKey.currentState;
    final List<Map<dynamic, dynamic>> locations = [];
    if (form!.validate()) {
      locations.add({...widget.description, "name": titleController.text});
      context.read<MartConfig>().setLocations(locations);
    }
  }

  @override
  void initState() {
    super.initState();
    final username = context.read<User>().name;
    titleController.text = "$username site 1";
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        title:
            Text("Your pick ups", style: Theme.of(context).textTheme.headline6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            children: [
              Text(
                "Phew! Congrats, now Lets Customize your pick up",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: customTextFieldInput(
                  hint: "Name It",
                  icon: const Icon(Icons.store_outlined),
                  inputType: TextInputType.text,
                  label: "Enter a catchy name",
                  onChanged: (val) {},
                  onSubmit: (val) {},
                  validator: (val) {
                    if (val == "") {
                      return "field cannot be blank!";
                    }
                    return null;
                  },
                  textController: titleController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   "Choose an Image that will allow users to easily Idenity your location",
              //   style: Theme.of(context).textTheme.headline6!.copyWith(
              //         height: 1.6,
              //       ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // if (isSelected)
              //   Container(
              //     height: 200,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       image: DecorationImage(
              //         image: FileImage(
              //           File(selectedImage!.path),
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              // !isSelected
              //     ? TextButton(
              //         onPressed: () {
              //           imageSelector();
              //         },
              //         child: Row(
              //           children: [
              //             Icon(
              //               Icons.image,
              //               size: 22,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //             const SizedBox(
              //               width: 20,
              //             ),
              //             Text(
              //               "Choose image",
              //               style:
              //                   Theme.of(context).textTheme.headline6!.copyWith(
              //                         color: Theme.of(context).primaryColor,
              //                       ),
              //             )
              //           ],
              //         ))
              //     : TextButton(
              //         onPressed: () {
              //           setState(() {
              //             selectedImage = null;
              //           });
              //           imageSelector();
              //         },
              //         child: Row(
              //           children: [
              //             Icon(
              //               Icons.image,
              //               size: 22,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //             const SizedBox(
              //               width: 20,
              //             ),
              //             Text(
              //               "Tap to reset",
              //               style:
              //                   Theme.of(context).textTheme.headline6!.copyWith(
              //                         color: Theme.of(context).primaryColor,
              //                       ),
              //             )
              //           ],
              //         ),
              //       ),
              const SizedBox(
                height: 60,
              ),
              Text(
                textAlign: TextAlign.center,
                "Only press this button after you have added all the locations needed",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 15,
              ),
              customExtendButton(
                ctx: context,
                child: Text(
                  "Let's proceed",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: kTextLight,
                      ),
                ),
                onPressed: () {
                  _updateLocations();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CustomizeStore(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class customTextFieldInput extends StatelessWidget {
  TextEditingController? textController;
  String hint;
  String label;
  TextInputType inputType;
  Icon icon;
  Function validator;
  Function onChanged;
  Function onSubmit;
  int? minLines;
  int? maxLines;

  customTextFieldInput(
      {required this.hint,
      this.textController,
      required this.label,
      required this.inputType,
      required this.icon,
      required this.validator,
      required this.onChanged,
      required this.onSubmit,
      this.minLines,
      this.maxLines,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val),
      onSaved: (val) => onSubmit(val),
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorHeight: 17,
      keyboardType: inputType,
      minLines: minLines,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: kTextMediumColor.withOpacity(.4)),
        floatingLabelStyle: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: kTextMediumColor.withOpacity(.4)),
        filled: true,
        fillColor: Theme.of(context).primaryColor.withOpacity(.06),
        prefixIcon: icon,

        // ? const Icon(Icons.mail_outline, size: 18)
        // : const Icon(Icons.lock_open_outlined, size: 18),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(.3),
          ),
          gapPadding: 10,
        ),
      ),
    );
  }
}
