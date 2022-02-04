import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:frontendtes/API/Cuti/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:frontendtes/Pages/Cuti/Pengajuan/index.dart';
import 'package:frontendtes/Pages/Cuti/Persetujuan/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cuti extends StatefulWidget {
  Cuti({Key? key}) : super(key: key);

  @override
  State<Cuti> createState() => _CutiState();
}

class _CutiState extends State<Cuti> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 45,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: TabBar(
              controller: controller,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: Colors.teal),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs:const [
                Tab(child: Text('PENGAJUAN')),
                Tab(child: Text('PERSETUJUAN')),
              ],
            ),
          ),
          Expanded(
              // flex: 1,
              child: TabBarView(controller: controller, children: [
            Pengajuan(),
            Persetujuan(),
          ]))
        ],
      ),
    );
  }
}
