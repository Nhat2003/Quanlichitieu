import 'package:expanse_management/domain/models/transaction_model.g.dart';
import 'package:expanse_management/presentation/screens/add_transaction.dart';
import 'package:expanse_management/presentation/screens/home.dart';
import 'package:expanse_management/presentation/screens/loginpage.dart';
import 'package:expanse_management/presentation/screens/setting_mode.dart';
import 'package:expanse_management/presentation/screens/sign_up_page.dart';
import 'package:expanse_management/presentation/widgets/bottom_navbar.dart';
import 'package:expanse_management/domain/models/category_model.dart';
import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:expanse_management/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'domain/models/transaction_model.g.dart';
Future<void> clearData() async {
  var path_provider;
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.deleteFromDisk();
}
Future main() async {
  initializeDateFormatting('vi_VN', null).then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey:'AIzaSyAglCYlvdENuXiZdzJWU1xmbuj3uk0O3Hg',
          appId: '1:1068911186584:android:561809eaee3297591336ed',
          messagingSenderId:'1068911186584',
          projectId: 'managerexpense-38813',
        )
    );
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<CategoryModel>('categories');
    await Firebase.initializeApp();
    runApp(MyApp());
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Settings(),
      child: Consumer<Settings>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: settings.darkMode ? ThemeData.dark() : ThemeData.light(),
            home: SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
            routes: {
              '/login': (context) => LoginPage(),
              '/signUp': (context) => SignUpPage(),
              '/home': (context) => Bottom(),

            },
          );
        },
      ),
    );
  }
}

