import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  String? imageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data != null) {
      nameController.text = data['full_name'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone_number'] ?? '';
      imageUrl = data['profile_image'];
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (selectedImage == null) return imageUrl;

    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('profile-images')
        .upload(fileName, selectedImage!);

    final publicUrl = supabase.storage
        .from('profile-images')
        .getPublicUrl(fileName);

    return publicUrl;
  }

  Future<void> _updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      final newImageUrl = await _uploadImage(user.id);

      await supabase
          .from('users')
          .update({
            'full_name': nameController.text.trim(),
            'phone_number': phoneController.text.trim(),
            'profile_image': newImageUrl,
          })
          .eq('id', user.id);

      if (emailController.text.trim() != user.email) {
        await supabase.auth.updateUser(
          UserAttributes(email: emailController.text.trim()),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
      }
    }

    if (mounted) {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (imageUrl != null
                                ? NetworkImage(imageUrl!) as ImageProvider
                                : const AssetImage(
                                    'assets/images/profile.png',
                                  )),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _textField(nameController, 'الاسم الكامل'),
                  const SizedBox(height: 15),
                  _textField(emailController, 'البريد الإلكتروني'),
                  const SizedBox(height: 15),
                  _textField(phoneController, 'رقم الهاتف'),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _updateProfile,
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('حفظ التعديل'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}