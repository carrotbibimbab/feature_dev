// lib/screens/auth/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/models/user_profile.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 추가

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _dataService = SupabaseDataService();
  final _nameController = TextEditingController();
  
  // ⭐ 생년월일 컨트롤러를 DateTime 변수로 변경
  DateTime? _selectedDate;
  String? _selectedSkinType;

  @override
  void dispose() {
    _nameController.dispose();
    // ⭐ 더 이상 사용하지 않는 컨트롤러 dispose 제거
    super.dispose();
  }

  void _toggleSkinType(String type) {
    setState(() {
      _selectedSkinType = _selectedSkinType == type ? null : type;
    });
  }

  // 💡 [핵심 로직] 달력 팝업을 띄우는 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000), // 초기 날짜 (선택된 날짜 또는 2000년)
      firstDate: DateTime(1900), // 선택 가능한 가장 빠른 날짜
      lastDate: DateTime.now(), // 선택 가능한 가장 늦은 날짜
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // 사용자가 선택한 날짜로 상태 업데이트
      });
    }
  }

  Future<void> _handleSave() async {
    // 유효성 검사
    if (_nameController.text.isEmpty) {
      _showError('이름을 입력해주세요.');
      return;
    }

    // ⭐ 생년월일 유효성 검사 변경
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
      // ⭐ 선택된 날짜의 년도 전달
      birthYear: _selectedDate!.year, 
      skinType: _selectedSkinType!,
    );

    if (success) {
      // 화면 6: 뷰파 시작하기 페이지로 이동
      if (mounted) {
        context.go('/welcome');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // 제목
              const Text(
                '회원님의 정보를\n입력해주세요 🪄',
                style: TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontWeight: FontWeight.w900,
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
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
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

              // 💡 2. 생년월일 (수정된 부분)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      '생년월일',
                      style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF434343),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context), // 탭하면 달력 팝업 호출
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
                              // ⭐ intl 패키지를 사용하여 YYYY / MM / DD 형식으로 표시
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

              // 3. 피부타입 (기존과 동일)
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
                          fontFamily: 'NanumSquareNeo',
                          fontWeight: FontWeight.w700,
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

              const Spacer(), // 남은 공간 차지

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
