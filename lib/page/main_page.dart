part of 'page.dart';

class MainPage extends StatefulWidget {
  final User user;
  MainPage(this.user);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    Widget customBottomNavigationBar() {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.only(top: 10),
              child: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(),
              child: Icon(
                Icons.search,
                color: currentIndex == 1 ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.only(top: 10),
              child: Icon(
                Icons.shopping_bag,
                color: currentIndex == 2 ? Colors.black : Colors.grey,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () async {
                await AuthServices.signOut();
              },
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.logout,
                  color: currentIndex == 3 ? Colors.black : Colors.grey,
                ),
              ),
            ),
            label: '',
          ),
        ],
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return HomePage(user);
          break;
        case 1:
          return SearchPage();
          break;
        case 2:
          return FavoritePage();
          break;
        case 3:
          return LogOutpage();
          break;
        default:
          return HomePage(user);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: customBottomNavigationBar(),
      body: body(),
    );
  }
}
