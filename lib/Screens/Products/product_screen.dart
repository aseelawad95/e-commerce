import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Screens/Products/details_screen.dart';
import 'package:e_commerce/Screens/Products/product_bloc.dart';
import 'package:e_commerce/Screens/widgets/text_widget.dart';
import 'package:e_commerce/Core/Service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.userName});
  final String? userName;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UserService userService = UserService();
  int _selectedIndex = 0;
  TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<Product> cartProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterProducts);
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
    _loadCart();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterProducts() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product.title!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cart') ?? [];

    final productMap = product.toJson();
    final encodedProduct = jsonEncode(productMap);

    cartData.add(encodedProduct);
    await prefs.setStringList('cart', cartData);

    setState(() {
      cartProducts.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to cart')),
    );
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cart') ?? [];
    setState(() {
      cartProducts = cartData
          .map((item) => Product.fromJson(jsonDecode(item)))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      buildProductPage(),
      buildCartPage(),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userService.logOut(context);
            },
          ),
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
          : AppBar(title: const Text("Your Cart")),
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
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                },
              )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is GetProductSuccess) {
                setState(() {
                  isLoading = false;
                  allProducts = state.product;
                  filteredProducts = state.product;
                });
              } else if (state is GetProductFailed) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: buildProductCard(product, context),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildCartPage() {
    return cartProducts.isEmpty
        ? const Center(child: Text('Cart is empty'))
        : ListView.builder(
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        final product = cartProducts[index];
        return ListTile(
          leading: product.images != null && product.images!.isNotEmpty
              ? Image.network(product.images!.first, width: 50, height: 50)
              : const SizedBox(width: 50, height: 50),
          title: Text(product.title!),
          subtitle: Text("${product.price} \$"),
        );
      },
    );
  }

  Widget buildProductCard(Product product, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double priceFontSize = screenWidth * 0.03;
    double titleFontSize = screenWidth * 0.035;

    return Container(
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
            child: product.images != null && product.images!.isNotEmpty
                ? Center(
              child: Image.network(
                product.images!.first,
                width: 100,
              ),
            )
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
                  bottomLeft: Radius.circular(70),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TextWidget(
                    textAlign: TextAlign.center,
                    fontSize: priceFontSize,
                    color: Colors.white,
                    text: "\$${product.price}",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              onPressed: () => _addToCart(product),
              icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: TextWidget(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                text: product.title!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}