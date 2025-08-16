import 'package:get/get.dart';
import 'package:state_management_practice/app/bindings/home_binding.dart';
import '../../../presentation/pages/auth/views/forgot_password_view.dart';
import '../../../presentation/pages/auth/views/login_view.dart';
import '../../../presentation/pages/auth/views/signup_view.dart';
import '../../../presentation/pages/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = AppRoutes.login;

  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.signup, page: () => const SignUpView()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
