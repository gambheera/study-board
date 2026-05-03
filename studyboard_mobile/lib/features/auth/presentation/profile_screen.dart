import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';

// 25 official Sri Lankan districts — keep in sync with OnboardingScreen
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

// Common Sri Lankan school suggestions — keep in sync with OnboardingScreen
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

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  String? _selectedDistrict;
  String _schoolValue = '';
  String? _nameError;
  bool _isDirty = false;
  bool _isSubmitting = false;

  // Captured in initState for dirty detection; updated on successful save
  late String _originalName;
  late String _originalDistrict;
  late String _originalSchool;

  @override
  void initState() {
    super.initState();
    final student = ref
        .read(authProvider)
        .value
        ?.mapOrNull(authenticated: (a) => a.student);
    _originalName = (student?.name ?? '').trim();
    _originalDistrict = student?.district ?? '';
    _originalSchool = (student?.school ?? '').trim();

    _nameController.text = _originalName;
    _selectedDistrict = _originalDistrict.isEmpty ? null : _originalDistrict;
    _schoolValue = _originalSchool;

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus && _nameController.text.trim().isEmpty) {
        if (!mounted) return;
        setState(() => _nameError = 'Name is required');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty && _selectedDistrict != null;

  void _checkDirty() {
    final dirty = _nameController.text.trim() != _originalName ||
        (_selectedDistrict ?? '') != _originalDistrict ||
        _schoolValue.trim() != _originalSchool;
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  Future<void> _onSave() async {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? 'Name is required' : null;
    });
    if (!_isFormValid || !_isDirty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    await ref.read(authProvider.notifier).editProfile(
          name: _nameController.text.trim(),
          district: _selectedDistrict!,
          school: _schoolValue.trim(),
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

    // Success — reset dirty tracking so Save button disables again
    _originalName = _nameController.text.trim();
    _originalDistrict = _selectedDistrict ?? '';
    _originalSchool = _schoolValue.trim();
    setState(() {
      _isDirty = false;
      _isSubmitting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  errorText: _nameError,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && _nameError != null) {
                    setState(() => _nameError = null);
                  }
                  _checkDirty();
                },
              ),
              const SizedBox(height: 16),
              // District
              DropdownButtonFormField<String>(
                initialValue: _selectedDistrict,
                decoration: InputDecoration(
                  labelText: 'District',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                items: _sriLankanDistricts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedDistrict = value);
                  _checkDirty();
                },
              ),
              const SizedBox(height: 16),
              // School autocomplete — pre-populated via initialValue
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _schoolValue),
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
                onSelected: (selection) {
                  setState(() => _schoolValue = selection);
                  _checkDirty();
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'School',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _schoolValue = value);
                      _checkDirty();
                    },
                    onEditingComplete: onFieldSubmitted,
                  );
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: (_isFormValid && _isDirty && !_isSubmitting)
                    ? _onSave
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
