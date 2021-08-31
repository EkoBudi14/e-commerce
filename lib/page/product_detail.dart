part of 'page.dart';

class ProductDetail extends StatefulWidget {
  final String productId;
  final String scafold;
  ProductDetail({this.productId, this.scafold});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _productRef =
        FirebaseFirestore.instance.collection('Products');

    final CollectionReference _userRef =
        FirebaseFirestore.instance.collection('users');

    User _user = FirebaseAuth.instance.currentUser;
    String selectProductSize = "0";

    Future _addToCart() async {
      return _userRef
          .doc(_user.uid)
          .collection('Cart')
          .doc(widget.productId)
          .set(
        {
          "size": selectProductSize,
        },
      );
    }

    Future _saveToCart() async {
      return _userRef
          .doc(_user.uid)
          .collection('Saved')
          .doc(widget.productId)
          .set(
        {
          "size": selectProductSize,
        },
      );
    }

    final SnackBar _snackbar = SnackBar(content: Text("Product Add To cart"));
    final SnackBar _snackbar2nd =
        SnackBar(content: Text("Product Add To save"));

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _productRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("${snapshot.hasError}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData = snapshot.data.data();

                List productSize = documentData['size'];
                selectProductSize = productSize[0];
                return ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        documentData['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                documentData['name'],
                                style: GoogleFonts.rosarivo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "\$ ${documentData['price']}",
                                style: GoogleFonts.rosarivo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            documentData['desc'],
                            style: GoogleFonts.rosarivo(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Text(
                                "Select Size",
                                style: GoogleFonts.rosarivo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ProductSize(
                            productSize: productSize,
                            onSelect: (size) {
                              selectProductSize = size;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  await _addToCart();
                                  // ignore: deprecated_member_use
                                  Scaffold.of(context).showSnackBar(_snackbar);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                ),
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Add to cart",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    await _saveToCart();
                                    // ignore: deprecated_member_use
                                    Scaffold.of(context)
                                        // ignore: deprecated_member_use
                                        .showSnackBar(_snackbar2nd);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: Container(
                                    height: 40,
                                    child: Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar("Detail Product", true),
        ],
      ),
    );
  }
}
