import 'dart:convert';
import 'package:dio/dio.dart';


class ApiSender {
  final String uri = "https://dummyjson.com/";

  Dio? dio;

  ApiSender() {
    dio = Dio();
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, Options? option}) async {   
    return await dio!.get(
      '$uri$path',
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }


  
}
