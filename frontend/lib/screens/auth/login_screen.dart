// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late AnimationController _bfController;
  late Animation<double> _welcomeOpacity;
  late Animation<double> _bfOpacity;
  bool _isLoading = false; // 🔥 로딩 상태 추가
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // "Welcome to" 애니메이션
    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _welcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeController,
        curve: Curves.easeIn,
      ),
    );

    // "BF" 애니메이션
    _bfController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bfOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bfController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimationSequence() async {
    // "Welcome to" 먼저 표시
    await Future.delayed(const Duration(milliseconds: 300));
    _welcomeController.forward();

    // 400ms 후 "BF" 표시
    await Future.delayed(const Duration(milliseconds: 400));
    _bfController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _bfController.dispose();
    super.dispose();
  }

  // 🔥 백엔드 OAuth 로그인 구현
  void _handleGoogleSignIn() async {
    if (_isLoading) return; // 중복 클릭 방지

    setState(() {
      _isLoading = true;
    });

    try {
      // 백엔드 로그인 WebView 열기
      final success = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const BackendLoginWebView(
            loginUrl: 'https://backend-6xc5.onrender.com/login',
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success == true) {
          // 로그인 성공 시 프로필 설정 화면으로 이동
          context.go('/profile-setup');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/4/background1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 중앙 텍스트 애니메이션
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "Welcome to" (먼저 나타남)
                FadeTransition(
                  opacity: _welcomeOpacity,
                  child: const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                // "BF" (시간차로 나타남)
                FadeTransition(
                  opacity: _bfOpacity,
                  child: const Text(
                    'BF',
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 구글 로그인 버튼
          Positioned(
            left: 47,
            top: 709,
            child: GestureDetector(
              onTap: _isLoading ? null : _handleGoogleSignIn, // 🔥 로딩 중 비활성화
              child: Opacity(
                opacity: _isLoading ? 0.5 : 1.0, // 🔥 로딩 중 흐리게
                child: Image.asset(
                  'assets/4/startwithgoogle.png',
                  width: 300,
                  height: 50,
                ),
              ),
            ),
          ),

          // 🔥 로딩 인디케이터
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),

          // 최하단 약관 동의 문구
          Positioned(
            left: 70,
            top: 790,
            right: 70,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 11,
                  color: Color(0xFF000000),
                ),
                children: [
                  TextSpan(text: '첫 로그인 시 '),
                  TextSpan(
                    text: '개인정보처리방침',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  TextSpan(text: ' 및 '),
                  TextSpan(
                    text: '이용약관',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  TextSpan(text: ' 동의로 간주합니다.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 🔥 백엔드 로그인 WebView
// ============================================================
class BackendLoginWebView extends StatefulWidget {
  final String loginUrl;

  const BackendLoginWebView({super.key, required this.loginUrl});

  @override
  State<BackendLoginWebView> createState() => _BackendLoginWebViewState();
}

class _BackendLoginWebViewState extends State<BackendLoginWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('🌐 페이지 로딩 시작: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            print('✅ 페이지 로딩 완료: $url');

            // 프로필 페이지로 리디렉트되었으면 로그인 성공
            if (url.contains('/profile')) {
              print('🎉 로그인 성공 감지!');
              // JWT 토큰 가져오기
              await _fetchJwtToken();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print('📍 네비게이션 요청: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loginUrl));
  }

  Future<void> _fetchJwtToken() async {
    try {
      print('🔑 JWT 토큰 요청 중...');

      // 백엔드에서 JWT 토큰 발급 요청
      final result = await _controller.runJavaScriptReturningResult('''
        (async function() {
          try {
            const response = await fetch('https://backend-6xc5.onrender.com/auth/google/jwt', {
              method: 'POST',
              credentials: 'include'
            });
            const data = await response.json();
            return data.access_token || null;
          } catch (err) {
            console.error('JWT 요청 에러:', err);
            return null;
          }
        })();
      ''');

      print('📦 JWT 응답: $result');

      if (result != null && result.toString() != 'null' && result.toString().isNotEmpty) {
        final token = result.toString().replaceAll('"', '');
        
        // SharedPreferences에 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        print('✅ JWT 토큰 저장 완료: ${token.substring(0, 20)}...');

        if (mounted) {
          // 로그인 성공
          Navigator.pop(context, true);
        }
      } else {
        print('⚠️ JWT 토큰이 없습니다');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('토큰 발급 실패. 다시 시도해주세요.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ JWT 토큰 가져오기 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 처리 중 오류: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구글 로그인'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('로그인 페이지 로딩 중...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}