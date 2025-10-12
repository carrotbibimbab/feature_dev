import 'package:flutter/material.dart';
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
import 'package:bf_app/screens/analysis/latest_analysis_screen.dart';  // ✅ 추가
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/screens/analysis/analysis_log_screen.dart';
import 'package:bf_app/screens/intro/intro_screen.dart';
import 'package:bf_app/screens/analysis/face_detection_failed_screen.dart';

// ✅ Fade Transition을 위한 커스텀 페이지 빌더
CustomTransitionPage<void> _buildFadeTransitionPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // ✅ 정상 플로우: Splash → Onboarding → ...
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const SplashScreen(),
          state: state,
        ),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const OnboardingScreen(),
          state: state,
        ),
      ),

      // Permission
      GoRoute(
        path: '/permission',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const PermissionScreen(),
          state: state,
        ),
      ),

      // Login
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const LoginScreen(),
          state: state,
        ),
      ),

      // Profile Setup
      GoRoute(
        path: '/profile-setup',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const ProfileSetupScreen(),
          state: state,
        ),
      ),

      // Home (Main Dashboard)
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const HomeScreen(),
          state: state,
        ),
      ),

      // Welcome Screen after login
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const WelcomeScreen(),
          state: state,
        ),
      ),

      // My Page
      GoRoute(
        path: '/mypage',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const MyPageScreen(),
          state: state,
        ),
      ),

      // Profile Edit
      GoRoute(
        path: '/profile-edit',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const ProfileEditScreen(),
          state: state,
        ),
      ),

      // Analysis Start
      GoRoute(
        path: '/analysis-start',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const AnalysisStartScreen(),
          state: state,
        ),
      ),

      // Analyzing
      GoRoute(
        path: '/analyzing',
        pageBuilder: (context, state) {
          final imagePath = state.extra as String?;
          
          // ✅ imagePath가 없으면 분석 시작 화면으로 리다이렉트
          if (imagePath == null || imagePath.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(state.uri as BuildContext).go('/analysis-start');
            });
            return _buildFadeTransitionPage(
              child: const SizedBox(), // 빈 화면
              state: state,
            );
          }
          
          return _buildFadeTransitionPage(
            child: AnalyzingScreen(imagePath: imagePath),
            state: state,
          );
        },
      ),

      // Analysis Result
      GoRoute(
        path: '/analysis-result',
        pageBuilder: (context, state) {
          final result = state.extra as AnalysisResult?;
          
          // ✅ 실제 데이터가 없으면 홈으로 리다이렉트
          if (result == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(state.uri as BuildContext).go('/home');
            });
            return _buildFadeTransitionPage(
              child: const SizedBox(), // 빈 화면
              state: state,
            );
          }
          
          return _buildFadeTransitionPage(
            child: AnalysisResultScreen(result: result),
            state: state,
          );
        },
      ),

      // ✅ Latest Analysis (최근 분석 결과) - 새로 추가
      GoRoute(
        path: '/latest-analysis',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const LatestAnalysisScreen(),
          state: state,
        ),
      ),

      // Analysis Log
      GoRoute(
        path: '/analysis-log',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const AnalysisLogScreen(),
          state: state,
        ),
      ),

      // Intro Screen (첫 실행 시)
      GoRoute(
        path: '/intro',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const IntroScreen(),
          state: state,
        ),
      ),

      // Face Detection Failed Screen
      GoRoute(
        path: '/face-detection-failed',
        pageBuilder: (context, state) => _buildFadeTransitionPage(
          child: const FaceDetectionFailedScreen(),
          state: state,
        ),
      ),
    ],
  );
}