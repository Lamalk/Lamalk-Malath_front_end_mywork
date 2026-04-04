import 'package:flutter/material.dart';
import 'package:front_end/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;

  int _currentIndex = 1;

  String? fullName;
  String? email;
  String? profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      final response =
          await supabase.from('users').select().eq('id', user.id).single();

      setState(() {
        fullName = response['full_name'];
        email = response['email'];
        profileImage = response['profile_image'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              /// ===== صورة الحساب =====
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        profileImage != null && profileImage!.isNotEmpty
                            ? NetworkImage(profileImage!)
                            : const AssetImage('assets/images/profile.png')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 16),

                  /// ===== الاسم + الإيميل =====
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName ?? 'بدون اسم',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666D80),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                'المعلومات الشخصية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF4C5494)),
                title: const Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C5494),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.folder_open,
                  color: Color(0xFF4C5494),
                ),
                title: const Text(
                  'سجل القضايا',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C5494),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/case_history');
                },
              ),

              const SizedBox(height: 40),

              const Text(
                'الإعدادات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C5494),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF4C5494),
                ),
                title: const Text(
                  'عن التطبيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C5494),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Color(0xFF4C5494)),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C5494),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'هل تريد تسجيل الخروج؟',
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                            height: 60,
                            child: Center(
                              child: CustomButton(
                                text: 'نعم',
                                onPressed: () async {
                                  await supabase.auth.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                  );
                },
              ),
            ],
          ),
        ),

        /// ===== Bottom Navigation =====
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF666D80),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 0
                          ? const Color(0xFF4C5494)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home, color: Color(0xFF666D80)),
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 1
                          ? const Color(0xFF4C5494)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF666D80)),
              ),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
