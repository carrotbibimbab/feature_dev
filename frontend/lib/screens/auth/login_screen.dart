// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bf_app/config/app_config.dart';

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
  bool _isLoading = false;
  bool _shouldStartAnimation = true; // ⭐ 추가

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingLogin(); // ⭐ 순서 변경: 먼저 체크
  }

  // ⭐ 수정: 로그인 체크 후 애니메이션 시작 여부 결정
  void _checkExistingLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null && token.isNotEmpty) {
      print('🔑 기존 토큰 발견: ${token.substring(0, 20)}...');
      
      // ⭐ 애니메이션을 시작하지 않음
      _shouldStartAnimation = false;

      if (mounted) {
        // 즉시 프로필 설정으로 이동
        context.go('/profile-setup');
      }
    } else {
      print('🔍 저장된 토큰 없음 - 로그인 필요');
      
      // ⭐ 토큰이 없을 때만 애니메이션 시작
      if (mounted) {
        _startAnimationSequence();
      }
    }
  }

  void _initializeAnimations() {
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

  // ⭐ mounted 체크 추가
  void _startAnimationSequence() async {
    // "Welcome to" 먼저 표시
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return; // ⭐ 체크
    _welcomeController.forward();

    // 400ms 후 "BF" 표시
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return; // ⭐ 체크
    _bfController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _bfController.dispose();
    super.dispose();
  }

  // 🔥 개발자 모드 로그인 (Mock)
  void _handleDevLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', AppConfig.mockJwtToken);
      await prefs.setString('user_sub', AppConfig.testUser['sub']!);
      await prefs.setString('user_email', AppConfig.testUser['email']!);
      await prefs.setString('user_name', AppConfig.testUser['name']!);

      print('🔧 개발자 모드 로그인 완료');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('개발자 모드로 로그인했습니다'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
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

  // 🔥 구글 로그인 (조건부 처리)
  void _handleGoogleSignIn() async {
    if (_isLoading) return;

    // 🔥 개발 모드에서는 경고 표시
    if (AppConfig.isDevelopmentMode) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('구글 로그인 불가'),
          content: const Text(
            'Android WebView에서는 구글 로그인이 차단됩니다.\n\n'
            '아래 옵션 중 하나를 선택하세요:\n\n'
            '1. "개발자 모드" 버튼 사용 (권장)\n'
            '2. Chrome 웹 브라우저에서 테스트\n'
            '3. 실제 기기에서 테스트',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleDevLogin();
              },
              child: const Text('개발자 모드 사용'),
            ),
          ],
        ),
      );
      return;
    }

    // 🔥 실제 환경: WebView 로그인 시도
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const BackendLoginWebView(
            loginUrl: 'https://beautyfinder-l2pt.onrender.com/login',
          ),
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success == true) {
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

          // 🔥 개발 모드 배지
          if (AppConfig.showDevBadge)
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🔧 DEV MODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // 중앙 텍스트 애니메이션
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

          // 하단 버튼들
          Positioned(
            left: 47,
            right: 47,
            top: 690,
            child: Column(
              children: [
                // 🔥 개발자 모드 버튼
                if (AppConfig.isDevelopmentMode)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleDevLogin,
                      icon: const Icon(Icons.developer_mode, color: Colors.white),
                      label: const Text(
                        '개발자 모드로 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),

                // 구글 로그인 버튼
                GestureDetector(
                  onTap: _isLoading ? null : _handleGoogleSignIn,
                  child: Opacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    child: Image.asset(
                      'assets/4/startwithgoogle.png',
                      width: 300,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 로딩 인디케이터
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),

          // 약관 동의 문구
          Positioned(
            left: 70,
            top: 790,
            right: 70,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'NanumSquareNeo',
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

            if (url.contains('/profile')) {
              print('🎉 로그인 성공 감지!');
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

      final result = await _controller.runJavaScriptReturningResult('''
        (async function() {
          try {
            const response = await fetch('https://beautyfinder-l2pt.onrender.com/auth/google/jwt', {
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        print('✅ JWT 토큰 저장 완료: ${token.substring(0, 20)}...');

        if (mounted) {
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