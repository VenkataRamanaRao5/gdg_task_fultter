import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

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
      debugShowCheckedModeBanner: false,
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
  final num price;
  final String category;
  final String imageURL;
  final num rate;
  final int count;

  factory Product.fromJson(Map<String, dynamic> json) {
    try{
      return Product(
              title: json["title"], 
              price: json["price"], 
              category: json["category"], 
              imageURL: json["image"], 
              rate: json["rating"]["rate"], 
              count: json["rating"]["count"]
            );
    } catch (e){
      throw Exception("Error in json $e");
    }
    
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
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 210.0,
          width: MediaQuery.of(context).size.width - 20,
          child: Stack(
            children: <Widget>[
              Container(
                color:Colors.white,
              ),
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
                      cardColor.withOpacity(0.15),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                      Flexible(child: Container(constraints: BoxConstraints(maxHeight: 12.0),)),
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor.withOpacity(0.90),
                          fontFamily: "Times New Roman"
                        ),
                      ),
                      Flexible(child: Container(constraints: BoxConstraints(maxHeight: 7.0),)),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontFamily: "Times New Roman"
                        ),
                      ),
                      Flexible(child: Container(constraints: BoxConstraints(maxHeight: 5.0),)),
                      Row(
                        children: [
                          ...List.generate(5, (int index) => 
                            (index + 1 <= product.rate.round()) ? Icon(Icons.star, color: starColor,)
                            : (index < product.rate) ? Icon(Icons.star_half, color: starColor) 
                            : Icon(Icons.star_border, color: starColor)
                          ),
                          Text(
                            " ${product.rate}  (${product.count})",
                            style: TextStyle(
                              color: textColor
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Product>> fetchProduct() async {
  final response = await http.get(
    Uri.parse("https://fakestoreapi.com/products/?limit=10")
  );

  if (response.statusCode == 200){
    List products = jsonDecode(response.body);
    print("${products.runtimeType}, ${products[0]["id"]}, ");
    return List<Product>.from(products.map((obj) => Product.fromJson(obj)));
  } else {
    throw Exception("Failed to load products");
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }
  
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
          child: FutureBuilder<List<Product>>(
            future: futureProduct, 
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.from(snapshot.data!.map((product) => ProductCard(product: product))),
                );
              } else if(snapshot.hasError) {
                return Text("Snapshot error: ${snapshot.error}");
              }

              return const CircularProgressIndicator();
            }
          )
        ),
        ),
    );
  }
}
