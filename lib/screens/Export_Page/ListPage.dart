import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share/share.dart';
import '../Camera_Screen/CameraPage.dart';
import '../product_details/ProductDetailsPage.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  static const String routeName = '/export'; // Define route name

  final String savedProduct;

  ListPage({required this.savedProduct});

  @override
  _ListPageState createState() => _ListPageState();
}

class ProductSearchDelegate extends SearchDelegate<String?> {
  final List<String> productsList;
  final Function(String) onSelected;

  ProductSearchDelegate(this.productsList, {required this.onSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = productsList
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = productsList
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            onSelected(suggestions[index]);
          },
        );
      },
    );
  }
}

class _ListPageState extends State<ListPage> {
  List<String> products = [];
  late TextEditingController productNameController;
  late TextEditingController upcCodeController;
  late TextEditingController stockCountController;
  bool editMode = false;

  void _handleSearchResultSelection(String selectedProduct) {
    Navigator.pop(context); // Close the search view
    int index = products.indexOf(
        selectedProduct); // Find the index of the product in the main list
    if (index != -1) {
      _enableEditMode(index);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProductsFromStorage();
    productNameController = TextEditingController();
    upcCodeController = TextEditingController();
    stockCountController = TextEditingController();
  }

  void _saveProductToStorage(String product) async {
    final prefs = await SharedPreferences.getInstance();
    final productsList = prefs.getStringList('products') ?? [];

    if (products.contains(product)) {
      products[products.indexOf(product)] = product;
    } else {
      products.add(product);
    }

    final updatedProductsList = products.toSet().toList();
    prefs.setStringList('products', updatedProductsList);
  }

  void _loadProductsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final productsList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productsList.toSet().toList();
    });
  }

  void _removeProductFromStorage(String product) async {
    final prefs = await SharedPreferences.getInstance();
    final productsList = prefs.getStringList('products') ?? [];

    productsList.remove(product);
    prefs.setStringList('products', productsList);
  }

  void _enableEditMode(int index) {
    productNameController.text = products[index].split(' - ')[0];
    upcCodeController.text = products[index].split(' - ')[1];
    stockCountController.text = products[index].split(' - ')[2];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: upcCodeController,
                readOnly: true, // Make the TextField non-editable
                decoration: InputDecoration(
                  labelText: 'UPC Code',
                ),
              ),
              TextField(
                controller: stockCountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly // Only allows input of digits
                ],
                decoration: InputDecoration(
                  labelText: 'Stock Count',
                  hintText: "Stock Count",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    // Black underline
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    // Black underline when focused
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  products[index] =
                      '${productNameController.text} - ${upcCodeController.text} - ${stockCountController.text}';
                  _saveProductToStorage(products[index]);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List of Products",
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products,
                  onSelected: _handleSearchResultSelection,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final item = products[index];
            return Dismissible(
              key: Key(item),
              confirmDismiss: (direction) =>
                  _showConfirmationDialog(context, item),
              onDismissed: (direction) {
                setState(() {
                  products.removeAt(index);
                  _removeProductFromStorage(item);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item Deleted')));
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  products[index],
                  style: const TextStyle(color: Colors.black),
                ),
                leading: const Icon(Icons.label, color: Colors.black),
                trailing: editMode
                    ? IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () => _saveChanges(index),
                      )
                    : IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _enableEditMode(index),
                      ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportToCSV,
        child: Icon(
          Icons.cloud_download,
          color: Colors.white, // Set the color of the cloud icon to white
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String productData) async {
    List<String> productDetails = productData.split(' - ');
    String productName = productDetails[0];
    String upcCode = productDetails[1];
    String stockCount = productDetails[2];

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Product Name: $productName",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "UPC Code: $upcCode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Stock Count: $stockCount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("Are you sure you want to delete this item?"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
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
      currentIndex: 2,
      selectedItemColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CameraPage()));
            break;
          case 1:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(upcCode: '')));
            break;
          case 2:
            break;
        }
      },
    );
  }

  void _enableEditModeForProduct(int index) {
    List<String> productDetails = products[index].split(' - ');
    productNameController.text = productDetails[0];
    upcCodeController.text =
        productDetails[1]; // Set UPC code, but disable editing
    stockCountController.text = productDetails[2];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false, // Disable editing for UPC code
                      controller: upcCodeController,
                      decoration: InputDecoration(labelText: 'UPC Code'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: stockCountController,
                      decoration: InputDecoration(labelText: 'Stock Count'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly // Only allows input of digits
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  products[index] =
                      '${productNameController.text} - ${upcCodeController.text} - ${stockCountController.text}';
                  _saveProductToStorage(products[index]);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges(int index) {
    setState(() {
      products[index] =
          '${productNameController.text} - ${upcCodeController.text} - ${stockCountController.text}';
      _removeProductFromStorage(products[index]);
      _saveProductToStorage(products[index]);
      editMode = false;
    });
  }

  void _exportToCSV() async {
    List<List<dynamic>> rows = [];
    rows.add(["UPC Code", "Product Name", "Stock Count"]); // Header row
    for (var product in products) {
      List<String> productDetails = product.split(' - ');
      rows.add(productDetails);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/Products.csv');
    await file.writeAsString(csvData);

    // Share the file
    Share.shareFiles([file.path]);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File exported and shared from $dir/Products.csv')));

    // Send data to Google Sheets
    for (var product in products) {
      var productDetails = product.split(' - ');
      var request = ProductData(
        upcCode: productDetails[0],
        productName: productDetails[1],
        stockCount: productDetails[2],
      );
      await doPost(request);
    }
  }

  Future<void> doPost(ProductData request) async {
    var url =
        'https://script.google.com/macros/s/AKfycbzJK_YU_mQkPV46Ug7rHO2Jc1RoykdF5n6aWH9dIhOGkiOykErKg1RWDdlX4W1rrLg/exec'; // Replace with your Google Sheets endpoint
    var response = await http.post(Uri.parse(url), body: request.toJson());
    if (response.statusCode == 200) {
      if (response.body.contains('Success')) {
        print('Data successfully sent to Google Sheets');
      } else {
        print('UPC code does not exist in Google Sheets. Data not saved.');
      }
    } else {
      print('Error occurred while sending data to Google Sheets');
    }
  }
}

class ProductData {
  final String upcCode;
  final String productName;
  final String stockCount;
  final String imageUrl; // Add this if you plan to send image URLs

  ProductData({
    required this.upcCode,
    required this.productName,
    required this.stockCount,
    this.imageUrl =
        '', // Initialize with a default empty string if imageUrl is optional
  });

  Map<String, dynamic> toJson() {
    return {
      'upcCode': upcCode,
      'productName': productName,
      'stockCount': stockCount,
      'imageUrl': imageUrl, // Include this if necessary
    };
  }
}
