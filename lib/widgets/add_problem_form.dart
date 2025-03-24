import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/problem.dart';
import '../providers/problem_provider.dart';

class AddProblemForm extends StatefulWidget {
  final String sectionId;
  final VoidCallback onClose;
  final Problem? initialProblem;
  final bool isEditing;

  const AddProblemForm({
    super.key,
    required this.sectionId,
    required this.onClose,
    this.initialProblem,
    this.isEditing = false,
  });

  @override
  AddProblemFormState createState() => AddProblemFormState();
}

class AddProblemFormState extends State<AddProblemForm> {
  final _formKey = GlobalKey<FormState>();
  late List<String> _intuitionItems;
  late String _tags;
  late String _difficulty;
  bool _isExpanded = false;
  int _currentStep = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _leetCodeUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sampleInputController = TextEditingController();
  final TextEditingController _sampleOutputController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _intuitionItems = widget.initialProblem?.intuition ?? [''];
    _tags = widget.initialProblem?.tags?.join(', ') ?? '';
    _difficulty = widget.initialProblem?.difficulty ?? 'Medium';

    // Initialize controllers with initial values if editing
    if (widget.initialProblem != null) {
      _nameController.text = widget.initialProblem!.name;
      _leetCodeUrlController.text = widget.initialProblem!.leetCodeUrl;
      _descriptionController.text = widget.initialProblem!.description ?? '';
      _sampleInputController.text = widget.initialProblem!.sampleInput ?? '';
      _sampleOutputController.text = widget.initialProblem!.sampleOutput ?? '';
      _solutionController.text = widget.initialProblem!.code ?? '';
      _imageUrlController.text = widget.initialProblem!.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _leetCodeUrlController.dispose();
    _descriptionController.dispose();
    _sampleInputController.dispose();
    _sampleOutputController.dispose();
    _solutionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final problemData = Problem(
        sectionId: widget.sectionId,
        id: widget.initialProblem?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        leetCodeUrl: _leetCodeUrlController.text,
        description: _descriptionController.text,
        sampleInput: _sampleInputController.text,
        sampleOutput: _sampleOutputController.text,
        intuition:
            _intuitionItems.where((item) => item.trim().isNotEmpty).toList(),
        code: _solutionController.text,
        tags: _tags.split(',').map((tag) => tag.trim()).toList(),
        difficulty: _difficulty,
        imageUrl: _imageUrlController.text,
        dateAdded:
            widget.initialProblem?.dateAdded ?? DateTime.now().toString(),
        dateModified: DateTime.now().toString(),
      );

      final problemProvider =
          Provider.of<ProblemProvider>(context, listen: false);
      if (widget.isEditing && widget.initialProblem != null) {
        problemProvider.updateProblem(problemData);
      } else {
        problemProvider.addProblem(problemData);
      }

      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                Flexible(
                  child: _isExpanded
                      ? _buildExpandedForm(context)
                      : _buildStepperForm(context),
                ),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.isEditing ? 'Edit Problem' : 'Add New Problem',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(_isExpanded ? Icons.view_week : Icons.view_agenda),
                tooltip: _isExpanded ? 'Switch to Steps' : 'Expand All',
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: widget.onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperForm(BuildContext context) {
    var theme = Theme.of(context);
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      child: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            _handleSubmit();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            widget.onClose();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(_currentStep < 3 ? 'Continue' : 'Submit'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text(_currentStep > 0 ? 'Back' : 'Cancel'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: Text(
              'Basic Information',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              children: [
                _buildTextField('Problem Name *', _nameController,
                    isRequired: true, icon: Icons.title),
                _buildTextField('LeetCode URL *', _leetCodeUrlController,
                    isRequired: true, icon: Icons.link),
                _buildDifficultyDropdown(),
              ],
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text(
              'Problem Details',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              children: [
                _buildTextField('Description', _descriptionController,
                    icon: Icons.description),
                _buildTextField('Sample Input', _sampleInputController,
                    isCode: true, icon: Icons.input),
                _buildTextField('Sample Output', _sampleOutputController,
                    isCode: true, icon: Icons.output),
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text(
              'Solution',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              children: [
                _buildIntuitionPoints(),
                _buildTextField('Solution', _solutionController,
                    maxLines: 6, isCode: true, icon: Icons.code),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: Text(
              'Additional Info',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              children: [
                _buildTextField('Image URL', _imageUrlController,
                    icon: Icons.image),
                _buildTagsField(),
              ],
            ),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Basic Information'),
          _buildTextField('Problem Name *', _nameController,
              isRequired: true, icon: Icons.title),
          _buildTextField('LeetCode URL *', _leetCodeUrlController,
              isRequired: true, icon: Icons.link),
          _buildDifficultyDropdown(),
          const Divider(height: 32),
          _buildSectionTitle(context, 'Problem Details'),
          _buildTextField('Description', _descriptionController,
              icon: Icons.description),
          _buildTextField('Sample Input', _sampleInputController,
              isCode: true, icon: Icons.input),
          _buildTextField('Sample Output', _sampleOutputController,
              isCode: true, icon: Icons.output),
          const Divider(height: 32),
          _buildSectionTitle(context, 'Solution'),
          _buildIntuitionPoints(),
          _buildTextField('Solution', _solutionController,
              maxLines: 6, isCode: true, icon: Icons.code),
          const Divider(height: 32),
          _buildSectionTitle(context, 'Additional Info'),
          _buildTextField('Image URL', _imageUrlController, icon: Icons.image),
          _buildTagsField(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (!_isExpanded) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.onClose,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(widget.isEditing ? 'Save Changes' : 'Add Problem'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isRequired = false,
      int maxLines = 1,
      bool isCode = false,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: isCode
            ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 16,
                )
            : Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          labelStyle:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: isCode
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildIntuitionPoints() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Intuition Points',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Intuition Point',
                  onPressed: () {
                    setState(() {
                      _intuitionItems.add('');
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _intuitionItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: _intuitionItems[index],
                          onChanged: (value) {
                            setState(() {
                              _intuitionItems[index] = value;
                            });
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Enter intuition point',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: 'Remove',
                        color: Theme.of(context).colorScheme.error,
                        onPressed: _intuitionItems.length > 1
                            ? () {
                                setState(() {
                                  _intuitionItems.removeAt(index);
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsField() {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: _tags,
            onChanged: (value) {
              setState(() {
                _tags = value;
              });
            },
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Tags (comma-separated)',
              labelStyle: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
              prefixIcon: const Icon(Icons.label_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              helperText: 'Example: array, string, dynamic-programming',
              helperStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags
                  .split(',')
                  .where((tag) => tag.trim().isNotEmpty)
                  .map((tag) {
                return Chip(
                  label: Text(tag.trim()),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyDropdown() {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _difficulty,
        onChanged: (value) {
          setState(() {
            _difficulty = value!;
          });
        },
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Difficulty',
          labelStyle: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          prefixIcon: const Icon(Icons.trending_up),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor:
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Easy',
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text('Easy'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Medium',
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.orange, size: 16),
                SizedBox(width: 8),
                Text('Medium'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Hard',
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text('Hard'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
