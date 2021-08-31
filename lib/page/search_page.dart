part of 'page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('Products');

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "What You Search?",
                  style: GoogleFonts.rosarivo(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
                future: _productRef.orderBy('search_string').startAt(
                    [_searchString]).endAt(["$_searchString\uf8ff"]).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          "Error ${snapshot.error}",
                        ),
                      ),
                    );
                  }

                  // get all data fromm firebase
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView(
                        padding: EdgeInsets.only(
                          top: 100,
                          bottom: 20,
                        ),
                        children: snapshot.data.docs.map((e) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                    productId: e.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 30,
                                right: 30,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 30,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(width: 2)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        e.data()['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 15,
                                    right: 15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.data()['name'],
                                          style: GoogleFonts.rosarivo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "\$ ${e.data()['price']}",
                                          style: GoogleFonts.rosarivo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList());
                  }

                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          Padding(
            padding: EdgeInsets.only(
              top: 45,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 24.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
