import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_details/ProductDetailsPage.dart';
import '../Export_Page/ListPage.dart';

class CameraPage extends StatefulWidget {
  static const String routeName = '/camera'; // Define route name

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String barcode = "";
  List<String> Temp_barcode_value = []; // Create a list to store scanned barcodes

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#000000",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
      if (barcodeScanRes == "-1") {
        barcodeScanRes = "Failed to get the barcode.";
      }
      setState(() {
        barcode = barcodeScanRes;
      });

      final prefs = await SharedPreferences.getInstance();
      final productsList = prefs.getStringList('products') ?? [];

      // Check if the product with the same UPC code already exists
      if (productsList.any((element) => element.contains(barcode))) {
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
        // Redirect to ProductDetailsPage with the scanned data if no duplicates found
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              upcCode: barcode, // Pass the scanned barcode data to the ProductDetailsPage
            ),
          ),
        );
      }
      print("Scanned Barcode is: $barcode"); // Print the scanned barcode list
    } catch (e) {
      setState(() {
        barcode = "Failed to get the barcode.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camera Page",
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () => scanBarcode(),
              child: Text("Scan Barcode"),
            ),
            SizedBox(height: 20),
            Text(
              "Scanned Barcode: $barcode",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: 'Product Detail',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'List of Products',
        ),
      ],
      currentIndex: 0, // since this is the CameraPage
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(upcCode: barcode),
              ),
            ); // Pass the UPC code here
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ListPage(savedProduct: ''),
              ),
            );
            break;
        }
      },
    );
  }
}
