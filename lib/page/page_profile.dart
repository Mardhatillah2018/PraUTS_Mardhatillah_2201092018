import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionLatihanManager {
  int? value;
  String? idUser, userName, fullname, email;

  Future<void> saveSession(int val, String id, String username, String fullname, String email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("value", val);
    await sharedPreferences.setString("id", id);
    await sharedPreferences.setString("username", username);
    await sharedPreferences.setString("fullname", fullname);
    await sharedPreferences.setString("email", email);
  }

  Future<void> getSession() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    value = sharedPreferences.getInt("value");
    idUser = sharedPreferences.getString("id");
    userName = sharedPreferences.getString("username");
    fullname = sharedPreferences.getString("fullname");
    email = sharedPreferences.getString("email");
  }

  Future<void> clearSession() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}

class PageProfileUser extends StatefulWidget {
  const PageProfileUser({Key? key}) : super(key: key);

  @override
  State<PageProfileUser> createState() => _PageProfileUserState();
}

class _PageProfileUserState extends State<PageProfileUser> {
  late SessionLatihanManager session;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    session = SessionLatihanManager();
    getDataSession();
  }

  Future<void> getDataSession() async {
    await session.getSession();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 55,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${isLoading ? 'Loading...' : session.userName ?? 'Data tidak tersedia'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Divider(
                  thickness: 2,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                ListTile(
                  title: Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.userName ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.person),
                ),
                // ListTile(
                //   title: Text(
                //     'Email',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   subtitle: Text(
                //     '${isLoading ? 'Loading...' : session.email ?? 'Data tidak tersedia'}',
                //   ),
                //   leading: Icon(Icons.email),
                // ),

                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => PageEditProfile(session: session),
                //       ),
                //     ).then((_) {
                //       setState(() {
                //         isLoading = true;
                //       });
                //       getDataSession();
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                //   ),
                //   child: Text(
                //     'Edit Profile',
                //     style: TextStyle(
                //       fontSize: 15,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageEditProfile extends StatefulWidget {
  final SessionLatihanManager session;

  const PageEditProfile({Key? key, required this.session}) : super(key: key);

  @override
  State<PageEditProfile> createState() => _PageEditProfileState();
}

class _PageEditProfileState extends State<PageEditProfile> {
  late TextEditingController txtFullname;
  late TextEditingController txtEmail;

  @override
  void initState() {
    super.initState();
    txtFullname = TextEditingController(text: widget.session.fullname);
    txtEmail = TextEditingController(text: widget.session.email);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: txtFullname,
                decoration: InputDecoration(
                  labelText: 'Fullname',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.session.saveSession(
                    widget.session.value ?? 0,
                    widget.session.idUser ?? '',
                    widget.session.userName ?? '',
                    txtFullname.text,
                    txtEmail.text,
                  ).then((_) {
                    updateDatabase(txtFullname.text, txtEmail.text);
                    Navigator.pop(context);
                  });
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    txtFullname.dispose();
    txtEmail.dispose();
    super.dispose();
  }

  void updateDatabase(String fullname, String email) {
    // Implementasi logika untuk mengupdate data di database
  }
}