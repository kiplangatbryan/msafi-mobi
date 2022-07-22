import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/launderMarts/profile/main.dart';
import 'package:msafi_mobi/pages/regular/processing/settings.dart';
import 'package:msafi_mobi/providers/store.providers.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../helpers/http_services.dart';
import '../../../helpers/size_calculator.dart';
import '../../../providers/user.provider.dart';
import 'notifications.dart';
import 'single_merchant_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // late Notificator notification;

  String notificationKey = 'key';
  String _bodyText = 'notification test';

  @override
  void initState() {
    super.initState();
    // notification = Notificator(
    //   onPermissionDecline: () {
    //     // ignore: avoid_print
    //     print('permission decline');
    //   },
    //   onNotificationTapCallback: (notificationData) {
    //     setState(
    //       () {
    //         _bodyText = 'notification open: '
    //             '${notificationData[notificationKey].toString()}';
    //       },
    //     );
    //   },
    // )..requestPermissions(
    //     requestSoundPermission: true,
    //     requestAlertPermission: true,
    //   );
  }

  // displayNotification() {
  //   notification.show(
  //     1,
  //     'hello',
  //     'this is test',
  //     imageUrl: 'https://www.lumico.io/wp-019/09/flutter.jpg',
  //     data: {notificationKey: '[notification data]'},
  //     notificationSpecifics: NotificationSpecifics(
  //       AndroidNotificationSpecifics(
  //         autoCancelable: true,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hi, ${context.read<User>().name}",
                              style: GoogleFonts.notoSans(
                                  fontSize: sizeCompute(
                                      small: 21, large: 24, width: maxWidth),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    const UserNotifications()));
                                      },
                                      icon: const Icon(
                                        Icons.notifications_active_outlined,
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        child: Container(
                                          width: 23,
                                          height: 23,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                const UserSettings()));
                                  },
                                  icon: const Icon(
                                    Icons.person_pin,
                                    size: 30,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          "Find launderMarts Around",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customTextField(
                            hint: "search",
                            label: "search",
                            inputType: TextInputType.text,
                            icon: const Icon(Icons.search_outlined),
                            validator: (val) {},
                            onChanged: (val) {},
                            onSubmit: (val) {}),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const LanderMartsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanderMartsList extends StatefulWidget {
  const LanderMartsList({
    Key? key,
  }) : super(key: key);

  @override
  State<LanderMartsList> createState() => _LanderMartsListState();
}

class _LanderMartsListState extends State<LanderMartsList> {
  bool loading = false;
  String snackBarMessage = "";
  bool showSnack = false;
  bool errorState = false;
  List storesArr = [];

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    setState(() {
      loading = true;
    });

    try {
      // send data to server
      Response response = await httHelper().get('/store/fetchStores');

      if (response.statusCode == 200) {
        List data = response.data;
        context.read<Store>().saveStores(data);
        setState(() {
          loading = false;
          storesArr = data;
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
    return !errorState
        ? loading
            ? SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : storesArr.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/coffie-sleeping.json',
                        repeat: false,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Sorry no stores Available. They will be available soon",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 250,
                      crossAxisCount: 2,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    // crossAxisCount is the number of columns
                    itemCount: storesArr.length,
                    // This creates two columns with two items in each column
                    itemBuilder: (BuildContext context, index) {
                      final store = storesArr[index];
                      return Hero(
                        tag: store['id'],
                        child: StoreItem(
                          index: index,
                          title: store['name'],
                        ),
                      );
                    })
        : errorHandler(context);
  }

  Container errorHandler(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "Their was a problem with Your connection.",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                errorState = false;
              });
              await fetchStores();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 10,
            )),
            child: Text(
              "Try again",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: kTextLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class StoreItem extends StatelessWidget {
  int index;
  String title;
  EdgeInsets margin;
  StoreItem({
    required this.title,
    this.margin = const EdgeInsets.only(
      right: 20,
    ),
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeItem = context.read<Store>().stores[index];
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) =>
                      LaunderMartView(tagId: storeItem['id'], index: index),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  height: 160,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${baseUrl()}/${storeItem["storeImg"][0]}'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 13,
                    left: 5,
                    right: 5,
                  ),
                  child: Text(
                    storeItem['name'],
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
