import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:provider/provider.dart';

import '../../../components/snackback_component.dart';
import '../../../helpers/http_services.dart';

class UserNotifications extends StatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  bool loading = false;
  List notifications = [];

  @override
  void initState() {
    super.initState();
    _getnotifications();
  }

  Future<void> _getnotifications() async {
    setState(() {
      loading = true;
    });

    try {
      // send data to server
      final token = await checkAndValidateAuthToken(context);
      Response response = await httHelper().get('/store/fetch-notifications',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        List data = response.data;
        // context.read<Store>().saveStores(data);
        setState(() {
          loading = false;
          notifications = data;
        });
      } else {
        customSnackBar(
            context: context, message: 'Something happened', onPressed: () {});
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectTimeout) {
        customSnackBar(
            context: context,
            message: 'Connection Timed out',
            onPressed: () {});
      }

      if (ex.type == DioErrorType.sendTimeout) {
        customSnackBar(
            context: context, message: 'Something happened', onPressed: () {});
      } else {
        final msg = ex.response?.data['message'];
        customSnackBar(
            context: context, message: 'Something happened', onPressed: () {});
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: "Notifications"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: notifications.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/sent-email-animation.json',
                      repeat: false,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "You don't have any new notifications",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    notifications.length,
                    (index) {
                      final note = notifications[index];
                      return NotificationCard(
                        title: note['title'],
                        timestamp: note['createdAt'],
                        body: note['body'],
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String body;
  final String title;
  final String timestamp;
  const NotificationCard({
    required this.title,
    required this.body,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            Moment(DateTime.parse(timestamp)).calendar(),
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(body,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "Mark as read",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
