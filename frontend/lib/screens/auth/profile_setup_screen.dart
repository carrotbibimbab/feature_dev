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

  String? _selectedSkinType;
  final Set<String> _selectedAllergies = {};
  final Set<String> _selectedConcerns = {};

  // 일반적인 알레르기 항목
  static const List<String> _allergyOptions = [
    '향료',
    '알코올',
    '파라벤',
    '살리실산',
    '레티놀',
    '벤조일퍼록사이드',
    '나이아신아마이드',
    '비타민C',
    '없음',
  ];

  // 일반적인 피부 고민
  static const List<String> _concernOptions = [
    '여드름/뾰루지',
    '모공',
    '주름/잔주름',
    '색소침착/기미',
    '홍조/붉은기',
    '탄력저하',
    '건조함',
    '과다피지',
    '칙칙함',
    '없음',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _toggleSkinType(String type) {
    setState(() {
      _selectedSkinType = _selectedSkinType == type ? null : type;
    });
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
      } else {
        // "없음"을 선택하면 다른 것들은 해제
        if (allergy == '없음') {
          _selectedAllergies.clear();
        } else {
          _selectedAllergies.remove('없음');
        }
        _selectedAllergies.add(allergy);
      }
    });
  }

  void _toggleConcern(String concern) {
    setState(() {
      if (_selectedConcerns.contains(concern)) {
        _selectedConcerns.remove(concern);
      } else {
        // "없음"을 선택하면 다른 것들은 해제
        if (concern == '없음') {
          _selectedConcerns.clear();
        } else {
          _selectedConcerns.remove('없음');
        }
        _selectedConcerns.add(concern);
      }
    });
  }

  Future<void> _handleSave() async {
    // 유효성 검사
    if (_nameController.text.isEmpty) {
      _showError('이름을 입력해주세요.');
      return;
    }

    if (_yearController.text.isEmpty) {
      _showError('출생년도를 입력해주세요.');
      return;
    }

    if (_selectedSkinType == null) {
      _showError('피부 타입을 선택해주세요.');
      return;
    }

    final year = int.tryParse(_yearController.text);
    if (year == null || year < 1900 || year > DateTime.now().year) {
      _showError('올바른 출생년도를 입력해주세요 (예: 1990).');
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
      allergies: _selectedAllergies.toList(),
      skinConcerns: _selectedConcerns.toList(),
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
                const SizedBox(height: 60),

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

                // 이름
                const Text(
                  '이름',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
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

                // 출생년도 (birth_year만 필요)
                const Text(
                  '출생년도',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: '예) 1990',
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

                const SizedBox(height: 28),

                // 피부타입
                const Text(
                  '피부타입',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
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

                const SizedBox(height: 28),

                // 알레르기 성분 (새로 추가)
                const Text(
                  '알레르기 또는 피해야 할 성분',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '중복 선택 가능',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allergyOptions.map((allergy) {
                    return _buildChip(
                      label: allergy,
                      isSelected: _selectedAllergies.contains(allergy),
                      onTap: () => _toggleAllergy(allergy),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // 피부 고민 (새로 추가)
                const Text(
                  '피부 고민',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF434343),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '중복 선택 가능',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _concernOptions.map((concern) {
                    return _buildChip(
                      label: concern,
                      isSelected: _selectedConcerns.contains(concern),
                      onTap: () => _toggleConcern(concern),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

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

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000000) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF000000) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : const Color(0xFF434343),
          ),
        ),
      ),
    );
  }
}