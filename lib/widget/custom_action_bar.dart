part of 'widget.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool backArrow;

  CustomActionBar(
    this.title,
    this.backArrow,
  );

  @override
  Widget build(BuildContext context) {
    final CollectionReference _userRef =
        FirebaseFirestore.instance.collection('users');

    User _user = FirebaseAuth.instance.currentUser;

    bool _backArrow = backArrow ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0),
          ],
          begin: Alignment(0, 0),
          end: Alignment(0, 3),
        ),
      ),
      padding: EdgeInsets.only(
        top: 45,
        left: 30,
        right: 30,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_backArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                ),
              ),
            ),
          Text(
            title,
            style: GoogleFonts.rosarivo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.black,
              ),
              child: StreamBuilder(
                stream: _userRef.doc(_user.uid).collection('Cart').snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;

                  if (snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }

                  return Text(
                    "$_totalItems" ?? "0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
