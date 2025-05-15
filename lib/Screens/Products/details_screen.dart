import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Screens/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, this.product});
  final Product? product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: widget.product!.title!,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.product!.images != null && widget.product!.images!.isNotEmpty
              ? Image.network(
                  widget.product!.images!.first,
                  width: double.infinity,
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Description : ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: widget.product!.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Status : ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: widget.product!.availabilityStatus,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rating : ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                ...List.generate(5, (index) {
                  final rating = widget.product!.rating;
                  if (index < rating!.floor()) {
                    return const Icon(Icons.star,
                        color: Colors.amber, size: 20);
                  } else if (index < rating && rating - index > 0.5) {
                    return const Icon(Icons.star_half,
                        color: Colors.amber, size: 20);
                  } else {
                    return const Icon(Icons.star_border,
                        color: Colors.grey, size: 20);
                  }
                }),
                const SizedBox(width: 8),
                Text(
                  '(${widget.product!.rating})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Brand : ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                     text: widget.product!.brand ?? 'UnKnown',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
