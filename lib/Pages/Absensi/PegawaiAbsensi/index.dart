import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:frontendtes/API/Absen/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class PegawaiAbsensi extends StatefulWidget {
  PegawaiAbsensi({Key? key}) : super(key: key);

  @override
  State<PegawaiAbsensi> createState() => _PegawaiAbsensiState();
}

class _PegawaiAbsensiState extends State<PegawaiAbsensi> {
  var pegawai = [];
  TextEditingController controllerTglAwal = TextEditingController();
  TextEditingController controllerTglAkhir = TextEditingController();
   var tgl_awal, tgl_akhir;
   var loading = false;
   void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('idUser');
    pref.remove('nama');
    pref.remove('email');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
  }

 void tanggalAwal() {
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
        tgl_awal = date.year.toString() + bulan + day;
        controllerTglAwal.text = date.toString().split(' ')[0];
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  void tanggalAkhir() {
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
        tgl_akhir = date.year.toString() + bulan + day;
        controllerTglAkhir.text = date.toString().split(' ')[0];
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

void showPick() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.custom,
        barrierDismissible: true,
        confirmBtnText: 'Cari',
        title: 'Pilih Tanggal Awal & Akhir',
        onConfirmBtnTap: getAbsenPegawai,
        widget: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTap: tanggalAwal,
                  readOnly: true,
                  controller: controllerTglAwal,
                  decoration: InputDecoration(hintText: 'Tanggal Awal', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTap: tanggalAkhir,
                  readOnly: true,
                  controller: controllerTglAkhir,
                  decoration: InputDecoration(hintText: 'Tanggal Akhir', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                ),
              ),
            ],
          ),
        ),
        );
  }

void getAbsenPegawai() async {
    setState(() {
      loading = true;
      pegawai.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_ABSENSI.dataPegawai(tgl_awal,tgl_akhir));
      var response =
          await http.get(url, headers: {'Authorization': token.toString()});
      var json = jsonDecode(response.body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          pegawai = json;
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
            text: json['error'].toString(),
          );
        });
      }
    } catch (e) {
      print('Error cuti: $e');
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          loading == true
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Color(0xFFEEEEEE),
                          highlightColor: Colors.white,
                          enabled: true,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.grey,
                            width: 150,
                            height: 50,
                          ),
                        );
                      }),
                )
              : pegawai.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text('Data Kosong'),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pegawai.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = pegawai[index];
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 3,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Text('ID User',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['idUser'].toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Nama Lengkap',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['namaLengkap'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Tanggal Absensi',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['tglAbsensi'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Jam Masuk',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['jamMasuk'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Jam Keluar',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['jamKeluar'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text('Status',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      const Text(' : ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                      Text(data['namaStatus'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            );
                          }),
                    ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 45.0,
                    child: ElevatedButton(
                      onPressed: showPick,
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      child: Text('CARI', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
