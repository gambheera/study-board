import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:studyboard_mobile/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && mounted) {
        setState(() {
          _emailError = _emailController.text.isEmpty
              ? 'Email is required'
              : null;
        });
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && mounted) {
        setState(() {
          _passwordError = _passwordController.text.isEmpty
              ? 'Password is required'
              : null;
        });
      }
    });

    // Show session-expired snackbar on first frame if applicable (AC: #6).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authVal = ref.read(authProvider).value;
      final isExpired = authVal?.map(
            unauthenticated: (s) => s.sessionExpired,
            authenticated: (_) => false,
          ) ??
          false;
      if (isExpired) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session expired — please log in again'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onLogIn() async {
    setState(() {
      _emailError =
          _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password is required' : null;
    });
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    await ref.read(authProvider.notifier).signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
      next.whenOrNull(
        data: (authState) {
          if (!mounted) return;
          authState.map(
            unauthenticated: (s) {
              if (s.sessionExpired) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your session expired — please log in again'),
                  ),
                );
              }
            },
            authenticated: (_) => context.go('/board'),
          );
        },
        error: (error, _) {
          if (!mounted) return;
          final message = error is Failure
              ? error.message
              : 'Something went wrong. Please try again.';
          if (message == AuthFailure.googleSignInCancelled) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Log in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormField(
                controller: _emailController,
                label: 'Email',
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorText: _emailError,
              ),
              const SizedBox(height: 16),
              AuthFormField(
                controller: _passwordController,
                label: 'Password',
                focusNode: _passwordFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                errorText: _passwordError,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isLoading ? null : _onLogIn,
                child: const Text('Log in'),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              const GoogleSignInButton(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
