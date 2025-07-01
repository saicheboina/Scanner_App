import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Export_Page/ListPage.dart';
import '../Camera_Screen/CameraPage.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails'; 

  final String upcCode; // Define a String variable to receive the UPC code

  ProductDetailsPage({
    required this.upcCode,
  }); // Constructor to receive the UPC code

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController stockCountController = TextEditingController();
  late TextEditingController upcCodeController; // Declare a late TextEditingController

  @override
  void initState() {
    super.initState();
    upcCodeController = TextEditingController(
      text: widget.upcCode,
    ); // Initialize the controller with the received UPC code
  }

  bool isValidInput(String value) {
    final RegExp specialChars = RegExp(r'[!@#%^&*(),.?":{}|<>]');
    return value.trim().isNotEmpty && !specialChars.hasMatch(value);
  }

  Future<void> _saveProductToStorage(String product) async {
    final prefs = await SharedPreferences.getInstance();
    final productsList = prefs.getStringList('products') ?? [];

    final List<String> productDetails = product.split(' - ');
    final String upcCode = productDetails[1];

    // Check for duplicate UPC codes
    if (productsList.any((element) => element.contains(upcCode))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Duplicate UPC Code"),
            content: Text("A product with the same Barcode code already exists."),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      productsList.add(product);
      prefs.setStringList('products', productsList);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListPage(savedProduct: product),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Detail",
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Product Name:",
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                hintText: "Enter Product Name",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "BarCode:",
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: upcCodeController,
              decoration: InputDecoration(
                hintText: "Enter BarCode",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Stock Count:",
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: stockCountController,
              keyboardType: TextInputType.number, // Only allow numbers
              decoration: InputDecoration(
                hintText: "Enter Stock Count",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
              child: Text("Save Details"),
              onPressed: () {
                // You can handle the save logic here
                String productName = productNameController.text;
                String upcCode = upcCodeController.text;
                String stockCount = stockCountController.text;

                // Validate input
                if (!isValidInput(productName) ||
                    !isValidInput(upcCode) ||
                    productName.trim().isEmpty ||
                    upcCode.trim().isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Input"),
                        content: Text("Product Name and BarCode cannot be empty or contain special characters."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Save logic here
                  _saveProductToStorage(
                    '$productName - $upcCode - $stockCount',
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt, color: Colors.black),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit, color: Colors.black),
          label: 'Product Detail',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note, color: Colors.black),
          label: 'List of Products',
        ),
      ],
      currentIndex: 1, // since this is the ProductDetailsPage
      selectedItemColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CameraPage(),
              ),
            );
            break;
          case 1:
            // Do nothing as we're already on the ProductDetailsPage
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ListPage(
                  savedProduct: '',
                ), // Pass the saved product details here
              ),
            );
            break;
        }
      },
    );
  }
}
