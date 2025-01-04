import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_x_api/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ApiService.fetchAllProducts();
    log('Fetching data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Flutter x API'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiService.fetchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data Available'),
            );
          } else {
            final products = snapshot.data;

            return ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final productDetials = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),

                  // container to show product details
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            productDetials.image.toString(),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        // column to show data
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Text(
                                productDetials.title.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              // description
                              Text(
                                productDetials.description.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // category
                              Text(
                                'Category: ${productDetials.category}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),

                              // price
                              Text(
                                'Price: ${productDetials.price}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
