import 'package:chat_flutter/screens/authenticate/register_view.dart';
import 'package:chat_flutter/services/auth.dart';
import 'package:chat_flutter/shared/constants.dart';
import 'package:chat_flutter/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/viewmodels/home_model.dart';
import 'package:chat_flutter/shared/globals.dart';
import 'package:chat_flutter/widgets/button_widget.dart';
import 'package:chat_flutter/widgets/textfield_widget.dart';
import 'package:chat_flutter/widgets/wave_widget.dart';
import 'package:chat_flutter/screens/authenticate/register.dart';

import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  
  // final model = Provider.of<HomeModel>(context);
  // final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  // String error = '';
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    // bool _validate = false;

    return loading ? Loading() :  Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height - 200,
            color: Global.mediumBlue,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Global.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'KENCAN',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFormField(
                    cursorColor: Global.mediumBlue,
                    style: TextStyle(
                      color: Global.mediumBlue,
                      fontSize: 14.0,
                    ),
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (emailval) {
                    // print(email);
                    setState(() {
                      email = emailval;
                      // print(email);
                    });
                  },
                ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Global.mediumBlue,
                        style: TextStyle(
                          color: Global.mediumBlue,
                          fontSize: 14.0,
                        ),
                        decoration: textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length < 6 ? 'Password contains more than 6 characters' : null,
                        onChanged: (passwordval) {
                         setState(() {
                          password = passwordval;
                         });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Global.mediumBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                      // if (email != ''){
                        setState(() {
                          loading= true;
                        });
                        // loading = true;
                        // print(email + password);
                        dynamic result = await _auth.signIn(email, password);
                        if (result == null){
                          setState(() {
                            loading = false;
                            print('user not registered');
                            // error = 'User not registered';
                          });
                          // loading = false;
                          // error = 'user not registered';
                        }
                        else{
                          print(result);
                        }
                      }
                    },
                    child: ButtonWidget(
                      title: 'Login',
                      hasBorder: false,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterView()),
                      );
                    },
                    child: ButtonWidget(
                      title: 'Sign Up',
                      hasBorder: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
