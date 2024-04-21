import 'package:flutter/material.dart';
import 'package:simulasi_uts/page/page_list_berita.dart';
import 'package:simulasi_uts/page/page_login.dart';
import 'package:simulasi_uts/page/page_profile.dart';
import '../../utils/session_manager.dart';


class PageBottomNavigationBar extends StatefulWidget {
  const PageBottomNavigationBar({Key? key});

  @override
  State<PageBottomNavigationBar> createState() =>
      _PageBottomNavigationBarState();
}

class _PageBottomNavigationBarState extends State<PageBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late SessionManager sessionManager;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    sessionManager.getSession().then((_) {
      setState(() {}); // Perbarui tampilan setelah sesi diambil
    });
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edukasi App'),
        backgroundColor: Colors.grey,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Welcome ${session.userName}'),
          ),
          //logout
          IconButton(
            onPressed: () {
              //clear session
              setState(() {
                session.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PageLogin()),
                      (route) => false,
                );
              });
            },
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // handle tap
        },
        child: TabBarView(
          controller: tabController,
          children: [
            // content
            PageListBerita(),
            PageProfileUser()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabController.index,
        onTap: (index) {
          tabController.animateTo(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

}
