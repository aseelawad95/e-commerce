import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../../Models/product.dart';
import '../Api/api_function.dart';

class ProductRepository {
  Future<Either<dynamic,List<Product>>> getProducts() async {
    try {
      Response response = await ApiSender().get('products');
      if (response.statusCode == 200) {
        var data = response.data;
        List<Product> loadedProducts = [];
        for (var item in data['products']) {
          loadedProducts.add(Product.fromJson(item));
        }
        return Right(loadedProducts);
      }else
        {
          return Left(response.data['message']);
        }
    } on DioException catch (e) {

      if (e.response != null) {
        dynamic errorData = e.response?.data;
        if (errorData != null && errorData.containsKey('errors')) {
          List<dynamic> errorMessages = [];
          errorData['errors'].forEach((key, value) {
            errorMessages.addAll(value);
          });
        }
        return Left(errorData);
      } else {
        return Left("Unexpected error: $e");

      }
    }
  }
}
