import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Product {
  const Product({
    required this.title,
    required this.price,
    required this.category,
    required this.imageURL,
    required this.rate,
    required this.count
  });

  final String title;
  final double price;
  final String category;
  final String imageURL;
  final double rate;
  final int count;
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width - 20,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  height: 176,
                  child: Image.network(
                    product.imageURL,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    '${product.price}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Products"),
      ),
      body: const Center(
        child: ProductCard(product: Product(title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops", price: 109.95, category:  "men's clothing", imageURL: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg", rate: 3.9, count: 120)),
        ),
    );
  }
}
