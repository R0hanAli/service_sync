
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/glass_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _selectedRole = 'technician';
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose(); _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();
    return GlassScaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Create Account', style: GoogleFonts.outfit(
                    fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  Text('Join ServiceSync to manage your field jobs',
                    style: GoogleFonts.outfit(fontSize: 14, color: Colors.white54)),
                  const SizedBox(height: 32),

                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        GlassTextField(
                          controller: _nameCtrl,
                          labelText: 'Full Name',
                          hintText: 'Alex Rodriguez',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (v) => (v == null || v.trim().length < 2) ? 'Enter full name' : null,
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _emailCtrl,
                          labelText: 'Email Address',
                          hintText: 'alex@servicesync.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _phoneCtrl,
                          labelText: 'Phone Number',
                          hintText: '+1-555-0123',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().length < 6) ? 'Enter valid phone' : null,
                        ),
                        const SizedBox(height: 16),

                        
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.12)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedRole,
                                  dropdownColor: const Color(0xFF1A1F4E),
                                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
                                  icon: const Icon(Icons.expand_more_rounded, color: Colors.white54),
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'technician', child: Text('Technician')),
                                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                                  ],
                                  onChanged: (v) => setState(() => _selectedRole = v!),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        GlassTextField(
                          controller: _passCtrl,
                          labelText: 'Password',
                          hintText: 'Min. 8 characters',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscurePass,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.white54, size: 20),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                          validator: (v) => (v == null || v.length < 8) ? 'Min. 8 characters required' : null,
                        ),
                        const SizedBox(height: 16),

                        GlassTextField(
                          controller: _confirmCtrl,
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter password',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.white54, size: 20),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                          validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Obx(() => GlassButton(
                    isLoading: ctrl.isLoading.value,
                    text: 'Create Account',
                    icon: Icons.rocket_launch_rounded,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ctrl.register(
                          fullName: _nameCtrl.text.trim(),
                          email: _emailCtrl.text.trim(),
                          phone: _phoneCtrl.text.trim(),
                          role: _selectedRole,
                          password: _passCtrl.text,
                        );
                      }
                    },
                  )),
                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF00D4FF), fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

