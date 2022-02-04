import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/API/Auth/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InitDatas extends StatefulWidget {
  InitDatas({Key? key}) : super(key: key);

  @override
  State<InitDatas> createState() => _InitDatasState();
}

class _InitDatasState extends State<InitDatas> {
  var loading = false;
  TextEditingController controllerAdmin = TextEditingController();
  TextEditingController controllerPerusahaan = TextEditingController();

  void register() async {
    setState(() {
      loading = true;
    });
    try {
      var url = Uri.parse(API_AUTH.initData());
      var response = await http.post(url, body: {
        'namaAdmin': controllerAdmin.text,
        'perusahaan': controllerPerusahaan.text,
      });
      var json = jsonDecode(response.body);
      print('JSON Init data: $json');
      if (response.statusCode == 200) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('profile', json['profile']);
        setState(() {
          loading = false;
        });
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: 'Berhasil Menambahkan Account, Silahkan Login\nEmail: ${json['email']}\nPassword: ${json['password']}\nProfile: ${json['profile']}',
            confirmBtnText: 'Yes',
            onConfirmBtnTap: () {
              Navigator.pop(context);
            });
      } else if (response.statusCode == 501) {
        setState(() {
          loading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: json['error'].toString(),
          confirmBtnText: 'Yes',
          confirmBtnColor: Colors.green,
        );
      }
    } catch (e) {
      print('Error init data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xff00ADB5)));
    return Scaffold(
      backgroundColor: Color(0xff00ADB5),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Registrasi',
                    style:
                        GoogleFonts.poppins(fontSize: 35, color: Colors.white)),
                Text('Account',
                    style: GoogleFonts.poppins(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    controller: controllerAdmin,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Masukan Nama Admin",
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff00ADB5), width: 1.5),
                          borderRadius: BorderRadius.circular(50)),
                      prefixIcon: Icon(FontAwesomeIcons.envelope, size: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    controller: controllerPerusahaan,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Masukan Nama Perusahaan",
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff00ADB5), width: 1.5),
                          borderRadius: BorderRadius.circular(50)),
                      prefixIcon: Icon(FontAwesomeIcons.user, size: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: loading == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CupertinoActivityIndicator(),
                      Text('Loading', style: TextStyle(color: Colors.white))
                    ],
                  )
                : SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color(0xff00ADB5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Text('Registrasi',
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff00ADB5))),
                    ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red[800],
                    onPrimary: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: Text('KEMBALI',
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
