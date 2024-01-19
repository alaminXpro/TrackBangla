import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/blocs/blog_bloc.dart';
import 'package:trackbangla/blocs/bookmark_bloc.dart';
import 'package:trackbangla/blocs/comments_bloc.dart';
import 'package:trackbangla/blocs/featured_bloc.dart';
import 'package:trackbangla/blocs/internet_bloc.dart';
import 'package:trackbangla/blocs/notification_bloc.dart';
import 'package:trackbangla/blocs/other_places_bloc.dart';
import 'package:trackbangla/blocs/popular_places_bloc.dart';
import 'package:trackbangla/blocs/recent_places_bloc.dart';
import 'package:trackbangla/blocs/recommanded_places_bloc.dart';
import 'package:trackbangla/blocs/search_bloc.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/blocs/sp_state_one.dart';
import 'package:trackbangla/blocs/sp_state_two.dart';
import 'package:trackbangla/blocs/state_bloc.dart';
import 'package:trackbangla/core/utils/initial_bindings.dart';
import 'package:trackbangla/firebase_options.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:trackbangla/widgets/other_places.dart';


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
        ChangeNotifierProvider<BlogBloc>( create: (context) => BlogBloc(),),
        ChangeNotifierProvider<InternetBloc>(create: (context) => InternetBloc(),),
        ChangeNotifierProvider<SignInBloc>(create: (context) => SignInBloc(),),
        ChangeNotifierProvider<CommentsBloc>(create: (context) => CommentsBloc(),),
        ChangeNotifierProvider<BookmarkBloc>(create: (context) => BookmarkBloc(),),
        ChangeNotifierProvider<PopularPlacesBloc>(create: (context) => PopularPlacesBloc(),),
        ChangeNotifierProvider<RecentPlacesBloc>(create: (context) => RecentPlacesBloc(),),
        ChangeNotifierProvider<RecommandedPlacesBloc>(create: (context) => RecommandedPlacesBloc(),),
        ChangeNotifierProvider<FeaturedBloc>(create: (context) => FeaturedBloc(),),
        ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
        ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        ChangeNotifierProvider<StateBloc>(create: (context) => StateBloc()),
        ChangeNotifierProvider<SpecialStateOneBloc>(create: (context) => SpecialStateOneBloc()),
        ChangeNotifierProvider<SpecialStateTwoBloc>(create: (context) => SpecialStateTwoBloc()),
        ChangeNotifierProvider<OtherPlacesBloc>(create: (context) => OtherPlacesBloc()),
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