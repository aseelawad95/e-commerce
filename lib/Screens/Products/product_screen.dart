// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:e_commerce/Core/Api/api_function.dart';
import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Screens/Products/details_screen.dart';
import 'package:e_commerce/Screens/widgets/responsive.dart';
import 'package:e_commerce/Screens/widgets/text_widget.dart';
import 'package:e_commerce/Service/user_service.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.userName});
  final String? userName;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UserService userService = UserService();
  List<Product> productList = [];
  List<Product> filteredList = [];
  int _selectedIndex = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProducs();
   searchController.addListener(filterProducts);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = productList
          .where((product) => product.title
              .toLowerCase()
              .contains(query)) 
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      buildProductPage(),
      const Center(child: Text('Cart', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
            actions: [
              IconButton(icon: const Icon(Icons.logout),onPressed: () async{
                await userService.logOut(context);
              },),
            ],
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Hi,',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    TextWidget(
                      text: widget.userName ?? '',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Cart',
          ),
         
        ],
      ),
    );
  }

  Widget buildProductPage() {
    if (productList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search by product name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                children: (filteredList.isEmpty ? productList : filteredList).map((product) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      width: ResponsiveSize(
                              sm: 160, xs: 160, lg: 170, md: 170, xl: 170)
                          .build(context)!,
                      height: ResponsiveSize(
                              sm: 150, xs: 180, lg: 170, md: 170, xl: 170)
                          .build(context)!,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: product.images != null &&
                                    product.images!.isNotEmpty
                                ? Center(
                                    child: Image.network(product.images!.first,
                                        width: 130))
                                : const SizedBox(),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(70)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TextWidget(
                                    textAlign: TextAlign.center,
                                    fontSize: 10,
                                    color: Colors.white,
                                    text: "\$${product.price}",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {},
                              icon: Container(
                                width: 30,
                                height: 30,
                                decoration:
                                    const BoxDecoration(color: Colors.green),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextWidget(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                text: product.title,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> getProducs() async {
    try {
      Response response = await ApiSender().get('products');

      if (response.statusCode == 200) {
        var data = response.data;

         List<Product> loadedProducts = [];

        for (var item in data['products']) {
          Product product = Product.fromJson(item);
          loadedProducts.add(product);
        }

        setState(() {
          productList = loadedProducts;
          filteredList = loadedProducts;
        });

      }
    } on DioException catch (e) {
      print(e.response?.statusCode);
      print(e);
      if (e.response != null) {
        dynamic errorData = e.response?.data;

        if (errorData != null && errorData.containsKey('errors')) {
          List<dynamic> errorMessages = [];
          errorData['errors'].forEach((key, value) {
            errorMessages.addAll(value);
          });
        }
      } else {
        print(e.message);
      }
    }
  }
}
