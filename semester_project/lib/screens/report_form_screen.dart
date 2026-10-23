import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;
  String _submittedTitle = '';

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _uiState = ReportUiState.loading);

    try {
      // Simulated request for this lab activity; no database is connected.
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_simulateFailure) {
        throw Exception('Simulated failure for demonstration.');
      }
      if (!mounted) return;
      setState(() {
        _submittedTitle = _titleController.text.trim();
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  void _backToForm() {
    setState(() => _uiState = ReportUiState.idle);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    if (value.trim().length < 3) {
      return 'Please enter at least 3 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Report'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildCurrentState(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentState(ThemeData theme) {
    switch (_uiState) {
      case ReportUiState.loading:
        return _statePanel(
          key: const ValueKey('loading'),
          icon: Icons.hourglass_top_rounded,
          color: Colors.blue,
          title: 'Submitting your report...',
          message: 'Please wait while we process your request. Keep this screen open.',
          child: const Padding(
            padding: EdgeInsets.only(top: 18),
            child: LinearProgressIndicator(),
          ),
        );
      case ReportUiState.success:
        return _statePanel(
          key: const ValueKey('success'),
          icon: Icons.check_circle_outline,
          color: Colors.green,
          title: 'Report submitted successfully!',
          message:
              'Your report “$_submittedTitle” was processed in this demo. No real database record was saved.',
          child: Column(
            children: [
              const SizedBox(height: 18),
              AppButton(
                label: 'Create Another Report',
                icon: Icons.add,
                onPressed: _backToForm,
              ),
              TextButton.icon(
                onPressed: () => setState(() => _uiState = ReportUiState.empty),
                icon: const Icon(Icons.inbox_outlined),
                label: const Text('View report list'),
              ),
            ],
          ),
        );
      case ReportUiState.empty:
        return _statePanel(
          key: const ValueKey('empty'),
          icon: Icons.inbox_outlined,
          color: Colors.blueGrey,
          title: 'No reports yet',
          message: 'There are currently no saved reports to display. Create a report to get started.',
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: AppButton(
              label: 'Create a Report',
              icon: Icons.add,
              onPressed: _backToForm,
            ),
          ),
        );
      case ReportUiState.error:
        return _statePanel(
          key: const ValueKey('error'),
          icon: Icons.error_outline,
          color: Colors.red,
          title: 'We couldn’t submit the report',
          message: 'A simulated error occurred. You can retry or return to the form and correct your information.',
          child: Column(
            children: [
              const SizedBox(height: 18),
              AppButton(
                label: 'Retry Submission',
                icon: Icons.refresh,
                onPressed: () {
                  setState(() => _simulateFailure = false);
                  submitReport();
                },
              ),
              TextButton(
                onPressed: _backToForm,
                child: const Text('Return to form'),
              ),
            ],
          ),
        );
      case ReportUiState.idle:
        return _buildForm();
    }
  }

  Widget _buildForm() {
    return Card(
      key: const ValueKey('form'),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 42,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Text(
                'Report Details',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Fill in the details below. Fields marked as required must be completed.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 22),
              AppTextField(
                controller: _titleController,
                label: 'Report title *',
                hint: 'e.g. Damaged classroom equipment',
                validator: _requiredValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _categoryController,
                label: 'Category *',
                hint: 'e.g. Maintenance, safety, technical',
                validator: _requiredValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _locationController,
                label: 'Location *',
                hint: 'Where did this happen?',
                validator: _requiredValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descriptionController,
                label: 'Description *',
                hint: 'Explain the issue or concern...',
                validator: _requiredValidator,
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simulate submission failure'),
                subtitle: const Text(
                  'Turn this on to demonstrate the Error state.',
                ),
                value: _simulateFailure,
                onChanged: (value) => setState(() => _simulateFailure = value),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Submit Report',
                icon: Icons.send_outlined,
                onPressed: submitReport,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _uiState = ReportUiState.empty),
                  icon: const Icon(Icons.inbox_outlined),
                  label: const Text('View reports'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statePanel({
    required Key key,
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    Widget? child,
  }) {
    return Card(
      key: key,
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 68, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
            ?child,
          ],
        ),
      ),
    );
  }
}
