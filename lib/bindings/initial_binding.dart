import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../repository/repository.dart';
import '../services/services.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final productService = ProductService();
    final bannerService = BannerService(productService);
    final userService = UserService();
    final authService = AuthService();
    final orderService = OrderService();

    final productRemoteRepository = ProductRemoteRepository(productService);
    final bannerRemoteRepository = BannerRemoteRepository(bannerService);
    final authRemoteRepository = AuthRemoteRepository(authService);
    final orderRemoteRepository = OrderRemoteRepository(orderService);

    final authLocalRepository = AuthLocalRepository();
    final userLocalRepository = UserLocalRepository();
    final cartLocalRepository = CartLocalRepository();
    final cartProductsLocalRepository = CartProductsLocalRepository();
    final favoriteLocalRepository = FavoriteLocalRepository();
    final orderLocalRepository = OrderLocalRepository();

    final authRepository =
        AuthRepository(authLocalRepository, authRemoteRepository);
    Get.put(authRepository);

    final productRepository = ProductRepository(productRemoteRepository);
    Get.put(productRepository);

    final categoryRepository = CategoryRepository();
    Get.put(categoryRepository);

    final bannerRepository = BannerRepository(bannerRemoteRepository);
    Get.put(bannerRepository);

    final userRepository =
        UserRepository(userLocalRepository, UserRemoteRepository(userService));
    Get.put(userRepository);

    final cartRepository =
        CartRepository(cartLocalRepository, cartProductsLocalRepository);
    Get.put(cartRepository);

    final favoritosRepository = FavoritosRepository(favoriteLocalRepository);
    Get.put(favoritosRepository);

    final orderRepository =
        OrderRepository(orderLocalRepository, orderRemoteRepository);
    Get.put(orderRepository);

    Get.put(MainNavigationController());
    Get.put(ProductController(productRepository: productRepository));
    Get.put(HomeController(
      bannerRepository: bannerRepository,
      categoryRepository: categoryRepository,
      productRepository: productRepository,
    ));
    Get.put(UserController(userRepository: userRepository));
    Get.put(CartController(cartRepository: cartRepository));
    Get.put(FavoritosController(favoritosRepository: favoritosRepository));
    Get.put(AuthController(authRepository: authRepository));
    Get.put(CategoryController(categoryRepository: categoryRepository));
    Get.put(OrderController(orderRepository: orderRepository));

    final box = GetStorage();
    String? userJson = box.read('usuario');

    if (userJson != null) {
      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      Get.find<UserController>().user.value = user;
      Get.find<AuthController>().logado.value = true;

      Get.find<FavoritosController>().loadFavoritosForUser(user.id);
      Get.find<CartController>().loadCartForUser(user.id);
      Get.find<OrderController>().fetchOrdersForUser(user.id);
    }
  }
}
