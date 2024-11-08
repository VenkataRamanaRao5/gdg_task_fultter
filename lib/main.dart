import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int _,
        "title": String title,
        "price": double price,
        "description": String _,
        "category": String category,
        "image": String imageURL,
        "rating": {
          "rate": double rate,
          "count": int count
        }
      } => Product(
            title: title, 
            price: price, 
            category: category, 
            imageURL: imageURL, 
            rate: rate, 
            count: count
          ),
      _ => throw const FormatException("Failed to load JSON"),
    };
  }
}

class ProductCard extends StatelessWidget {
  ProductCard({super.key, required this.product});

  final Product product;

  final Color starColor = Colors.amber.shade400;
  final Color cardColor = Colors.black38;
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 200.0,
          width: MediaQuery.of(context).size.width - 20,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    height: 176,
                    child: Image.network(
                      product.imageURL,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      cardColor.withOpacity(1),
                      cardColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 9,),
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 7,),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                          ...List.generate(5, (int index) => 
                            (index + 1 <= product.rate.round()) ? Icon(Icons.star, color: starColor,)
                            : (index < product.rate) ? Icon(Icons.star_half, color: starColor) 
                            : Icon(Icons.star_border, color: starColor)
                          ),
                          Text(
                            "${product.rate}  (${product.count})",
                            style: TextStyle(
                              color: textColor
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: ProductCard(product: const Product(title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops", price: 109.95, category:  "men's clothing", imageURL: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg", rate: 4.4, count: 120))
        ),
        ),
    );
  }
}
