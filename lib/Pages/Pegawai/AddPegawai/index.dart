import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/API/Pegawai/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPegawai extends StatefulWidget {
  AddPegawai({Key? key}) : super(key: key);

  @override
  State<AddPegawai> createState() => _AddPegawaiState();
}

class _AddPegawaiState extends State<AddPegawai> {
  var connectionStatus = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerTempatlahir = TextEditingController();
  TextEditingController controllerTanggallahir = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordC = TextEditingController();
  List jabatan = [];
  List departemen = [];
  List unit = [];
  List pendidikan = [];
  List jk = [];
  var loading, loadingJabatan, loadingDepartemen, loadingUnitKerja, loadingPendidikan, loadingJK = false;
  int valJabatan = 0;
  int valDepartemen = 0;
  int valUnitKerja = 0;
  int valPendidikan = 0;
  int valJK = 0;
  var showPassword = true;
  var showPasswordC = true;
  void changePassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void changePasswordC() {
    setState(() {
      showPasswordC = !showPasswordC;
    });
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
  }

  void getjabatan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    setState(() {
      loadingJabatan = true;
    });
    try {
      var url = Uri.parse(API_PEGAWAI.getJabatan());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('Jabatan: $json');
      if (response.statusCode == 200) {
        setState(() {
          loadingJabatan = false;
          jabatan = json;
          print(jabatan);
        });
      } else if (response.statusCode == 503) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: json['error'],
          text: 'Silahkan Login Kembali !',
          onConfirmBtnTap: logout,
        );
        setState(() {
          loadingJabatan = false;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loadingJabatan = false;
        });
      }
    } catch (e) {
      print('Error jabatan: $e');
    }
  }

  void getdepartemen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    setState(() {
      loadingDepartemen = true;
    });
    try {
      var url = Uri.parse(API_PEGAWAI.getDepartemen());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('Depatement: $json');
      if (response.statusCode == 200) {
        setState(() {
          loadingDepartemen = false;
          departemen = json;
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loadingDepartemen = false;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loadingDepartemen = false;
        });
      }
    } catch (e) {
      print('Error Depatement: $e');
    }
  }

  void getunit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    setState(() {
      loadingUnitKerja = true;
    });
    try {
      var url = Uri.parse(API_PEGAWAI.getUnitkerja());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('Unit: $json');
      if (response.statusCode == 200) {
        setState(() {
          loadingUnitKerja = false;
          unit = json;
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loadingUnitKerja = false;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loadingUnitKerja = false;
        });
      }
    } catch (e) {
      print('Error Unit: $e');
    }
  }

  void getpendidikan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    setState(() {
      loadingPendidikan = true;
    });
    try {
      var url = Uri.parse(API_PEGAWAI.getPendidikan());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('Pendidikan: $json');
      if (response.statusCode == 200) {
        setState(() {
          loadingPendidikan = false;
          pendidikan = json;
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loadingPendidikan = false;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loadingPendidikan = false;
        });
      }
    } catch (e) {
      print('Error Pendidikan: $e');
    }
  }

  void getjk() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    setState(() {
      loadingJK = true;
    });
    try {
      var url = Uri.parse(API_PEGAWAI.getJeniskelamin());
      var response = await http.get(url, headers: {'Authorization': '$token'});
      var json = jsonDecode(response.body);
      print('Jenis kelamin: $json');
      if (response.statusCode == 200) {
        setState(() {
          loadingJK = false;
          jk = json;
        });
      } else if (response.statusCode == 503) {
        setState(() {
          loadingJK = false;
        });
      } else if (response.statusCode == 501) {
        setState(() {
          loadingJK = false;
        });
      }
    } catch (e) {
      print('Error Jenis kelamin: $e');
    }
  }

  void tanggalLahir() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1600, 1, 1),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print(date.toString().split(' ')[0]);
        print(date.year.toString() + date.month.toString() + date.day.toString());
      },
      onConfirm: (date) {
        print(date.toString().split(' ')[0]);
        controllerTanggallahir.text = date.year.toString() + date.month.toString() + date.day.toString();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  void tambahPegawai() async {
    var data = {
      "namaLengkap": controllerNama.text,
      "email": controllerEmail.text,
      "tempatLahir": controllerTempatlahir.text,
      "tanggalLahir": 19991111,
      "kdJenisKelamin": 1,
      "kdPendidikan": 1,
      "kdJabatan": 1,
      "kdDepartemen": 1,
      "password": controllerPassword.text,
      "passwordC": controllerPasswordC.text
    };
    setState(() {
      loading = true;
    });
    print(data);
    try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
      var url = Uri.parse(API_PEGAWAI.tambahPegawai());
      var response = await http.post(
        url,
        headers: {'Authorization': '$token'},
        body: data,
      );
      var json = jsonDecode(response.body);
      print('JSON TAMBAH PEGAWAI: $json');
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        CoolAlert.show(context: context, type: CoolAlertType.success, text: json.toString());
      } else if (response.statusCode == 503) {
        setState(() {
          loading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: json['error'],
          text: 'Silahkan Login Kembali',
          onConfirmBtnTap: logout,
        );
      }
    } catch (e) {
      print('Error tambah pegawai: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getjabatan();
    getdepartemen();
    getunit();
    getpendidikan();
    getjk();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff00ADB5)));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineIcons.angleLeft, size: 25, color: Colors.white),
        ),
        title: Text('Tambah Pegawai'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerNama,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Masukan Nama',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.user, size: 25),
                            ),
                            validator: (value) {
                              if (value?.isEmpty == null) {
                                return 'Kolom Nama harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Masukan Email',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.envelope, size: 25),
                            ),
                            validator: (value) {
                              if (value?.isEmpty == null) {
                                return 'Kolom Email harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: tanggalLahir,
                            child: TextFormField(
                              enabled: false,
                              controller: controllerTanggallahir,
                              decoration: InputDecoration(
                                hintText: 'Masukan Tanggal Lahir',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                                prefixIcon: Icon(FontAwesomeIcons.calendar, size: 25),
                              ),
                              validator: (value) {
                                if (value?.isEmpty == null) {
                                  return 'Kolom Tanggal lahir harus di isi';
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerPassword,
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              hintText: 'Masukan Password',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.lock, size: 25),
                              suffixIcon: InkWell(
                                  onTap: changePassword,
                                  child: showPassword == true ? Icon(FontAwesomeIcons.eyeSlash, size: 25) : Icon(FontAwesomeIcons.eye, size: 25)),
                            ),
                            validator: (value) {
                              if (value?.isEmpty == null) {
                                return 'Kolom Password harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerPasswordC,
                            obscureText: showPasswordC,
                            decoration: InputDecoration(
                              hintText: 'Masukan Password Konfirmasi',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.lock, size: 25),
                              suffixIcon: InkWell(
                                  onTap: changePasswordC,
                                  child: showPasswordC == true ? Icon(FontAwesomeIcons.eyeSlash, size: 25) : Icon(FontAwesomeIcons.eye, size: 25)),
                            ),
                            validator: (value) {
                              if (value?.isEmpty == null) {
                                return 'Kolom Password Konfirmasi harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valJabatan = int.parse(value.toString());
                              });
                            },
                            hint: Text('Pilih Jabatan'),
                            isExpanded: true,
                            items: jabatan.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['namaJabatan'].toString()),
                                value: item['kdJabatan'],
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Kolom Jabatan harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valDepartemen = int.parse(value.toString());
                              });
                            },
                            hint: Text('Pilih Departement'),
                            isExpanded: true,
                            items: departemen.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['namaDepartemen'].toString()),
                                value: item['kdDepartemen'],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valUnitKerja = int.parse(value.toString());
                              });
                            },
                            hint: Text('Pilih Unit Kerja'),
                            isExpanded: true,
                            items: unit.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['namaUnitKerja'].toString()),
                                value: item['kdUnitKerja'],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valPendidikan = int.parse(value.toString());
                              });
                            },
                            hint: Text('Pilih Pendidikan'),
                            isExpanded: true,
                            items: pendidikan.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['namaPendidikan'].toString()),
                                value: item['kdPendidikan'],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valJK = int.parse(value.toString());
                              });
                            },
                            hint: Text('Pilih Jenis Kelamin'),
                            isExpanded: true,
                            items: jk.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['namaJenisKelamin'].toString()),
                                value: item['kdJenisKelamin'],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1,
              height: 50.0,
              child: ElevatedButton(
                  onPressed: () {
                    tambahPegawai();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'SIMPAN',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
