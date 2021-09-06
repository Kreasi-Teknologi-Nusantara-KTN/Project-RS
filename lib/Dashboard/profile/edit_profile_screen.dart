import 'package:aplikasi_rs/config/theme.dart';
import 'package:aplikasi_rs/controllers/controllers.dart';
import 'package:aplikasi_rs/models/model_pasien.dart';
import 'package:aplikasi_rs/services/pasien_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ControllerPasien controllerPasien = Get.find<ControllerPasien>();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController noKtpController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController agamaController = TextEditingController();
  TextEditingController pendidikanController = TextEditingController();
  bool isLoading = false;
  final picker = ImagePicker();
  File _image;
  _onLoading() => setState(() => isLoading = true);
  _offLoading() => setState(() => isLoading = false);

  @override
  void initState() {
    // String tgl = DateFormat("dd-MM-yyyy")
    //     .format(controllerPasien.pasien.value.tanggalLahir);
    namaController =
        TextEditingController(text: controllerPasien.pasien.value.namaLengkap);
    emailController =
        TextEditingController(text: controllerPasien.pasien.value.email);
    tglLahirController =
        TextEditingController(text: controllerPasien.pasien.value.tanggalLahir);
    noKtpController =
        TextEditingController(text: controllerPasien.pasien.value.noKtp);
    jenisKelaminController =
        TextEditingController(text: controllerPasien.pasien.value.jenisKelamin);
    alamatController =
        TextEditingController(text: controllerPasien.pasien.value.alamat);
    agamaController =
        TextEditingController(text: controllerPasien.pasien.value.agama);
    pendidikanController =
        TextEditingController(text: controllerPasien.pasien.value.pendidikan);
    super.initState();
  }

  Future<dynamic> getGambar(String id) async {
    String usernameAuth = "admin";
    String passwordAuth = "1234";
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$usernameAuth:$passwordAuth'));
    print(basicAuth);

    final response = await http.get(
        Uri.parse(
            "https://api.rsbmgeriatri.com/api/Pasien?bhayangkara-key=bhayangkara123&id=" +
                id),
        headers: <String, String>{'authorization': basicAuth});

    print("hasil auth : " + response.body.toString());
    Map<String, dynamic> bodyJson = jsonDecode(response.body);
    return controllerPasien.pasien.value =
        modelPasienFromJson(jsonEncode(bodyJson));
  }

  _simpanProfile() async {
    _onLoading();
    String updateAt = DateFormat("yyyy-MM-dd H:m:s").format(DateTime.now());

    print("update : " + updateAt);

    if (_image == null) {
      await PasienServices()
          .editProfile_nonGambar(
              idPasien: controllerPasien.pasien.value.idPasien,
              namaLengkap: namaController.text,
              tanggalLahir: tglLahirController.text,
              noKtp: noKtpController.text,
              jenisKelamin: jenisKelaminController.text,
              agama: agamaController.text,
              pendidikan: pendidikanController.text,
              alamat: alamatController.text,
              email: emailController.text,
              createdAt: controllerPasien.pasien.value.createdAt,
              updateAt: updateAt)
          .then((value) {
        print("cetak value ui " + value.toString());

        getGambar(controllerPasien.pasien.value.idPasien);
        _offLoading();
        Get.back();
      }).catchError((e) {
        _offLoading();
        print("error value ui " + e.toString());
      });
    } else {
      await PasienServices()
          .editProfile(
              idPasien: controllerPasien.pasien.value.idPasien,
              namaLengkap: namaController.text,
              gambar: _image,
              tanggalLahir: tglLahirController.text,
              noKtp: noKtpController.text,
              jenisKelamin: jenisKelaminController.text,
              agama: agamaController.text,
              pendidikan: pendidikanController.text,
              alamat: alamatController.text,
              email: emailController.text,
              createdAt: controllerPasien.pasien.value.createdAt,
              updateAt: updateAt)
          .then((value) {
        print("cetak value ui " + value.toString());

        getGambar(controllerPasien.pasien.value.idPasien);
        _offLoading();
        // controllerPasien.pasien.value.namaLengkap = namaController.text;
        // controllerPasien.pasien.value.gambar =
        //     controllerPasien.pasien.value.gambar;
        // controllerPasien.pasien.value.jenisKelamin = jenisKelaminController.text;
        // controllerPasien.pasien.value.alamat = alamatController.text;
        // controllerPasien.pasien.value.agama = agamaController.text;
        // controllerPasien.pasien.value.pendidikan = pendidikanController.text;
        Get.back();

        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return ProfileScreen();
        // }));
      }).catchError((e) {
        _offLoading();
        print("error value ui " + e.toString());
      });
    }
  }

  Future _getImagegallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      //_image = File(image.path);
      if (image != null) {
        _image = File(image.path);
        //foto_bpjs.text = image.path;
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height * 0.3,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/wave_dashboard.png',
                      fit: BoxFit.fill,
                      width: Get.width,
                      height: Get.height * 0.3,
                    ),
                    Container(
                      child: Positioned(
                        top: Get.height * 0.1,
                        child: Container(
                          width: Get.width,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                        child: Text("Profile Pasien",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ))))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //margin: const EdgeInsets.all(30.0),
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width * 0.999,
                      height: MediaQuery.of(context).size.height * 0.290,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: (_image == null)
                                        ? (controllerPasien
                                                    .pasien.value.gambar ==
                                                null)
                                            ? AssetImage(
                                                "assets/images/ProfileDefault.jpg")
                                            : NetworkImage(
                                                'https://api.rsbmgeriatri.com/assets/profile/' +
                                                    controllerPasien
                                                        .pasien.value.gambar)
                                        : FileImage(_image))),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          _getImagegallery();
                        },
                        child: Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      enabled: false,
                      controller: tglLahirController,
                      decoration: InputDecoration(
                          hintText: "Tanggal Lahir",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      enabled: false,
                      controller: noKtpController,
                      decoration: InputDecoration(
                          hintText: "Nomor KTP",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    new DropdownButtonFormField<String>(
                      value: jenisKelaminController.text,
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Jenis Kelamin'),
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('Laki-Laki'),
                          ),
                          value: 'l',
                        ),
                        DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('Perempuan'),
                          ),
                          value: 'p',
                        )
                      ],
                      onChanged: (val) {
                        setState(() {
                          jenisKelaminController.text = val;
                        });

                        print("jenis kelamin : " + jenisKelaminController.text);
                      },
                    ),
                    // TextField(
                    //   controller: jenisKelaminController,
                    //   decoration: InputDecoration(
                    //       hintText: "Jenis Kelamin",
                    //       contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    // ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      controller: alamatController,
                      decoration: InputDecoration(
                          hintText: "Alamat",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      controller: agamaController,
                      decoration: InputDecoration(
                          hintText: "Agama",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    TextField(
                      controller: pendidikanController,
                      decoration: InputDecoration(
                          hintText: "Pendidikan",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: Get.width,
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: ElevatedButton(
                  onPressed: () {
                    _simpanProfile();
                  },
                  child: Text(
                    "Simpan",
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 19,
              ),
              Container(
                width: Get.width,
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Kembali",
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
