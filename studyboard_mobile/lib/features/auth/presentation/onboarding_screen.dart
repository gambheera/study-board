import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/notifications/data/notification_provider.dart';

const _sriLankanDistricts = [
  'Ampara',
  'Anuradhapura',
  'Badulla',
  'Batticaloa',
  'Colombo',
  'Galle',
  'Gampaha',
  'Hambantota',
  'Jaffna',
  'Kalutara',
  'Kandy',
  'Kegalle',
  'Kilinochchi',
  'Kurunegala',
  'Mannar',
  'Matale',
  'Matara',
  'Monaragala',
  'Mullaitivu',
  'Nuwara Eliya',
  'Polonnaruwa',
  'Puttalam',
  'Ratnapura',
  'Trincomalee',
  'Vavuniya',
];

const _schoolSuggestions = [
  'Royal College, Colombo',
  'Ananda College, Colombo',
  'Nalanda College, Colombo',
  'D.S. Senanayake College, Colombo',
  'Isipathana College, Colombo',
  'Thurstan College, Colombo',
  'Vishaka Vidyalaya, Colombo',
  'Devi Balika Vidyalaya, Colombo',
  "Ladies' College, Colombo",
  "Bishop's College, Colombo",
  'Zahira College, Colombo',
  'Trinity College, Kandy',
  'Dharmaraja College, Kandy',
  "Mahamaya Girls' College, Kandy",
  "St. Sylvester's College, Kandy",
  'Jaffna College',
  'Hindu College, Jaffna',
  'Matara Central College',
  'Richmond College, Galle',
  'Mahinda College, Galle',
];

const _subjects = ['Chemistry', 'Physics', 'Combined Maths'];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedDistrict;
  String _schoolValue = '';
  final _schoolFocusNode = FocusNode();
  String? _districtError;
  String? _schoolError;
  String? _subjectError;
  final _selectedSubjects = <String>{};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _schoolFocusNode.addListener(() {
      if (!_schoolFocusNode.hasFocus && _schoolValue.trim().isEmpty) {
        if (!mounted) return;
        setState(() => _schoolError = 'School is required');
      }
    });
  }

  @override
  void dispose() {
    _schoolFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _selectedDistrict != null &&
      _schoolValue.trim().isNotEmpty &&
      _selectedSubjects.isNotEmpty;

  Future<void> _onGetStarted() async {
    setState(() {
      _districtError =
          _selectedDistrict == null ? 'Please select a district' : null;
      _schoolError =
          _schoolValue.trim().isEmpty ? 'School is required' : null;
      _subjectError =
          _selectedSubjects.isEmpty ? 'Select at least one subject' : null;
    });
    if (!_isFormValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    await ref.read(authProvider.notifier).completeOnboarding(
          district: _selectedDistrict!,
          school: _schoolValue.trim(),
          selectedSubjects: _selectedSubjects.toList(),
        );

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.hasError) {
      final message = authState.error is Failure
          ? (authState.error! as Failure).message
          : 'Something went wrong. Please try again.';
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    // Request notification permission (Android 13+ shows OS dialog;
    // Android 12 and below returns authorized silently)
    final permissionStatus =
        await ref.read(notificationServiceProvider).requestPermission();

    if (!mounted) return;

    final granted = permissionStatus == AuthorizationStatus.authorized ||
        permissionStatus == AuthorizationStatus.provisional;

    String? fcmToken;
    if (granted) {
      fcmToken =
          await ref.read(notificationServiceProvider).getFcmToken();
    }

    if (!mounted) return;

    await ref.read(authProvider.notifier).setFcmPermission(
          granted: granted,
          fcmToken: fcmToken,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    // Navigation handled by router redirect:
    // student.district.isNotEmpty → redirect fires → /board
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Set up your profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'District',
                  errorText: _districtError,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                items: _sriLankanDistricts
                    .map(
                      (d) => DropdownMenuItem(value: d, child: Text(d)),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedDistrict = value;
                  _districtError = null;
                }),
              ),
              const SizedBox(height: 16),
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.length < 2) {
                    return const Iterable.empty();
                  }
                  return _schoolSuggestions.where(
                    (s) => s.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                onSelected: (selection) =>
                    setState(() => _schoolValue = selection),
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'School',
                      errorText: _schoolError,
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      _schoolValue = value;
                      if (value.isNotEmpty) _schoolError = null;
                    }),
                    onEditingComplete: onFieldSubmitted,
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._subjects.map(
                (subject) => CheckboxListTile(
                  title: Text(subject),
                  value: _selectedSubjects.contains(subject),
                  onChanged: (checked) => setState(() {
                    if (checked == true) {
                      _selectedSubjects.add(subject);
                    } else {
                      _selectedSubjects.remove(subject);
                    }
                    if (_selectedSubjects.isNotEmpty) _subjectError = null;
                  }),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (_subjectError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _subjectError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed:
                    (_isFormValid && !_isSubmitting) ? _onGetStarted : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Get started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
