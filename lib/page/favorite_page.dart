part of 'page.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _userRef =
        FirebaseFirestore.instance.collection('users');

    final CollectionReference _productRef =
        FirebaseFirestore.instance.collection('Products');

    final CollectionReference _savedtRef =
        FirebaseFirestore.instance.collection('Saved');

    User _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
                future: _userRef.doc(_user.uid).collection('Saved').get(),
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

                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView(
                        padding: EdgeInsets.only(
                          top: 100,
                          bottom: 20,
                        ),
                        children: snapshot.data.docs.map((e) {
                          return FutureBuilder(
                            future: _productRef.doc(e.id).get(),
                            builder: (context, productSnap) {
                              if (productSnap.hasError) {
                                return Scaffold(
                                  body: Center(
                                    child: Text("Error ${productSnap.error}"),
                                  ),
                                );
                              }

                              if (productSnap.connectionState ==
                                  ConnectionState.done) {
                                Map _productSnap = productSnap.data.data();
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            _productSnap['image'],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _productSnap['name'],
                                              style: GoogleFonts.rosarivo(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Text(
                                                "\$ ${_productSnap['price']}",
                                                style: GoogleFonts.rosarivo(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Size : ${e.data()['size']}",
                                              style: GoogleFonts.rosarivo(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        }).toList());
                  }

                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
            CustomActionBar(
              "favorite",
              false,
            )
          ],
        ),
      ),
    );
  }
}
