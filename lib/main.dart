// @dart=2.9
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '/RoomPage.dart';
import '/ConfigPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyChatApp(
      await FirebaseAuth.instance.currentUser != null

  ));
}

class MyChatApp extends StatelessWidget {
  MyChatApp(this.isSignedIn);

  final bool isSignedIn;
  static String roomName="";
  static bool _saving = false;
  static bool _loging = false;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );// /*isSignedIn ? ChatPage() :*/
  }
}

class LoginScreen extends StatefulWidget{

 LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() {
      return _LoginScreenState();
  }

}
class _LoginScreenState extends State<LoginScreen>{

  bool _rememberMe= false;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  User _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _verificationComplete = false;


  Future<User> signUp(
      String email, String password, BuildContext context
      ) async{
    print("TEST1 "+email+" "+password);
    UserCredential authResult;
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString())
        ),
      );
      print("eoor="+e.toString());
    }

    print("TEST2");
    return authResult.user;
  }


  Future<User> anonAccess(
        BuildContext context
      ) async{
     UserCredential authResult;
    try {

      authResult = await _auth.signInAnonymously();

    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString())
        ),
      );
      print("eoor="+e.toString());
    }

    print("TEST2");
    return authResult.user;
  }

  Future<UserCredential> anonAccess2(BuildContext context) async{
    Future<UserCredential> authResult;
    try {
        MyChatApp._saving=true;
        authResult =   _auth.signInAnonymously();
      }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString())
        ),
      );
     }

    return authResult ;
  }

  Future<User> logIn(String email, String password) async
  {
    UserCredential authResult = await _auth
        .signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return authResult.user;
  }


  @override
  Widget build(BuildContext context) {

    _emailController.text = '';
    _passwordController.text ="";

    return     Scaffold(
        body: Stack(
            children: <Widget>[
              Container(
                  height:double.infinity,
                  width:double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end:Alignment.bottomCenter,
                        colors: [
                          Color(0xFF73AEF5),
                          Color(0xFF61A4F1),
                          Color(0xFF478DE0),
                          Color(0xFF398AE5),
                        ],
                        stops: [0.1, 0.4, 0.7, 0.9],
                      )
                  )
              ),
            LoadingOverlay(
              isLoading: MyChatApp._saving,
              child: Container(
                  height:double.infinity,
                  child:SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding:EdgeInsets.symmetric(horizontal: 40.0,vertical: 80.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildLogo() ,
                          SizedBox(height: 10),
                          _buildEmailTF() ,
                          SizedBox(height: 10.0,),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
                          _buildRememberMeCheckbox(),
                          _buildLoginBtn(),
                          _buildSignInWithText(),
                          _buildSocialBtnRow(),
                          _buildSignupBtn(),
                          _buildAnonAccess(),
                        ],
                      )

                  )

              ),
            ),

            ]
        ),

    );
  }



  Widget _buildEmailTF()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Text("Email", style:kLabelStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration:  kBoxDecorationStyle,
          child: TextField(
            controller: _emailController,
          keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border:InputBorder.none,
              contentPadding: EdgeInsets.only(top:14.0),
              prefixIcon:Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText:'Enter your email',
              hintStyle: kHintTextStyle,
          ),
          ),
        )
      ]
    );
  }

  Widget _buildPasswordTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Text('Password', style:kLabelStyle),
        SizedBox(height:10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height:60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style:  TextStyle(
              color:Colors.white,
              fontFamily:'OpenSans'
            ),
            decoration: InputDecoration(
              border:InputBorder.none,
              contentPadding: EdgeInsets.only(top:14.0),
              prefixIcon:Icon(
                Icons.lock,
                color:Colors.white,
              ),
              hintText:'Enter your password',
              hintStyle: kHintTextStyle,

            ),
          ),
        ),
      ]
    );
  }

  Widget _buildForgotPasswordBtn(){
    return Container(
      alignment: Alignment.centerLeft,
      child: FlatButton(
        onPressed: ()=>print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right:0.0),
        child: Text('Forgot password', style:kLabelStyle),
      ),
    );
  }


  Widget _buildRememberMeCheckbox()
  {
    return Container(
      height: 20.0,
      child:Row(
        children:<Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor:Colors.white,
              onChanged:(value){
                setState(() {
                  _rememberMe = value;
                });
              },
            ),

          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ]

),
    );
  }

  Widget _buildLoginBtn( ){
    return Container(
padding: EdgeInsets.symmetric(vertical:15.0),
      width:double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed:(){

            logIn(
                _emailController.text,
                _passwordController.text
            ).then(
                    (user) {
                  _user = user;
                  if(!_user.emailVerified) {
                    _user.sendEmailVerification();
                  }
                  _verificationComplete = true;
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => RoomPage()
                  )
                  );
                }
            ).catchError(
                    (e) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "You don't have an account. Please sign up."
                          )
                      )
                  );
                }
            );



        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child:Text('LOGIN', style: TextStyle(
          color: Color(0xFF527DAA),
          letterSpacing:1.5,
          fontSize:18.0,
          fontWeight:FontWeight.bold,
          fontFamily:'OpenSans'
        )),

      ),
    );
  }

  Widget _buildSignInWithText(){
    return Column(
      children: <Widget>[
        Text('-OR-',style:TextStyle(
          color:Colors.white,
          fontWeight:FontWeight.bold
        )),
        SizedBox(height:20.0),
        Text("Sign in with", style: kLabelStyle)
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical:30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[
        _buildSocialBtn(
            (){print('Login with facebook');},
            AssetImage('assets/logos/facebook.jpg')
          ),
    _buildSocialBtn(
      (){print('Login with Google');},
      AssetImage('assets/logos/google.jpg')
      )

        ]
      ),
    );
  }
  Widget _buildLogo(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical:30.0),
      child:  Container(
      height: 80.0,
      width: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        image: DecorationImage(
          image:  AssetImage('assets/chat.png'),
        ),
      ),
    ),

    );
  }
  Widget _buildSignupBtn() {
    TapGestureRecognizer _tapGestureRecognizer=TapGestureRecognizer();
    _tapGestureRecognizer.onTap=() async {
      try {
        _user = await signUp(
            _emailController.text,
            _passwordController.text,
            context
        );
        if (!_user.emailVerified) {
          _user.sendEmailVerification();
        }
        _verificationComplete = true;
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => ConfigPage()
        )
        );
      }
      catch (e) {
        Scaffold.of(context).showSnackBar(
            SnackBar(
                content: Text("An error occurred")
            )
        );
      }
    };

    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              recognizer: _tapGestureRecognizer,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



Widget _buildAnonAccess() {

    if(MyChatApp._loging) {

            return   Center(child: CircularProgressIndicator());

    }
    else {
      return GestureDetector(
        onTap: () async {
          setState(()=>MyChatApp._loging = true);

             anonAccess2(context).then((data) {

               UserCredential userCredential=(data as UserCredential);
               Future.delayed(Duration.zero, () async {
                 setState((){
                   MyChatApp._loging=false;
                   MyChatApp._saving = false;
                   _verificationComplete=true;});

                 if(_verificationComplete) {
                   Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(
                           builder: (context) => RoomPage()
                       )
                   );
                 }

               });


             });


        },

        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Anonymous access',
                  // recognizer: _tapGestureRecognizer,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}



}
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  User _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _verificationComplete = false;

  Future<User> signUp(
      String email, String password, BuildContext context
      ) async{
    print("TEST1 "+email+" "+password);
    UserCredential authResult;
    try {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString())
        ),
      );
      print("eoor="+e.toString());
    }

print("TEST2");
    return authResult.user;
  }

  Future<User> logIn(String email, String password) async
  {
    UserCredential authResult = await _auth
        .signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return authResult.user;
  }

  @override
  Widget build(BuildContext context) {
    if(_verificationComplete) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConfigPage()
          )
      );
    }
    _emailController.text = '';
    _passwordController.text ="";
    return Scaffold(
        appBar: AppBar(
          title: Text("ChatOnFire Login"),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Log In Using Your Phone Number",
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                  ),
                  autofocus: true,
                )
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",

                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: FlatButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text("Log In".toUpperCase()),
                onPressed: () {
                  logIn(
                      _emailController.text,
                      _passwordController.text
                  ).then(
                          (user) {
                        _user = user;
                        if(!_user.emailVerified) {
                          _user.sendEmailVerification();
                        }
                        _verificationComplete = true;
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(
                            builder: (context) => ConfigPage()
                        )
                        );
                      }
                  ).catchError(
                          (e) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "You don't have an account. Please sign up."
                                )
                            )
                        );
                      }
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: FlatButton(
                color: Theme.of(context).hintColor,
                textColor: Colors.white,
                child: Text("Create an Account".toUpperCase()),
                onPressed: () async {
                  try {
                    _user = await signUp(
                        _emailController.text,
                        _passwordController.text,
                      context
                    );
                    if(!_user.emailVerified) {
                      _user.sendEmailVerification();
                    }
                    _verificationComplete = true;
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (context) => RoomPage()
                    )
                    );
                  }
                  catch(e) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                            content: Text("An error occurred")
                        )
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}

