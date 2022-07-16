// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/form_components.dart';
import '../../../providers/orders.providers.dart';
import '../../../themes/main.dart';
import 'payout_congrats.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final phoneController = TextEditingController();
  final datepickController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(context.read<Order>().phone);
    setState(() {
      datepickController.text =
          Moment(context.read<Order>().expectedDate).calendar();
      phoneController.text = context.read<Order>().phone;
    });
  }

  showBottomSheet() {
    final total = context.read<Order>().getAmount;
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Dear customer a total of ksh $total will be billed to ${phoneController.text},Please wait for the M-pesa prompt to appear",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                height: 25,
              ),
              customExtendButton(
                ctx: context,
                child: Text(
                  "Pay",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: kTextLight,
                      ),
                ),
                onPressed: () {
                  _proceed();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _proceed() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => const ProcessingOrder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: "Review and Checkout"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sumTitle(context, title: "Address of Drop off"),
              const SizedBox(
                height: 20,
              ),
              const AddressSummary(),
              const SizedBox(
                height: 20,
              ),
              sumTitle(context, title: "Expected pickup date"),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: Form(
                      child: customTextFieldInput(
                        textController: datepickController,
                        hint: "Expected pick up",
                        icon: const Icon(Icons.calendar_today),
                        inputType: TextInputType.datetime,
                        label: "When are you picking",
                        onChanged: (val) {},
                        onSubmit: (val) {},
                        validator: (val) {},
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.verified,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              sumTitle(context, title: "Summary"),
              const SizedBox(
                height: 20,
              ),
              const ProductsSummary(),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  sumTitle(context, title: "Payment"),
                  const SizedBox(
                    width: 20,
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
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: customTextFieldInput(
                        textController: phoneController,
                        hint: "254 ",
                        label: "Phone Number",
                        inputType: TextInputType.phone,
                        icon: const Icon(Icons.phone),
                        validator: (val) {},
                        onChanged: (val) {},
                        onSubmit: (val) {}),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.verified,
                    color: Theme.of(context).primaryColor,
                  )
                ],
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
                  const Icon(Icons.warning),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Total: ksh ${context.watch<Order>().amount}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
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
                            "Confirm",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: kTextLight,
                                    ),
                          ),
                          const Icon(
                            Icons.check,
                            size: 20,
                          )
                        ],
                      ),
                      onPressed: () {
                        showBottomSheet();
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
        ),
  );
}

Padding SummaryRow(count, BuildContext context, title, total) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 5,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: count.toString(),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.7),
                    fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: " x ",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              TextSpan(
                text: title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.7),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Text(
          "\$ ${total.toString()}",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    ),
  );
}

class ProductsSummary extends StatefulWidget {
  const ProductsSummary({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsSummary> createState() => _ProductsSummaryState();
}

class _ProductsSummaryState extends State<ProductsSummary> {
  List clothesArr = [];
  Map address = {};
  @override
  void initState() {
    super.initState();
    setState(() {
      clothesArr = context.read<Order>().clothesArray;
      address = context.read<Order>().stationAdress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.5,
          color: Color(0xFFC7C7C7),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          ...List.generate(
            clothesArr.length,
            (index) {
              final count = clothesArr[index]['count'];
              final total = (clothesArr[index]['price'] * count);
              final title = clothesArr[index]['id'];
              return SummaryRow(count, context, title, total);
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            height: 0.6,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 199, 199, 199),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                context.read<Order>().getAmount.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Text statusUpdate({required BuildContext context, required String status}) {
  return Text(status,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ));
}

class AddressSummary extends StatefulWidget {
  const AddressSummary({
    Key? key,
  }) : super(key: key);

  @override
  State<AddressSummary> createState() => _AddressSummaryState();
}

class _AddressSummaryState extends State<AddressSummary> {
  Map address = {};
  @override
  void initState() {
    super.initState();
    setState(() {
      address = context.read<Order>().stationAdress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            address['name'],
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: kTextLight,
                ),
          ),
          const Icon(
            Icons.check_circle_outlined,
            color: kTextLight,
          )
        ],
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
            .copyWith(color: kTextMediumColor.withOpacity(.8)),
        floatingLabelStyle: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: kTextMediumColor.withOpacity(.8)),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
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

class checkOutItem extends StatelessWidget {
  String title;
  String value;
  Function onPressed;
  String btnLabel;

  checkOutItem({
    required this.title,
    required this.value,
    required this.btnLabel,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  btnLabel,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
