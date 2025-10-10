// lib/screens/profile/profile_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/models/user_profile.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _dataService = SupabaseDataService();
  final _nameController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedSkinType;
  bool _isLoading = true; // ✅ 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ✅ 사용자 프로필 로드 (실제 데이터)
  Future<void> _loadUserProfile() async {
    try {
      final profile = await _dataService.getCurrentUserProfile();
      
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile.name;
          // ✅ birthYear가 null이 아닐 때만 설정
          if (profile.birthYear != null) {
            _selectedDate = DateTime(profile.birthYear!);
          }
          _selectedSkinType = profile.skinType;
          _isLoading = false;
        });
      } else {
        // 프로필을 불러올 수 없는 경우
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showError('프로필을 불러올 수 없습니다.');
        }
      }
    } catch (e) {
      // 에러 발생 시
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showError('프로필 로딩 중 오류가 발생했습니다: $e');
      }
    }
  }

  void _toggleSkinType(String type) {
    setState(() {
      _selectedSkinType = _selectedSkinType == type ? null : type;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    // 유효성 검사
    if (_nameController.text.isEmpty) {
      _showError('이름을 입력해주세요.');
      return;
    }

    if (_selectedDate == null) {
      _showError('생년월일을 선택해주세요.');
      return;
    }

    if (_selectedSkinType == null) {
      _showError('피부 타입을 선택해주세요.');
      return;
    }
    
    // 프로필 저장
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) {
      _showError('로그인이 필요합니다.');
      return;
    }

    final success = await _dataService.updateProfile(
      userId: userId,
      name: _nameController.text,
      birthYear: _selectedDate!.year,
      skinType: _selectedSkinType!,
    );

    if (success) {
      if (mounted) {
        _showSuccess('프로필이 수정되었습니다.');
        // ✅ 안전한 뒤로가기
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go('/home');
          }
        }
      }
    } else {
      _showError('저장에 실패했습니다. 다시 시도해주세요.');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 로딩 중일 때 로딩 화면 표시
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ✅ 뒤로가기 버튼 (이미지 사용)
              GestureDetector(
                onTap: () {
                  // ✅ pop 대신 go로 안전하게 이동
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    context.go('/home'); // pop 불가능하면 홈으로
                  }
                },
                child: Image.asset(
                  'assets/5and11/Back.png',
                  width: 24,
                  height: 24,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ 제목 (문구 변경)
              const Text(
                '회원님의 정보를\n수정해주세요 🍥',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  height: 50 / 32,
                  color: Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 50),

              // 1. 이름 (수평 배치)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      '이름',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF434343),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: '이름을 입력하세요',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 2. 생년월일
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      '생년월일',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF434343),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? '날짜를 선택하세요'
                              : DateFormat('yyyy / MM / dd').format(_selectedDate!),
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDate == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 3. 피부타입
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        '피부타입',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFF434343),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        // 첫 번째 줄: 건성, 중성, 지성
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildSkinTypeButton(
                              type: SkinTypeConstants.dry,
                              width: 62,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            _buildSkinTypeButton(
                              type: SkinTypeConstants.normal,
                              width: 62,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            _buildSkinTypeButton(
                              type: SkinTypeConstants.oily,
                              width: 62,
                              height: 50,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 두 번째 줄: 복합성, 민감성
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildSkinTypeButton(
                              type: SkinTypeConstants.combination,
                              width: 77,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            _buildSkinTypeButton(
                              type: SkinTypeConstants.sensitive,
                              width: 77,
                              height: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Save 버튼
              Center(
                child: GestureDetector(
                  onTap: _handleSave,
                  child: Image.asset(
                    'assets/5and11/save_black.png',
                    width: 318,
                    height: 50,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkinTypeButton({
    required String type,
    required double width,
    required double height,
  }) {
    final isSelected = _selectedSkinType == type;
    return GestureDetector(
      onTap: () => _toggleSkinType(type),
      child: Image.asset(
        SkinTypeConstants.getButtonImage(type, isSelected: isSelected),
        width: width,
        height: height,
      ),
    );
  }
}