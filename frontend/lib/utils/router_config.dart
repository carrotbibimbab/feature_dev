import 'package:go_router/go_router.dart';
import 'package:bf_app/screens/splash/splash_screen.dart';
import 'package:bf_app/screens/onboarding/onboarding_screen.dart';
import 'package:bf_app/screens/permission/permission_screen.dart';
import 'package:bf_app/screens/auth/login_screen.dart';
import 'package:bf_app/screens/auth/profile_setup_screen.dart';
import 'package:bf_app/screens/auth/welcome_screen.dart';
import 'package:bf_app/screens/home/home_screen.dart';
import 'package:bf_app/screens/mypage/mypage_screen.dart';
import 'package:bf_app/screens/mypage/profile_edit_screen.dart';
import 'package:bf_app/screens/analysis/analysis_start_screen.dart';
import 'package:bf_app/screens/analysis/analyzing_screen.dart';
import 'package:bf_app/screens/analysis/analysis_result_screen.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/screens/analysis/analysis_log_screen.dart';
import 'package:bf_app/screens/intro/intro_screen.dart';
import 'package:bf_app/screens/analysis/face_detection_failed_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Permission
      GoRoute(
        path: '/permission',
        builder: (context, state) => const PermissionScreen(),
      ),

      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Profile Setup
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Home (Main Dashboard)
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Welcome Screen after login
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // My Page
      GoRoute(
        path: '/mypage',
        builder: (context, state) => const MyPageScreen(),
      ),

      // Profile Edit
      GoRoute(
        path: '/profile-edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),

      // Analysis Start
      GoRoute(
        path: '/analysis-start',
        builder: (context, state) => const AnalysisStartScreen(),
      ),

      GoRoute(
        path: '/analyzing',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return AnalyzingScreen(imagePath: imagePath);
        },
      ),

      // Analysis Result
      GoRoute(
        path: '/analysis-result',
        builder: (context, state) {
          final result = state.extra as AnalysisResult;
          return AnalysisResultScreen(result: result);
        },
      ),

      // Analysis Log
      GoRoute(
        path: '/analysis-log',
        builder: (context, state) => const AnalysisLogScreen(),
      ),

      // Intro Screen (첫 실행 시)
      GoRoute(
        path: '/intro',
        builder: (context, state) => const IntroScreen(),
      ),

      // Face Detection Failed Screen
      GoRoute(
        path: '/face-detection-failed',
        builder: (context, state) => const FaceDetectionFailedScreen(),
      ),
    ],
  );
}

// TODO: 나중에 구현할 화면들
// GoRoute(
//   path: '/latest-analysis',
//   builder: (context, state) => const LatestAnalysisScreen(),
// ),
