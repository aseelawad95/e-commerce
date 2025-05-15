part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class GetProductSuccess extends ProductState{
  List<Product> product = [];
  GetProductSuccess({required this.product});
}
class GetProductFailed extends ProductState{
  String msg;
  GetProductFailed({required this.msg});
}
class GetProductLoading extends ProductState{}