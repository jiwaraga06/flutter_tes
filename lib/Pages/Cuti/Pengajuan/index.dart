import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:frontendtes/API/Cuti/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Pengajuan extends StatefulWidget {
  Pengajuan({Key? key}) : super(key: key);

  @override
  State<Pengajuan> createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  var formKey = GlobalKey<FormState>();
  var loading = false;
  var cuti = [];
  TextEditingController controllerTglAwal = TextEditingController();
  TextEditingController controllerTglAkhir = TextEditingController();
  TextEditingController controllerTglPengajuan = TextEditingController();
  
  var tgl_awal, tgl_akhir, tgl_pengajuan;
  
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

  void tanggalPengajuan() {
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
        // var bulan = date.month.toString().length.toString() == 1 ? '0${date.month.toString()}' : date.month.toString();
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
        tgl_pengajuan = date.year.toString() + bulan + day;
        print(bulan);
        controllerTglPengajuan.text = date.toString().split(' ')[0];
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  void getCuti() async {
    setState(() {
      loading = true;
      cuti.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_CUTI.getDataPengajuan(tgl_awal, tgl_akhir));
      var response = await http.get(url, headers: {'Authorization': token.toString()});
      var json = jsonDecode(response.body);
      print(json);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          cuti = json;
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
      }
    } catch (e) {
      print('Error cuti: $e');
    }
  }

  void postPengajuan() async {
    if (formKey.currentState!.validate()) {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var token = pref.getString('token');
        var idUser = pref.getString('idUser');
        var url = Uri.parse(API_CUTI.mengajukanCuti());
        var response = await http.post(url, headers: {
          'Authorization': token.toString()
        }, body: {
          'tglCuti': tgl_pengajuan,
          'idUserSetuju': idUser,
        });
        var json = jsonDecode(response.body);
        print('JSON PENGAJUAN: $json');
        if (response.statusCode == 200) {
          controllerTglPengajuan.clear();
          CoolAlert.show(context: context, type: CoolAlertType.success, text: json['succes']);
        } else if (response.statusCode == 503) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
            text: 'Silahlan Login kembali',
            onConfirmBtnTap: logout,
          );
        } else if (response.statusCode == 501) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: json['error'].toString(),
          );
        }
      } catch (e) {
        print('Error Pengajuan: $e');
      }
    }
  }

  void showPick() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.custom,
        barrierDismissible: true,
        confirmBtnText: 'Cari',
        title: 'Pilih Tanggal Awal & Akhir',
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
        onConfirmBtnTap: getCuti);
  }

  void buatPengajuan() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Simpan',
      title: 'Pilih Tanggal Pengajuan',
      onConfirmBtnTap: postPengajuan,
      widget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  onTap: tanggalPengajuan,
                  readOnly: true,
                  controller: controllerTglPengajuan,
                  decoration: InputDecoration(hintText: 'Pilih tanggan Pengajuan', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kolom Tanggal pengajuan harus di isi';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCuti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loading == true
            ? ListView.builder(
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
                })
            : cuti.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Data Kosong'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: cuti.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = cuti[index];
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: data['namaSetuju'].toString() == 'null'
                                  ? Colors.blue[600]
                                  : data['namaSetuju'] == 'Tidak Setuju'
                                      ? Colors.red[700]
                                      : Colors.green[800],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(data['tglCuti'].toString(), style: GoogleFonts.poppins(fontSize: 23, color: Colors.white)),
                              Divider(color: Colors.white, thickness: 3.0),
                              Text(data['namaSetuju'].toString() == 'null' ? 'Belum ada keterangan' : data['namaSetuju'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45.0,
                  child: ElevatedButton(
                    onPressed: buatPengajuan,
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    child: Text('TAMBAH PENGAJUAN CUTI', style: TextStyle(fontSize: 17)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
