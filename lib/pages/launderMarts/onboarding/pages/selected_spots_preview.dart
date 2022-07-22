import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
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

  bool disabled = false;
  List<Map> pickUps = [];
  bool showInput = true;

  _updateLocations() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        disabled = true;
        pickUps.add({...widget.description, "name": titleController.text});
        showInput = false;
      });
    }
  }

  syncChanges() {
    final storeLocs = context.read<MartConfig>();
    storeLocs.setLocations(pickUps);
  }

  @override
  void initState() {
    super.initState();
    final username = context.read<User>().name;
    titleController.text = "$username site 1";
    final storeLocs = context.read<MartConfig>().locations;

    if (storeLocs.isNotEmpty) {
      setState(() {
        pickUps = storeLocs;
      });
    }
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
          child: pickUps.isEmpty && !showInput
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/map-location.json',
                      height: 300,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Tap the button to select pick ups",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // save current changes
                        syncChanges();
                        // go back to map
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add Location",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    showInput
                        ? Text(
                            "Phew! Congrats, now Lets Customize your pick up",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                  height: 1.6,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          )
                        : Text(
                            "These are your designated spots",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                  height: 1.6,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (pickUps.isNotEmpty)
                      LimitedBox(
                        maxHeight: 800,
                        child: ListView.builder(
                            physics: const ScrollPhysics(),
                            itemCount: pickUps.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, index) {
                              final pickup = pickUps[index];
                              return Dismissible(
                                key: Key('key_$index'),
                                onDismissed: (direction) {
                                  setState(() {
                                    pickUps.removeAt(index);
                                  });
                                  customSnackBar(
                                      context: context,
                                      message: "location data deleted",
                                      onPressed: () {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.5,
                                        color: const Color(0xFFDDDDDD),
                                      )),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    pickup['name'],
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              );
                            }),
                      ),
                    if (pickUps.isNotEmpty)
                      OutlinedButton(
                        onPressed: () {
                          // save current changes
                          syncChanges();
                          // go back to map
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add Location",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    if (showInput)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                            height: 15,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _updateLocations();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.save),
                                const SizedBox(width: 10),
                                Text(
                                  "Save Location",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Only press this button after you have added all the locations needed",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 25,
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
                        if (pickUps.isNotEmpty) {
                          syncChanges();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const CustomizeStore(),
                            ),
                          );
                        } else {
                          customSnackBar(
                              context: context,
                              message: "pickups cannot be empty",
                              onPressed: () {});
                        }
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
