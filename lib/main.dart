import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '/profile/profile_navigator.dart';
import '/home.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('loginBox');
  await Hive.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const MyMainPage(),
    );
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  final List<BottomNavigationBarItem> _menu = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: "Profile")
  ];

  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> pages = [const HomeView(), ProfileNavigator()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (_pageController.page == 0) {
            //Only exit if it is home page
            await SystemNavigator.pop();
          } else if (_pageController.page == 1) {
            // Get navigator key for the profile pages
            final profilePage = pages[1] as ProfileNavigator;
            final navigator = profilePage.navigatorKey.currentState!;
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              setState(() {
                _selectedIndex = 0;
                _pageController.jumpToPage(_selectedIndex);
              });
            }
          } else {
            setState(() {
              _selectedIndex = 0;
              _pageController.jumpToPage(_selectedIndex);
            });
          }
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _menu,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 10,
          fixedColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
              _pageController.jumpToPage(_selectedIndex);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBar extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
