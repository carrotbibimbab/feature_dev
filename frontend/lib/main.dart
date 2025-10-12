// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';  // ✨ 추가
import 'package:bf_app/constants/colors.dart';
import 'package:bf_app/utils/router_config.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:bf_app/providers/auth_provider.dart';
import 'package:bf_app/providers/analysis_provider.dart';  // ✨ 추가

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase 초기화
  await SupabaseConfig.initialize();

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 세로 방향 고정 (선택사항)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const BFApp());
}

class BFApp extends StatelessWidget {
  const BFApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✨ MultiProvider로 앱 전체 감싸기
    return MultiProvider(
      providers: [
        // 인증 관련 Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        
        // // 사용자 프로필 관련 Provider
        // ChangeNotifierProvider(
        //   create: (_) => UserProvider(),
        // ),
        
        // ✨ 분석 관련 Provider (GPT 통합)
        ChangeNotifierProvider(
          create: (_) => AnalysisProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'BF - 뷰파',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.logoRed,
          ),
          fontFamily: 'NanumSquareNeo',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.black),
            titleTextStyle: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'NanumSquareNeo',
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'NanumSquareNeo',
              ),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}