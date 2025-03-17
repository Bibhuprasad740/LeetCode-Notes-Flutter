import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/section.dart';
import '../providers/section_provider.dart';

class AddSectionForm extends StatefulWidget {
  final VoidCallback onClose;
  final Section? initialSection;
  final bool isEditing;
  const AddSectionForm({
    super.key,
    required this.onClose,
    this.initialSection,
    this.isEditing = false,
  });

  @override
  State<AddSectionForm> createState() => _AddSectionFormState();
}

class _AddSectionFormState extends State<AddSectionForm> {
  final TextEditingController _sectionNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      _sectionNameController.text = widget.initialSection!.name;
    }
  }

  @override
  void dispose() {
    _sectionNameController.dispose();
    super.dispose();
  }

  void _handleAddSection() async {
    if (_sectionNameController.text.trim().isNotEmpty) {
      final sectionProvider =
          Provider.of<SectionProvider>(context, listen: false);
      if (widget.initialSection == null) {
        await sectionProvider.addSection(_sectionNameController.text.trim());
      } else {
        await sectionProvider.updateSection(
          widget.initialSection!.id,
          _sectionNameController.text.trim(),
        );
      }
      setState(() {
        _sectionNameController.clear();
      });

      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Section',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sectionNameController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Enter section name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.folder, color: Colors.indigo),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onClose,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: Text('Cancel',
                      style: theme.textTheme.bodySmall!.copyWith(fontSize: 14)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleAddSection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Create Section'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
