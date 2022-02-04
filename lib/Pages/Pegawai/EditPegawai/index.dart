import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
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

class EditPegawai extends StatefulWidget {
  String idUser, nama, email, tempatLahir, tanggalLahir, password, passwordC;
  int jabatan, departemen, unit, pendidikan, jk;
  EditPegawai({
    Key? key,
    required this.nama,
    required this.idUser,
    required this.email,
    required this.password,
    required this.passwordC,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.jabatan,
    required this.departemen,
    required this.unit,
    required this.pendidikan,
    required this.jk,
  }) : super(key: key);

  @override
  State<EditPegawai> createState() => _EditPegawaiState();
}

class _EditPegawaiState extends State<EditPegawai> {
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
  var loading,
      loadingJabatan,
      loadingDepartemen,
      loadingUnitKerja,
      loadingPendidikan,
      loadingJK = false;
  var valJabatan, valDepartemen, valUnitKerja, valPendidikan, valJK;
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

  void valueUpdate() {
    if (widget.nama != '') {
      controllerNama.text = widget.nama;
    }
    if (widget.email != '') {
      controllerEmail.text = widget.email;
    }
    if (widget.password != '') {
      controllerPassword.text = widget.password;
    }
    if (widget.password != '') {
      controllerPasswordC.text = widget.password;
    }
    if (widget.tempatLahir != '') {
      controllerTempatlahir.text = widget.tempatLahir;
    }
    if (widget.tanggalLahir != '') {
      controllerTanggallahir.text = widget.tanggalLahir;
      tgl_lahir = widget.tanggalLahir;
    }
    if (widget.jabatan != 0) {
      valJabatan = widget.jabatan;
    }
    if (widget.departemen != 0) {
      valDepartemen = widget.departemen;
    }
    if (widget.pendidikan != 0) {
      valPendidikan = widget.pendidikan;
    }
    if (widget.jk != 0) {
      valJK = widget.jk;
    }
    if (widget.unit != 0) {
      valUnitKerja = widget.unit;
    }
  }

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

var tgl_lahir;
  void tanggalLahir() {
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
          var bulan,day ;
        if(date.month.toString().length == 1){
          bulan = '0${date.month.toString()}';
        } else {
          bulan = date.month.toString();
        }
        if(date.day.toString().length == 1){
          day = '0${date.day.toString()}';
        } else {
          day = date.day.toString();
        }
        tgl_lahir =
            date.year.toString() + bulan + day;
        controllerTanggallahir.text =date.toString().split(' ')[0];
      },
      currentTime: DateTime.now(),
      locale: LocaleType.id,
      theme: DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  void editPegawai() async {
    var data = {
      'idUser': widget.idUser.toString(),
      'namaLengkap': controllerNama.text,
      'email': controllerEmail.text,
      'tempatLahir': controllerTempatlahir.text,
      'tanggalLahir': tgl_lahir,
      'kdJenisKelamin': valJK.toString(),
      'kdPendidikan': valPendidikan.toString(),
      'kdJabatan': valJabatan.toString(),
      'kdDepartemen': valDepartemen.toString(),
      'kdUnitKerja':valUnitKerja.toString(),
      'password': controllerPassword.text,
      'passwordC': controllerPasswordC.text
    };
    setState(() {
      loading = true;
    });
    print(data);
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token');
      var url = Uri.parse(API_PEGAWAI.ubahPegawai());
      var response = await http.post(url,
          headers: {'Authorization': '$token'}, body: data);
      var json = jsonDecode(response.body);
      print('JSON UBAH PEGAWAI: $json');
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: json['succes']);
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
      } else if (response.statusCode == 501) {
        setState(() {
          loading = false;
        });
        CoolAlert.show(
            context: context,
            type: CoolAlertType.info,
            text: json['error'].toString());
      }
    } catch (e) {
      print('Error ubah pegawai: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueUpdate();
    getjabatan();
    getdepartemen();
    getunit();
    getpendidikan();
    getjk();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xff00ADB5)));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineIcons.angleLeft, size: 25, color: Colors.white),
        ),
        title: Text('Ubah Pegawai'),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.user, size: 25),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon:
                                  Icon(FontAwesomeIcons.envelope, size: 25),
                            ),
                            validator: (value) {
                             if (value == null || value.isEmpty) {
                                return 'Kolom Email harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onTap: tanggalLahir,
                              readOnly: true,
                              controller: controllerTanggallahir,
                              decoration: InputDecoration(
                                hintText: 'Masukan Tanggal Lahir',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0)),
                                prefixIcon:
                                    Icon(FontAwesomeIcons.calendar, size: 25),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kolom Tanggal lahir harus di isi';
                                }
                              },
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.lock, size: 25),
                              suffixIcon: InkWell(
                                  onTap: changePassword,
                                  child: showPassword == true
                                      ? Icon(FontAwesomeIcons.eyeSlash,
                                          size: 25)
                                      : Icon(FontAwesomeIcons.eye, size: 25)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                              prefixIcon: Icon(FontAwesomeIcons.lock, size: 25),
                              suffixIcon: InkWell(
                                  onTap: changePasswordC,
                                  child: showPasswordC == true
                                      ? Icon(FontAwesomeIcons.eyeSlash,
                                          size: 25)
                                      : Icon(FontAwesomeIcons.eye, size: 25)),
                            ),
                            validator: (value) {
                             if (value == null || value.isEmpty) {
                                return 'Kolom Password Konfirmasi harus di isi';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: valJabatan ,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valJabatan = value;
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
                            validator: (value) =>
                                value == null ? 'Kolom ini wajib di isi' : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: valDepartemen ,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valDepartemen = value;
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
                            validator: (value) =>
                                value == null ? 'Kolom ini wajib di isi' : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: valUnitKerja ,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valUnitKerja = value;
                                print(value);
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
                          validator: (value) =>
                                value == null ? 'Kolom ini wajib di isi' : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: valPendidikan,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valPendidikan = value;
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
                            validator: (value) =>
                                value == null ? 'Kolom ini wajib di isi' : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: valJK ,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            onChanged: (value) {
                              setState(() {
                                valJK = value;
                              });
                            },
                            hint: Text('Pilih Jenis Kelamin'),
                            isExpanded: true,
                            items: jk.map((item) {
                              return DropdownMenuItem(
                                child:
                                    Text(item['namaJenisKelamin'].toString()),
                                value: item['kdJenisKelamin'],
                              );
                            }).toList(),
                            validator: (value) =>
                                value == null ? 'Kolom ini wajib di isi' : null,
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
              child: loading == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CupertinoActivityIndicator(),
                        Text('Loading',
                            style: TextStyle(color: Colors.black, fontSize: 17))
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          editPegawai();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'SIMPAN',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
