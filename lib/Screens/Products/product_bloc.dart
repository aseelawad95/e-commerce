import 'package:bloc/bloc.dart';
import 'package:e_commerce/Core/repository/productRepo.dart';
import 'package:e_commerce/Models/product.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository;
  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit)async {
      if(event is GetProductEvent)
        {
          emit(GetProductLoading());
          var res = await productRepository.getProducts();
          res.fold((f)=>emit(GetProductFailed(msg: f.toString())), (success)=>emit(GetProductSuccess(product: success)));
        }
    });
  }
}
