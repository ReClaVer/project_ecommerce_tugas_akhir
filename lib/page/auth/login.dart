import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/event/event_pref.dart';
import 'package:project_ecommerce_tugas_akhir/page/auth/register.dart';
import 'package:project_ecommerce_tugas_akhir/widget/info_message.dart';

import '../../config/api.dart';
import '../../config/asset.dart';
import '../../model/user.dart';
import '../dashboard/dashboard.dart';

class Login extends StatelessWidget {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _obsecure = true.obs;

  Login({super.key});

  void login() async {
    try {
      var response = await http.post(
        Uri.parse(Api.login),
        body: {
          'email': _controllerEmail.text,
          'password': _controllerPassword.text,
        },
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          infoMessage.snackbar(Get.context!, 'Login Succes');
          User user = User.fromJson(responseBody['data']);
          await EventPref.saveUser(user);
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.off(Dashboard());
          });
        } else {
          infoMessage.snackbar(Get.context!, 'Login Failed');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Asset.colorBackground,
      body: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight - 300),
                  child: buildForm(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildHeader() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      height: 300,
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Asset.colorAccent)),
              child: const Icon(
                Icons.account_circle,
                size: 150,
                color: Asset.colorAccent,
              ),
            ),
          ),
          const Text(
            'LOGIN',
            style: TextStyle(
                fontSize: 24,
                color: Asset.colorAccent,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget buildForm() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black26,
              offset: Offset(0, -3),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (value) => value == '' ? "Dont Empty" : null,
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Asset.colorPrimary,
                          ),
                          hintText: 'email@gmail.com',
                          border: styleBorder(),
                          enabledBorder: styleBorder(),
                          focusedBorder: styleBorder(),
                          disabledBorder: styleBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          fillColor: Asset.colorAccent,
                          filled: true)),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(() => TextFormField(
                      validator: (value) => value == '' ? "Dont Empty" : null,
                      obscureText: _obsecure.value,
                      controller: _controllerPassword,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.vpn_key,
                            color: Asset.colorPrimary,
                          ),
                          hintText: 'password',
                          suffixIcon: Obx(
                            (() => GestureDetector(
                                  onTap: () {
                                    _obsecure.value = !_obsecure.value;
                                  },
                                  child: Icon(
                                    _obsecure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Asset.colorPrimary,
                                  ),
                                )),
                          ),
                          border: styleBorder(),
                          enabledBorder: styleBorder(),
                          focusedBorder: styleBorder(),
                          disabledBorder: styleBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          fillColor: Asset.colorAccent,
                          filled: true))),
                  const SizedBox(
                    height: 16,
                  ),
                  Material(
                    color: Asset.colorPrimary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print('login');
                          login();
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not have account?'),
                TextButton(
                    onPressed: () {
                      Get.to(Register());
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Asset.colorPrimary,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, color: Asset.colorAccent));
  }
}
