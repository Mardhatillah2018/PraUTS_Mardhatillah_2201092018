import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simulasi_uts/page/page_bottom_navigation_bar.dart';
import 'package:simulasi_uts/page/page_register.dart';

import '../model/model_login.dart';
import '../utils/session_manager.dart';
//import 'package:mi2c_mobile/latihan/page_latihan/lat_bottom_navigation.dart';
//import 'package:mi2c_mobile/latihan/page_latihan/lat_list_berita.dart';

//import '../model_latihan/model_login_latihan.dart';

//import 'package:mi2c_mobile/latihan/page_latihan/lat_register_api.dart';
//import 'package:mi2c_mobile/utils/session_manager.dart';


class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  //untuk mendapatkan value dari text field
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //proses untuk hit api
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http
          .post(Uri.parse('http://192.168.208.154/edukasi_baru/login.php'), body: {
        "username": txtUsername.text,
        "password": txtPassword.text,
      });
      ModelLogin data = modelLoginFromJson(response.body);
      //cek kondisi
      if (data.value == 1) {
        //kondisi ketika berhasil Login
        setState(() {
          isLoading = false;

          //untuk simpan sesi
          session.saveSession(data.value ?? 0, data.id ?? "", data.username ?? "");

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageBottomNavigationBar()),
                  (route) => false);

        });
      } else {
        //gagal
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Form  Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: keyForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        //validasi kosong
                        validator: (val) {
                          return val!.isEmpty ? "tidak boleh kosong " : null;
                        },
                        controller: txtUsername,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Tambahkan ikon di sini
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val!.isEmpty ? "tidak boleh kosong " : null;
                        },
                        controller: txtPassword,
                        obscureText: true, //biar password nya gak keliatan
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Tambahkan ikon di sini
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: isLoading
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : MaterialButton(
                            onPressed: () {
                              //cara get data dari text form field

                              //cek validasi form ada kosong  atau tidk
                              if (keyForm.currentState?.validate() == true) {
                                setState(() {
                                  loginAccount();
                                });
                              }
                            },
                            child: Text('Login'),
                            color: Colors.green,
                            textColor: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 1, color: Colors.green)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PageRegister()));
          },
          child: Text('Belum punya account? Silahkan Register'),
        ),
      ),
    );
  }
}
