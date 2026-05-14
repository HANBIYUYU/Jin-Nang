import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _register() {
    // Demo: 直接跳转
    context.go('/study');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppSafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _buildBackButton(context),
              const SizedBox(height: 24),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start your Chinese learning journey',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.morandiText.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),
              _buildInputField(
                label: 'Name',
                hint: 'Alex Walker',
                controller: _nameCtrl,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Email',
                hint: 'alex@example.com',
                controller: _emailCtrl,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordCtrl,
                icon: Icons.lock_outline,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
              ),
              const SizedBox(height: 32),
              _buildRegisterButton(),
              const SizedBox(height: 24),
              _buildLoginLink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Pressable(
      onPressed: () => context.go('/login'),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.morandiText,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.morandiText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.morandiText, width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.morandiText,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.morandiText.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(icon, color: AppColors.morandiText, size: 20),
              suffixIcon: onToggleObscure != null
                  ? IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.morandiText,
                        size: 20,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Pressable(
      onPressed: _register,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.straw14,
          border: Border.all(color: AppColors.morandiText, width: 2.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.morandiText,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Create Account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.morandiText.withValues(alpha: 0.6),
          ),
        ),
        Pressable(
          onPressed: () => context.go('/login'),
          child: const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.baliHai30,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
