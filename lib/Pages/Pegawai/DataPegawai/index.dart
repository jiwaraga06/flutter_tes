import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/API/Pegawai/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:frontendtes/Pages/Pegawai/AddPegawai/index.dart';
import 'package:frontendtes/Pages/Pegawai/EditPegawai/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DataPegawai extends StatefulWidget {
  DataPegawai({Key? key}) : super(key: key);

  @override
  State<DataPegawai> createState() => _DataPegawaiState();
}

class _DataPegawaiState extends State<DataPegawai> {
  var connectionStatus = true;
  var loading = false;
  var daftar = [];
  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }

  void getDaftar() async {
    setState(() {
      loading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_PEGAWAI.getDaftar());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('JSON daftar: $json');
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          daftar = json;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loading = false;
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: json['error'].toString());
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loading = false;
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: json['error'].toString(),
              text: 'Silahlan Login kembali',
              onConfirmBtnTap: logout);
        });
      }
    } catch (e) {
      print('Error daftar : $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDaftar();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xff00ADB5)));
    return Scaffold(
      body: loading == true
          ? ListView.builder(
              // shrinkWrap: true,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Color(0xFFEEEEEE),
                  highlightColor: Colors.white,
                  enabled: true,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(8.0),
                              color: Colors.grey,
                              width: 150,
                              height: 10),
                          Container(
                              margin: const EdgeInsets.all(8.0),
                              color: Colors.grey,
                              width: 250,
                              height: 10),
                        ],
                      )
                    ],
                  ),
                );
              })
          : daftar.isEmpty
              ? const Center(
                  child: Text('Data Kosong'),
                )
              : ListView.builder(
                  itemCount: daftar.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = daftar[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: FaIcon(
                                  FontAwesomeIcons.userTie,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data['namaLengkap'],
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500)),
                                      Text(data['email'],
                                          style: GoogleFonts.poppins()),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPegawai(
                                                idUser: data['idUser'] ?? '',
                                                nama: data['namaLengkap'] ?? '',
                                                email: data['email'] ?? '',
                                                tempatLahir:
                                                    data['tempatLahir'] ?? '',
                                                tanggalLahir:
                                                    data['tanggalLahir'].toString() ?? '',
                                                password:
                                                    data['password'] ?? '',
                                                passwordC:
                                                    data['passwordC'] ?? '',
                                                departemen:
                                                    data['kdDepartemen'] ?? 0,
                                                jabatan: data['kdJabatan'] ?? 0,
                                                unit: data['kdUnitKerja'] ?? 0,
                                                jk: data['kdJenisKelamin'] ?? 0,
                                                pendidikan:
                                                    data['kdPendidikan'] ?? 0,
                                              )));
                                },
                                icon: Icon(LineIcons.angleRight),
                              )
                            ],
                          ),
                          Divider(thickness: 2, color: Colors.grey[200]),
                        ],
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPegawai()));
        },
        backgroundColor: const Color(0xff00ADB5),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
