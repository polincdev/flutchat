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
                      padding:EdgeInsets.symmetric(horizontal: 40.0,vertical: 120.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          _buildEmailTF() ,
                          SizedBox(
                            height: 30.0,
                          ),
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
padding: EdgeInsets.symmetric(vertical:25.0),
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

class ConfigPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  void setDataAndGoToChatPage(String name, String bio,BuildContext context) {
    User user=  FirebaseAuth.instance.currentUser;

    user.updateProfile(displayName: name);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(),
        )
    );
    FirebaseFirestore
        .instance
        .collection("Users")
        .doc(user.uid)
        .set(
        {
          "bio": bio,
          "displayName": name,
          "email": user.email,
        }
    );



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account data")),
      body: Stack(
    children: <Widget>[
    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    ),

    Container(
    height: double.infinity,
    padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 20.0,
        ),
    child: ListView(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name',
                style: kLabelStyle,
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.add_box,
                      color: Colors.white,
                    ),
                    hintText: 'User name',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ],
          ),


            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text(
            'Trip [OPTIONAL]',
            style: kLabelStyle,
            ),
            SizedBox(height: 10.0),
            Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextField(
              controller: _bioController,
            keyboardType: TextInputType.name,
            style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
            Icons.add_moderator,
            color: Colors.white,
            ),
            hintText: 'Trip',
            hintStyle: kHintTextStyle,
            ),
            ),
            ),
            ],
            ),

             Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: double.infinity,
            child:  RaisedButton(
            elevation: 5.0,
            onPressed:(){

              var name= _nameController.text;
              if( name==null || name.isEmpty || name.length<3 || name.length>10){
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong name")));
                return;
              }
              var trip= _bioController.text;
              if(trip.length>20){
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong trip")));
                return;
              }

              setDataAndGoToChatPage(
                  _nameController.text,
                  _bioController.text, context
              );
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child:Text('ENTER', style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing:1.5,
                fontSize:18.0,
                fontWeight:FontWeight.bold,
                fontFamily:'OpenSans'
            )),

          ),
             ),
        ],
      ),
    ),
        ]
     )
    );
  }
}

class RoomPage extends StatelessWidget {
  final _roomController = TextEditingController();


  void goToConfigPage(String room,BuildContext context) {

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfigPage(),
        )
    );


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Enter room name eg. /room/")),
        body: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),

              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                child: ListView(
                  children: <Widget>[

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Room',
                          style: kLabelStyle,
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: kBoxDecorationStyle,
                          height: 60.0,
                          child: TextField(
                            controller: _roomController,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LowerCaseTextFormatter(),
                            ],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.add_box,
                                color: Colors.white,
                              ),
                              hintText: '/room/',
                              hintStyle: kHintTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),


                    Container(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      width: double.infinity,
                      child:  RaisedButton(
                        elevation: 5.0,
                        onPressed:(){

                         var roomName= _roomController.text;
                          if( roomName==null ||  roomName.isEmpty ||  roomName.length<3 ||  roomName.length>20){
                             ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Empty room name")));
                             return;
                           }
                          if(!roomName.startsWith("/") && !roomName.endsWith("/") ){
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Room name should start and end with '/'")));
                            return;
                          }

                          MyChatApp.roomName= _roomController.text.toLowerCase();

                          goToConfigPage(
                              _roomController.text,
                               context
                          );
                        },
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child:Text('ENTER', style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing:1.5,
                            fontSize:18.0,
                            fontWeight:FontWeight.bold,
                            fontFamily:'OpenSans'
                        )),

                      ),
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  var _messageController =TextEditingController();

  void sendText(String text) {
    User user = FirebaseAuth.instance.currentUser;

     try {
      FirebaseFirestore.instance.collection("Messages").add(
          {
            "from": user.uid,
            "when": Timestamp.fromDate(DateTime.now().toUtc()),
            "msg": text,
            "room":MyChatApp.roomName,

          }
      );
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString())
        ),
      );
     // print("blad="+e.toString());
    }
  }

  Stream<QuerySnapshot> getMessages() =>
      FirebaseFirestore.instance
          .collection("Messages")
          .where('room', isEqualTo: MyChatApp.roomName)
          //  .where('room', isEqualTo: "/Polska/", )
           .where('when',  isGreaterThanOrEqualTo: new DateTime.now().subtract(Duration( hours: 1  ))  )
          .orderBy("when", descending: true)
           .snapshots();

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(MyChatApp.roomName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
          onPressed: () {
          _goBack(context);
          },
          ),
        actions: [
          IconButton(
            tooltip: "Change your bio",
            icon: Icon(Icons.edit),
            onPressed: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeBioPage()
                    )
                ),
          )
        ],
    ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: getMessages(),
                builder: (context, snapshot) {

                  print("RET="+ snapshot.hasData.toString());

                  return Stack(
                      children: <Widget>[
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF73AEF5),
                                Color(0xFF61A4F1),
                                Color(0xFF478DE0),
                                Color(0xFF398AE5),
                              ],
                              stops: [0.1, 0.4, 0.7, 0.9],
                            ),
                          ),
                        ),

                        snapshot.hasData ?
                        MessagesList(snapshot.data as QuerySnapshot)
                            :
                        Center(child: CircularProgressIndicator())
                      ]
                  );
                },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.text,
                      onSubmitted: (txt) {

                        if( txt==null || txt.isEmpty ||  txt.length>50){
                          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:   Text("Wrong post")));
                          return;
                        }

                        sendText(txt);
                        _messageController.clear();
                      }
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendText(_messageController.text);
                    _messageController.clear();
                  }
              )
            ],
          )
        ],
      ),
    );
  }
}


class MessagesList extends StatelessWidget {
  MessagesList(this.data);

  final QuerySnapshot data;

  bool areSameDay(Timestamp a, Timestamp b) {
    var date1 = a.toDate().toLocal();
    var date2 = b.toDate().toLocal();
    return
      (date1.year == date2.year)
          &&
          (date1.month == date2.month)
          &&
          (date1.day == date2.day);
  }

  @override
  Widget build(BuildContext context) =>
      ListView.builder(
          reverse: true,
          itemCount: data.docs.length,
          itemBuilder: (context, i) {
            var months = [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"
            ];

            DateTime when = data
                .docs[i].get("when")
                .toDate()
                .toLocal();

            CollectionReference users = FirebaseFirestore.instance.collection('Users');

           print("PRINT="+when.toString()+" "+data.docs[i].get("from").toString()+" "+users.doc(data.docs[i].get("from")).get().toString());

            var widgetsToShow = <Widget>[
              FutureBuilder<DocumentSnapshot>(
              future: users.doc(data.docs[i].get("from")).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if( snapshot.hasData) {
                print("PRINT2a="+snapshot.hasData.toString());

                 print("PRINT2="+(snapshot.data as DocumentSnapshot).data().toString());

                 var mess = Message(
                    from: (snapshot.data as DocumentSnapshot).data(),
                    msg: data.docs[i].get("msg"),
                    when: when,
                    uid: data.docs[i].get("from")
                );
                 print("PRINT3="+mess.from["displayName"]);

                 return mess;
              }
             else {
                return CircularProgressIndicator();
              }

              },
            ),
            ];

            if(i == data.docs.length-1) {
              widgetsToShow.insert(
                  0,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "${when.day} ${months[when.month-1]} ${when.year}",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  )
              );
            } else if(
            !areSameDay(
                data.docs[i+1].get("when"),
                data.docs[i].get("when")
            )
            ) {
              widgetsToShow.insert(
                  0,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        "${when.day} ${months[when.month-1]} ${when.year}",
                        style: Theme.of(context).textTheme.subhead
                    ),
                  )
              );
            }
            return Column(
                children: widgetsToShow
            );
          }
      );
}

class Message extends StatelessWidget {
  Message({this.from, this.msg, this.when, this.uid});

  final Map<String, dynamic> from;
  final String uid;
  final String msg;
  final DateTime when;

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return Container(
        alignment: user.uid == uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 3 * 2,
          child: Card(
              shape: StadiumBorder(),
              child: ListTile(
                title: user.uid != uid
                    ?
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.0,
                        left: 5.0
                    ),
                    child: Text(
                        from["displayName"],
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle
                    ),
                  ),
                  /* onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(from)
                          )
                      ),*/
                )
                    :
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                        "You",
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle
                    ),
                  ),
                  onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(from)
                          )
                      ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0,
                      left: 5.0
                  ),
                  child: Text(
                      msg,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                  ),
                ),
                trailing: Text("${when.hour}:${when.minute}"),
              )
          ),
        )
    );
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage(this.user);

  final Map<String, dynamic> user;

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Center(
          child:
          Stack(
            children: <Widget>[
          Container(
          height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                  user["displayName"],
                  style: Theme.of(context).textTheme.title
              ),
              Text(
                  user["bio"],
                  style: Theme.of(context).textTheme.subtitle
              ),
              FlatButton.icon(
                  icon: Icon(Icons.email),
                  label: Text("Send an e-mail to ${user["displayName"]}"),
                  onPressed: () async {
                    var url =
                        "mailto:${user["email"]}?body=${user["displayName"]},\n";
                    if(await canLaunch(url)) {
                      launch(url);
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You don't have any e-mail app"),
                          )
                      );
                    }
                  }
              )
            ],
          ),
          ]
          ),
        )
    );
  }
}

class ChangeBioPage extends StatelessWidget {
  final _controller = TextEditingController();

  void _changeBio(String bio)
      {
      User user = FirebaseAuth.instance.currentUser;

                FirebaseFirestore
                .instance
                .collection("Users")
                .doc(user.uid)
                .update(
                {
                  "bio": bio
                });
          }


  @override
  Widget build(context) =>
      Scaffold(
          appBar: AppBar(
            title: Text("Change your trip"),
          ),
          body: Center(
            child:
            Stack(
              children: <Widget>[
            Container(
            height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _controller,

                      decoration: InputDecoration(
                          labelText: "Trip"
                      ),
                      onSubmitted: (bio) {
                        _changeBio(bio);
                        Navigator.pop(context);
                      }
                  ),
                ),
                FlatButton(
                    child: Text("Change Bio"),
                    onPressed: () {
                      _changeBio(_controller.text);
                      Navigator.pop(context);
                    }
                )
              ],
            ),
            ]
            ),
          )
      );
}
