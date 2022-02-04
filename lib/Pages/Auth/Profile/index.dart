import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendtes/API/Pegawai/index.dart';
import 'package:frontendtes/Pages/Auth/Login/index.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;

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
  
  Future<XFile?> pickCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera).then((pilihgambar) async {
      if (pilihgambar == null) return;
      print('Gambar: $pilihgambar');
      cropImage(pilihgambar.path).then((cropGambar) {
        if (cropGambar == null) return;
        setState(() {
          imageFile = cropGambar;
          // Timer(Duration(seconds: 2),(){
          //   gantiPoto();
          // });
        });
      });
    });
  }

  Future<XFile?> galery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery).then((pilihgambar) async {
      if (pilihgambar == null) return;
      print('Gambar: $pilihgambar');
      cropImage(pilihgambar.path).then((cropGambar) {
        if (cropGambar == null) return;
        setState(() {
          imageFile = cropGambar;
        });
      });
    });
  }

  Future<File?> cropImage(String filePath) async {
    return await ImageCropper.cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
  }

  void pilihAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Gambar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    galery();
                  },
                  child: Row(
                    children: const [
                      Icon(FontAwesomeIcons.image),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Pilih Dari Galery'),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    pickCamera();
                  },
                  child: Row(
                    children: const [
                      Icon(FontAwesomeIcons.camera),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Pilih Dari Camera'),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void gantiPoto() async {
    print(imageFile!.path);
    // /data/user/0/com.frontendtes.frontendtes/cache/image_cropper_1643905045377.jpg
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = Uri.parse(API_PEGAWAI.adminUbahPoto());
    try {
      // var response = await http.post(url, headers: {
      //   'Authorization': '$token',
      // }, body: {
      //   "idUser": "1",
      //   "namaFile": "Poto_profil",
      //   "files": imageFile!.path.split('/').last,
      // });
      // var json = jsonDecode(response.body);
      // print('JSON poto: $json');
      // if (response.statusCode == 200) {}
      var stream = http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      // var stream = http.ByteStream(imageFile!.openRead())..cast();
      var length = await imageFile!.length();
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      // var multiPart = await http.MultipartFile.fromPath(
      //   'files',
      //   imageFile!.path,
      // );
      var multiPart = http.MultipartFile(
        'files',
        stream,
        length,
        filename: path.basename(imageFile!.path),
      );
      request.headers['Authorization'] = '$token';
      request.fields['idUser'] = '1';
      request.fields['namaFile'] = 'poto_profil';
      request.files.add(multiPart);

      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((event) {
        // print(event);
        // final data = jsonDecode(event);
        // print('res: ${event}');
      });
    } catch (e) {
      print('Error ganti poto:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(8.0),
            height: 150,
            color: Colors.grey[300],
            child: Stack(
              children: [
                imageFile == null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 60,
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                          size: 60,
                        ))
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(image: DecorationImage(image: FileImage(imageFile!)), borderRadius: BorderRadius.circular(60)),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                      onTap: pilihAction,
                      child: CircleAvatar(
                          backgroundColor: Colors.teal[700],
                          radius: 20,
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                            size: 20,
                          ))),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: gantiPoto,
            child: Text('ganti'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[700]
                ),
                child: Text('LOGOUT', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
