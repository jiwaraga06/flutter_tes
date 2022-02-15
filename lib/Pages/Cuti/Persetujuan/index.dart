import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
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

class Persetujuan extends StatefulWidget {
  Persetujuan({Key? key}) : super(key: key);

  @override
  State<Persetujuan> createState() => _PersetujuanState();
}

class _PersetujuanState extends State<Persetujuan> {
  var formKey = GlobalKey<FormState>();
  var loading = false;
  var loadingPost = false;
  var cuti = [];
  TextEditingController controllerTglAwal = TextEditingController();
  TextEditingController controllerTglAkhir = TextEditingController();
  TextEditingController controlleridUserCuti = TextEditingController();
  var statusPersetujuan = [];
  var tgl_awal, tgl_akhir;
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

  void getPersetujuan() async {
    setState(() {
      loading = true;
      cuti.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_CUTI.getDataPersetujuan(tgl_awal, tgl_akhir));
      var response =
          await http.get(url, headers: {'Authorization': token.toString()});
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
      }else if (response.statusCode == 501) {
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
                  decoration: InputDecoration(
                      hintText: 'Tanggal Awal',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTap: tanggalAkhir,
                  readOnly: true,
                  controller: controllerTglAkhir,
                  decoration: InputDecoration(
                      hintText: 'Tanggal Akhir',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0))),
                ),
              ),
            ],
          ),
        ),
        onConfirmBtnTap: getPersetujuan);
  }

  var valPersetujuan;
  void getStatusPersetujuan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_CUTI.statusPersetujuan());
      var response =
          await http.get(url, headers: {'Authorization': token.toString()});
      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          statusPersetujuan = json;
        });
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
      print('Error status persetujuan: $e');
    }
  }

  void postPersetuan(tglCuti, idUserCuti) async {
    setState(() {
      loadingPost = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try {
      var url = Uri.parse(API_CUTI.menyetujuiCuti());
      var response = await http.post(url, headers: {
        'Authorization': token.toString()
      }, body: {
        'kdSetuju': valPersetujuan.toString(),
        'tglCuti': tglCuti.toString(),
        'idUserCuti': idUserCuti.toString(),
      });
      var json = jsonDecode(response.body);
      print('JSON PERSETUJUAN :$json');
      if (response.statusCode == 200) {
        getPersetujuan();
        setState(() {
          loadingPost = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: json['succes'].toString(),
        );
      } else if (response.statusCode == 503) {
        setState(() {
          loadingPost = false;
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
          loadingPost = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: json['error'].toString(),
        );
      }
    } catch (e) {
      print('Error Persetujuan: $e');
    }
  }

  void showModalPersetujuan(tglCuti, idUserCuti) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Simpan',
      title: 'Pegawai Cuti',
      onConfirmBtnTap: () {
        if (formKey.currentState!.validate()) {
          postPersetuan(tglCuti, idUserCuti);
        }
      },
      widget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0))),
                  onChanged: (value) {
                    setState(() {
                      valPersetujuan = value;
                    });
                  },
                  hint: Text('Pilih Status'),
                  isExpanded: true,
                  items: statusPersetujuan.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['namaSetuju'].toString()),
                      value: item['kdSetuju'],
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Kolom ini wajib di isi' : null,
                ),
              ),
            ),
            loadingPost == true
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 20, child: CupertinoActivityIndicator()),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusPersetujuan();
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
            : cuti.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('Data Kosong'),
                  )
                : Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cuti.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = cuti[index];
                          return InkWell(
                            onTap: () {
                              showModalPersetujuan(
                                  data['tglCuti'].toString(), data['idUser']);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data['namaLengkap'].toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    color: Colors.black)),
                                            Row(
                                              children: [
                                                const Text('Tanggal Cuti',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                                const Text(' : ',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                                Text(data['tglCuti'].toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Text('Status',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                                const Text(' : ',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      color: data['namaSetuju'] ==
                                                              null
                                                          ? Colors.blue[600]
                                                          : data['namaSetuju'] ==
                                                                  'Tidak Setuju'
                                                              ? Colors.red[700]
                                                              : Colors
                                                                  .green[800]),
                                                  child: Text(
                                                      data['namaSetuju'] == null
                                                          ? 'Menunggu'
                                                          : data['namaSetuju']
                                                              .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 3,
                                    color: Colors.grey[200],
                                  )
                                ],
                              ),
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
    ));
  }
}
