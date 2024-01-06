import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/blocs/internet_bloc.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/core/utils/initial_bindings.dart';
import 'package:trackbangla/firebase_options.dart';
import 'package:trackbangla/pages/splash.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      useOnlyLangCode: true,
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InternetBloc>(create: (context) => InternetBloc(),),
        ChangeNotifierProvider<SignInBloc>(create: (context) => SignInBloc(),)
      ],
      child: GetMaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Track Bangla',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: AppRoutes.onBoarding,
        getPages: AppRoutes.pages,
        initialBinding: InitialBindings(),
      ),
    );
  }
}

// width: 360
// height: 687
