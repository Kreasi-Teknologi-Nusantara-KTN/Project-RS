import 'dart:convert';
import 'package:aplikasi_rs/models/model_pasien.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasienServices {
  //TODO:: Password jadi random
  Future<dynamic> editProfile({
    @required String idPasien,
    @required String namaLengkap,
    @required String tanggalLahir,
    @required String noKtp,
    @required String jenisKelamin,
    @required String agama,
    @required String pendidikan,
    @required String alamat,
    @required String email,
    @required String createdAt,
    @required String updateAt,
  }) async {
    String usernameAuth = "admin";
    String passwordAuth = "1234";
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$usernameAuth:$passwordAuth'));
    print(basicAuth);

    Map<String, dynamic> data = {
      "id" : idPasien,
      "nama_lengkap" : namaLengkap,
      "tanggal_lahir" : tanggalLahir,
      "no_ktp" : noKtp,
      "jenis_kelamin" : jenisKelamin,
      "agama" : agama,
      "pendidikan" : pendidikan,
      "alamat" : alamat,
      "email" : email,
      "created_at" : createdAt,
      "updated_at" : updateAt,
    };

    print("cetak data : " + data.toString());
    try {
      final response = await http.put(
          Uri.parse(
              "https://api.rsbmgeriatri.com/api/Pasien?bhayangkara-key=bhayangkara123"),
          headers: <String, String>{'authorization': basicAuth},
      body:data
      );

      print("hasil auth : " + response.body.toString());
        return jsonDecode(response.body);

    } catch (e) {
      print("error editProfile Services" + e.toString());
    }
  }

  Future<dynamic> sendEmergency(
      {@required idPasien,
      @required String latitude,
      @required String longitude}) async {
    String usernameAuth = "admin";
    String passwordAuth = "1234";
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$usernameAuth:$passwordAuth'));
    print("$latitude and $longitude");
    try {
      final response = await http.post(
          Uri.parse(
              "https://api.rsbmgeriatri.com/api/Emergency?bhayangkara-key=bhayangkara123"),
          headers: <String, String>{
            'authorization': basicAuth
          },
          body: {
            "pasien_id": idPasien,
            "longitude": longitude,
            "latitude": latitude,
          });

      if (response.statusCode == 201) {

        return jsonDecode(response.body);
      }
    } catch (e) {
      print("error editProfile Services" + e.toString());
    }
  }
}
