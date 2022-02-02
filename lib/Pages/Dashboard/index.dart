import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:frontendtes/Pages/Pegawai/DataPegawai/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    controller = TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xff00ADB5)));
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        bottom: TabBar(
          controller: controller, 
          indicatorColor: Colors.white,
          tabs: [
          Tab(
            text: 'Pegawai',
            icon: Icon(FontAwesomeIcons.userTie),
          )
        ]),
      ),
      body: TabBarView(controller: controller, children: [DataPegawai()]),
    );
  }
}
