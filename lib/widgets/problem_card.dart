import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/problem.dart';
import '../providers/problem_provider.dart';
import 'add_problem_form.dart';

class ProblemCard extends StatefulWidget {
  final Problem problem;
  final String sectionId;

  const ProblemCard({
    super.key,
    required this.problem,
    required this.sectionId,
  });

  @override
  ProblemCardState createState() => ProblemCardState();
}

class ProblemCardState extends State<ProblemCard> {
  bool _isExpanded = false;
  bool _isEditing = false;

  // Determine difficulty color
  Color _getDifficultyColor() {
    switch (widget.problem.difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (_isEditing) {
      return AddProblemForm(
        sectionId: widget.sectionId,
        onClose: () => setState(() => _isEditing = false),
        initialProblem: widget.problem,
        isEditing: true,
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Problem Name and Difficulty
                      Expanded(
                        child: Text(
                          widget.problem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Actions (Edit, Delete, Expand)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => setState(() => _isEditing = true),
                            color: Colors.grey.shade600,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () async {
                              // Show a confirmation dialog
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete Problem',
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                        'Are you sure you want to delete this problem?',
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontSize: 16,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(false), // Cancel
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(true), // Confirm
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // If the user confirms, delete the problem
                              if (confirmed == true) {
                                final problemProvider =
                                    Provider.of<ProblemProvider>(context,
                                        listen: false);
                                problemProvider.deleteProblem(widget.problem);
                              }
                            },
                            color: Colors.grey.shade600,
                          ),
                          IconButton(
                            icon: Icon(
                              _isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _isExpanded = !_isExpanded),
                            color: _isExpanded
                                ? Colors.indigo
                                : Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Tags and Date
                  if (widget.problem.difficulty != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.problem.difficulty!,
                        style: TextStyle(
                          color: _getDifficultyColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // LeetCode Link
                      InkWell(
                        onTap: () {
                          // Open LeetCode URL
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.open_in_new,
                                  size: 14, color: Colors.indigo),
                              const SizedBox(width: 4),
                              Text(
                                'View on LeetCode',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Date Added
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d, yyyy').format(
                                DateTime.parse(widget.problem.dateAdded),
                              ),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      // Tags
                      if (widget.problem.tags != null &&
                          widget.problem.tags!.isNotEmpty)
                        ...widget.problem.tags!.take(2).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }),
                      if (widget.problem.tags != null &&
                          widget.problem.tags!.length > 2)
                        Text(
                          '+${widget.problem.tags!.length - 2}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Expanded Content
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (widget.problem.description != null &&
                        widget.problem.description!.isNotEmpty)
                      _buildSection(
                        title: 'Description',
                        color: Colors.indigo,
                        child: Text(
                          widget.problem.description!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 14),
                        ),
                      ),
                    // Image
                    if (widget.problem.imageUrl != null &&
                        widget.problem.imageUrl!.isNotEmpty)
                      _buildSection(
                        title: 'Image',
                        color: Colors.green,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.problem.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    // Sample Input and Output
                    if (widget.problem.sampleInput != null &&
                        widget.problem.sampleInput!.isNotEmpty)
                      _buildSection(
                        title: 'Sample Input',
                        color: Colors.green,
                        child: HighlightView(
                          widget.problem.sampleInput!,
                          language: 'javascript',
                          theme: atomOneLightTheme,
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    if (widget.problem.sampleOutput != null &&
                        widget.problem.sampleOutput!.isNotEmpty)
                      _buildSection(
                        title: 'Sample Output',
                        color: Colors.blue,
                        child: HighlightView(
                          widget.problem.sampleOutput!,
                          language: 'javascript',
                          theme: atomOneLightTheme,
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    // Intuition
                    if (widget.problem.intuition.isNotEmpty)
                      _buildSection(
                        title: 'Intuition',
                        color: Colors.purple,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.problem.intuition.map((point) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                '• $point',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 16),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    // Code
                    if (widget.problem.code != null)
                      _buildSection(
                        title: 'Code',
                        color: Colors.orange,
                        child: SizedBox(
                          width: double.infinity,
                          child: HighlightView(
                            widget.problem.code!,
                            language: 'c++',
                            theme: atomOneLightTheme,
                            padding: const EdgeInsets.all(12),
                            textStyle: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != 'Image'
              ? Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
