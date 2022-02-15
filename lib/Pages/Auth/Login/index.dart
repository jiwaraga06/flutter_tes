import 'dart:convert';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/API/Auth/index.dart';
import 'package:frontendtes/Pages/Auth/InitData/index.dart';
import 'package:frontendtes/Pages/Dashboard/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var loading = false;
  var result = {};
  var showPassword = true;
  void changePassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  void loginPost() async {
    setState(() {
      loading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var profil = pref.getString('profile');
    try {
      var url = Uri.parse(API_AUTH.login());
      var response = await http.post(url, body: {
        'email': controllerEmail.text,
        'password': controllerPassword.text,
        'profile': '$profil',
      });
      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', json['hasil']['token']);
        preferences.setString('nama', json['hasil']['info']['namaLengkap']);
        preferences.setString('email', json['hasil']['info']['email']);
        preferences.setString('idUser', json['hasil']['info']['idUser']);
        var token = preferences.getString('token');
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
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
      print('JSON LOGIN: $json');
    } catch (e) {
      print('Error login: $e');
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
                Text('frontend',
                    style:
                        GoogleFonts.poppins(fontSize: 35, color: Colors.white)),
                Text('Tes',
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
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Masukan Email",
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
                    controller: controllerPassword,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Masukan Password",
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00ADB5), width: 1.5),
                            borderRadius: BorderRadius.circular(50)),
                        prefixIcon: Icon(FontAwesomeIcons.lock, size: 25),
                        suffixIcon: InkWell(
                          onTap: changePassword,
                          child: showPassword == true
                              ? Icon(FontAwesomeIcons.eyeSlash, size: 25)
                              : Icon(FontAwesomeIcons.eye, size: 25),
                        )),
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
                      onPressed: loginPost,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color(0xff00ADB5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Text('LOGIN',
                          style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff00ADB5))),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InitDatas()));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
              ),
              child: Text('Belum punya Account ? Daftar disini',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
