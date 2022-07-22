import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/form_components.dart';
import '../../../providers/orders.providers.dart';
import '../../../themes/main.dart';
import 'checkout.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  DateTime? selectedDate;

  TextEditingController dateInputController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _launchDatePicker(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      primaryColor: Colors.cyan,
      backgroundColor: Colors.grey[900],
      calendarTextColor: Colors.white,
      tabTextColor: Colors.white,
      unselectedTabBackgroundColor: Colors.grey[700],
      buttonTextColor: Colors.white,
      timeSpinnerTextStyle:
          const TextStyle(color: Colors.white70, fontSize: 18),
      timeSpinnerHighlightedTextStyle:
          const TextStyle(color: Colors.white, fontSize: 24),
      is24HourMode: false,
      isShowSeconds: false,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      borderRadius: const Radius.circular(16),
    );

    _selectDate(dateTime);
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null && newSelectedDate != selectedDate) {
      setState(() {
        selectedDate = newSelectedDate;
        dateInputController.text = Moment(selectedDate as DateTime).calendar();
      });
    }
  }

  _saveToStore() {
    context.read<Order>().setExpectedData(selectedDate);
    context.read<Order>().setPhoneNumber(phoneController.text);
  }

  _proceed() {
    final form = _formKey.currentState;

    if (form!.validate() && dateInputController.text.length > 1) {
      // save values to store
      _saveToStore();
      print("phone ${phoneController.text}");
      // navigate to next page
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (_) => const CheckOut()));
    } else {
      customSnackBar(
          context: context,
          message: "Fields cannot be empty",
          onPressed: () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sumTitle(context, title: "Payment method"),
              const SizedBox(
                height: 20,
              ),
              Chip(
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                label: Text(
                  'Mpesa pay',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              sumTitle(context, title: "Account Information"),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Enter the account information of the phone number that will be making payment",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: customTextFieldInput(
                  textController: phoneController,
                  hint: "254 700 000 000",
                  icon: const Icon(Icons.account_box),
                  inputType: TextInputType.phone,
                  label: "Mpesa Number e.g 254 *",
                  onSubmit: (val) {},
                  onChanged: (val) {},
                  validator: (value) {
                    final pattern = RegExp(r'^254[0-9]+');
                    if (value.length < 12 ||
                        value.length > 12 ||
                        !pattern.hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              sumTitle(context, title: "Schedule pickup"),
              const SizedBox(
                height: 15,
              ),
              Text(
                "When do you plan to pick up your laundry?",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                autovalidateMode: AutovalidateMode.disabled,
                child: customDateFieldInput(
                  hint: "Expected pickup date",
                  icon: const Icon(Icons.date_range),
                  inputType: TextInputType.phone,
                  label: "laundry pick up?",
                  onSubmit: (val) {},
                  onChanged: (val) {},
                  validator: (val) {},
                  textController: dateInputController,
                  onTap: () {
                    _launchDatePicker(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.info_outlined),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Total: ksh ${context.watch<Order>().amount}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LimitedBox(
                    maxWidth: 170,
                    child: customSmallBtn(
                      ctx: context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Review",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: kTextLight,
                                    ),
                          ),
                          const Icon(
                            Icons.arrow_forward_sharp,
                            size: 20,
                          )
                        ],
                      ),
                      onPressed: () {
                        _proceed();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Text sumTitle(BuildContext context, {required String title}) {
  return Text(
    title,
    style: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
  );
}

class customDateFieldInput extends StatelessWidget {
  TextEditingController? textController;
  String hint;
  String label;
  TextInputType inputType;
  Icon icon;
  Function validator;
  Function onChanged;
  Function onSubmit;
  Function? onTap;
  int? minLines;
  int? maxLines;

  customDateFieldInput(
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
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      readOnly: true,
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val),
      onSaved: (val) => onSubmit(val),
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorHeight: 17,
      keyboardType: inputType,
      minLines: minLines,
      onTap: () => onTap!(),
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
