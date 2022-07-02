import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/single-order.dart';
import 'package:msafi_mobi/themes/main.dart';

class MerchantHomePage extends StatefulWidget {
  const MerchantHomePage({Key? key}) : super(key: key);

  @override
  State<MerchantHomePage> createState() => _MerchantHomePageState();
}

class _MerchantHomePageState extends State<MerchantHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant'),
      ),
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: fetchOrders().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SingleOrder(order: fetchOrders()[index])));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: kBackgroundColor,
                        border: Border.all(
                          color: kTextColor.withOpacity(.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "# ${fetchOrders()[index]['id']}",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: kTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "Placed on:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: kTextMediumColor.withOpacity(.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                        fetchOrders()[index]['drop_off_time'])
                                    .toMoment()
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: kTextMediumColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  "Placed at:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: kTextMediumColor.withOpacity(.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                fetchOrders()[index]['pick_up_station'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: kTextMediumColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        enableFeedback: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          color: kTextColor,
        ),
        items: const [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(
              Icons.dashboard_outlined,
              color: kTextMediumColor,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Charts',
            icon: Icon(
              Icons.bar_chart,
              color: kTextMediumColor,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(
              Icons.notifications_active,
              color: kTextMediumColor,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person_outline_outlined,
              color: kTextMediumColor,
              size: 32,
            ),
          ),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (index) {},
      ),
    );
  }
}
