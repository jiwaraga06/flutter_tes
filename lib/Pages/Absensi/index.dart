import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:frontendtes/API/Absen/index.dart';
import 'package:frontendtes/Pages/Absensi/AdminAbsensi/index.dart';
import 'package:frontendtes/Pages/Absensi/PegawaiAbsensi/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Absensi extends StatefulWidget {
  Absensi({Key? key}) : super(key: key);

  @override
  State<Absensi> createState() => _AbsensiState();
}

class _AbsensiState extends State<Absensi> with SingleTickerProviderStateMixin {
  TabController? controller;
  var statusAbsen = [];
  TextEditingController controllerTgl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var tgl;
  var valueStatus;
  var loading = false;
  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('idUser');
    pref.remove('nama');
    pref.remove('email');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }

  void tanggal() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1600, 1, 1),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print(date.toString().split(' ')[0]);
      },
      onConfirm: (date) {
        print(date.toString().split(' ')[0]);
        var bulan, day;
        if (date.month.toString().length == 1) {
          bulan = '0${date.month.toString()}';
        } else {
          bulan = date.month.toString();
        }
        if (date.day.toString().length == 1) {
          day = '0${date.day.toString()}';
        } else {
          day = date.day.toString();
        }
        tgl = date.year.toString() + bulan + day;
        controllerTgl.text = date.toString().split(' ')[0];
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  void getStatus() async {
    setState(() {
      loading = true;
      statusAbsen.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_ABSENSI.statusAbsen());
      var response =
          await http.get(url, headers: {'Authorization': token.toString()});
      var json = jsonDecode(response.body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          statusAbsen = json;
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loading = false;
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
            text: 'Silahlan Login kembali',
            onConfirmBtnTap: logout,
          );
        });
      
      } else if (response.statusCode == 501) {
        setState(() {
          loading = false;
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
          );
        });
      }
    } catch (e) {
      print('Error get status: $e');
    }
  }

  void postAbsensi() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      setState(() {
        loading = true;
      });
      print(tgl.toString());
      try {
        var url = Uri.parse(API_ABSENSI.absen());
        var response = await http.post(url, headers: {
          'Authorization': token.toString()
        }, body: {
          "tglAbsensi": tgl.toString(),
          "kdStatus": valueStatus.toString(),
        });
        var json = jsonDecode(response.body);
        print('JSON PERSETUJUAN :$json');
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: json['succes'].toString(),
          );
        } else if (response.statusCode == 503) {
          setState(() {
            loading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
            text: 'Silahlan Login kembali',
            onConfirmBtnTap: logout,
          );
        } else if (response.statusCode == 501) {
          setState(() {
            loading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
          );
        }
      } catch (e) {
        print('Error Persetujuan: $e');
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showPick() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Absen',
      title: 'Absensi',
      onConfirmBtnTap: postAbsensi,
      widget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTap: tanggal,
                  readOnly: true,
                  controller: controllerTgl,
                  decoration: InputDecoration(
                      hintText: 'Tanggal',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom ini wajib di isi';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0))),
                  onChanged: (value) {
                    setState(() {
                      valueStatus = value;
                    });
                  },
                  hint: Text('Pilih Status'),
                  isExpanded: true,
                  items: statusAbsen.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['namaStatus'].toString()),
                      value: item['kdStatus'],
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Kolom ini wajib di isi' : null,
                ),
              ),
              loading == true
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        child: CupertinoActivityIndicator()),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(vsync: this, length: 2);
    getStatus();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child:
            FloatingActionButton(onPressed: showPick, child: Icon(Icons.add)),
      ),
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
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0), color: Colors.teal),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(child: Text('ADMIN')),
                Tab(child: Text('PEGAWAI')),
              ],
            ),
          ),
          Expanded(
              // flex: 1,
              child: TabBarView(controller: controller, children: [
            AdminAbsensi(),
            PegawaiAbsensi(),
          ]))
        ],
      ),
    );
  }
}
