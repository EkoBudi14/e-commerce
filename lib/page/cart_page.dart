part of 'page.dart';

class CartPage extends StatelessWidget {
  // final CollectionReference _userRef =
  //     FirebaseFirestore.instance.collection('Cart');

  @override
  Widget build(BuildContext context) {
    final CollectionReference _userRef =
        FirebaseFirestore.instance.collection('users');

    final CollectionReference _productRef =
        FirebaseFirestore.instance.collection('Products');

    User _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _userRef.doc(_user.uid).collection('Cart').get(),
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
                                        borderRadius: BorderRadius.circular(12),
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
            'Cart',
            true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black87,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price : ",
                          style: GoogleFonts.rosarivo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "0",
                          style: GoogleFonts.rosarivo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
