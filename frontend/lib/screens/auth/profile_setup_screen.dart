// lib/screens/auth/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/models/user_profile.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _dataService = SupabaseDataService();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();

  String? _selectedSkinType;

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _toggleSkinType(String type) {
    setState(() {
      _selectedSkinType = _selectedSkinType == type ? null : type;
    });
  }

  Future<void> _handleSave() async {
    // 유효성 검사
    if (_nameController.text.isEmpty) {
      _showError('이름을 입력해주세요.');
      return;
    }

    if (_yearController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty) {
      _showError('생년월일을 입력해주세요.');
      return;
    }

    if (_selectedSkinType == null) {
      _showError('피부 타입을 선택해주세요.');
      return;
    }

    final year = int.tryParse(_yearController.text);
    if (year == null || year < 1900 || year > DateTime.now().year) {
      _showError('올바른 생년월일을 입력해주세요.');
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
      birthYear: year,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 93),

                // 제목
                const Text(
                  '회원님의 정보를\n입력해주세요 🪄',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                    height: 50 / 32,
                    color: Color(0xFF000000),
                  ),
                ),

                const SizedBox(height: 74),

                // 이름
                const Text(
                  '이름',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
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

                const SizedBox(height: 28),

                // 생년월일
                const Text(
                  '생년월일',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // 년
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: '년',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('/', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    // 월
                    Expanded(
                      child: TextField(
                        controller: _monthController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          hintText: '월',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('/', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    // 일
                    Expanded(
                      child: TextField(
                        controller: _dayController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          hintText: '일',
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // 피부타입
                const Text(
                  '피부타입',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 12),

                // 건성, 중성, 지성
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 94),
                    _buildSkinTypeButton(
                      type: SkinTypeConstants.dry,
                      width: 62,
                      height: 50,
                    ),
                    const SizedBox(width: 15),
                    _buildSkinTypeButton(
                      type: SkinTypeConstants.normal,
                      width: 62,
                      height: 50,
                    ),
                    const SizedBox(width: 15),
                    _buildSkinTypeButton(
                      type: SkinTypeConstants.oily,
                      width: 62,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 복합성, 민감성
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 94),
                    _buildSkinTypeButton(
                      type: SkinTypeConstants.combination,
                      width: 77,
                      height: 50,
                    ),
                    const SizedBox(width: 13),
                    _buildSkinTypeButton(
                      type: SkinTypeConstants.sensitive,
                      width: 77,
                      height: 50,
                    ),
                  ],
                ),

                const SizedBox(height: 215),

                // Save 버튼
                GestureDetector(
                  onTap: _handleSave,
                  child: Image.asset(
                    'assets/5and11/save_black.png',
                    width: 318,
                    height: 50,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
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
