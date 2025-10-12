// lib/screens/mypage/mypage_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/auth_service.dart';
import 'package:bf_app/models/user_profile.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _dataService = SupabaseDataService();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  UserProfile? _profile;
  AnalysisResult? _latestAnalysis;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _dataService.getCurrentUserProfile();
    final analysis = await _dataService.getLatestAnalysis();

    if (mounted) {
      setState(() {
        _profile = profile;
        _latestAnalysis = analysis;
        _profileImageUrl = profile?.avatarUrl;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null && _profile != null) {
      // 이미지 업로드
      final imageUrl = await _dataService.uploadProfileImage(
        _profile!.id,
        image.path,
      );

      if (imageUrl != null) {
        // 프로필 업데이트
        await _dataService.updateProfile(
          userId: _profile!.id,
          name: _profile!.name,
        );

        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 55),

                  // Back 버튼
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 23),
                      child: GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Image.asset(
                          'assets/8/Back.png',
                          width: 59,
                          height: 40,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 프로필 카드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Stack(
                      children: [
                        // 카드 배경
                        Image.asset(
                          'assets/8/box_profile.png',
                          width: 363,
                          height: 172,
                        ),

                        // 카드 내용
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 프로필 이미지
                              GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300],
                                    image: _profileImageUrl != null
                                        ? DecorationImage(
                                            image:
                                                NetworkImage(_profileImageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _profileImageUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),

                              const SizedBox(width: 16),

                              // 사용자 정보
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 이름
                                  Text(
                                    '${_profile?.name ?? '사용자'}님 💌',
                                    style: const TextStyle(
                                      fontFamily: 'NanumSquareNeo',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24,
                                      color: Color(0xFF000000),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // 생년월일
                                  if (_profile?.birthYear != null)
                                    Text(
                                      '${_profile!.birthYear}.10.12',
                                      style: const TextStyle(
                                        fontFamily: 'NanumSquareNeo',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Color(0xFF434343),
                                      ),
                                    ),

                                  const SizedBox(height: 16),

                                  // 해시태그
                                  if (_latestAnalysis != null)
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        _buildHashTag(
                                          PersonalColorType.toHashtag(
                                            _latestAnalysis!.personalColor ??
                                                '',
                                          ),
                                        ),
                                        _buildHashTag(
                                          SkinType.toHashtag(
                                            _latestAnalysis!.detectedSkinType ??
                                                '',
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  // 로그아웃 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GestureDetector(
                      onTap: _handleLogout,
                      child: Image.asset(
                        'assets/8/logout.png',
                        width: 337,
                        height: 41,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 개인정보 수정 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GestureDetector(
                      onTap: () => context.go('/profile-edit'),
                      child: Image.asset(
                        'assets/8/modify.png',
                        width: 337,
                        height: 41,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // 네비게이션 바 공간
                ],
              ),
            ),

            // 하단 네비게이션 바 (홈 화면과 동일)
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHashTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8B7D4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Positioned(
      left: -13,
      bottom: 0,
      child: Stack(
        children: [
          Image.asset(
            'assets/7/rectangle.png',
            width: 419,
            height: 90,
          ),
          Positioned(
            left: 29,
            top: 13,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Image.asset(
                    'assets/7/main_home.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
                GestureDetector(
                  onTap: () =>
                      _launchURL('https://cafe.naver.com/urbeautyfinder'),
                  child: Image.asset(
                    'assets/7/main_community.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
                GestureDetector(
                  onTap: () => _launchURL('http://pf.kakao.com/_izDxcn'),
                  child: Image.asset(
                    'assets/7/main_chatbot.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
                GestureDetector(
                  onTap: () {}, // 현재 페이지
                  child: Image.asset(
                    'assets/7/main_mypage.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    // url_launcher 사용 (이전과 동일)
  }
}
