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
}

class ProductCard extends StatelessWidget {
  ProductCard({super.key, required this.product});

  final Product product;

  final Color starColor = Colors.amber.shade400;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary
          ),
          borderRadius: BorderRadius.circular(15.0),
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
              SizedBox(
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 7,),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          ...List.generate(5, (int index) => 
                            (index + 1 <= product.rate.round()) ? Icon(Icons.star, color: starColor,)
                            : (index < product.rate) ? Icon(Icons.star_half, color: starColor) 
                            : Icon(Icons.star_border, color: starColor)
                          ),
                          Text(
                            "${product.rate}  (${product.count})"
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
