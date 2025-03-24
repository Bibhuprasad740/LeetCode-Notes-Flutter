import 'package:flutter/material.dart';

class ConsistencyTracker extends StatefulWidget {
  final Map<DateTime, bool> activityData;

  const ConsistencyTracker({
    required this.activityData,
    super.key,
  });

  @override
  State<ConsistencyTracker> createState() => _ConsistencyTrackerState();
}

class _ConsistencyTrackerState extends State<ConsistencyTracker>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDate;
  final now = DateTime.now();
  late AnimationController _animationController;
  late Animation<Offset> _currentSlideAnimation;
  late Animation<Offset> _nextSlideAnimation;
  bool _isAnimating = false;
  late DateTime _nextDate;

  @override
  void initState() {
    super.initState();
    print('activity data: ${widget.activityData}');
    selectedDate = DateTime(now.year, now.month);
    _nextDate = selectedDate;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _currentSlideAnimation = _animationController.drive(Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ));

    _nextSlideAnimation = _animationController.drive(Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          selectedDate = _nextDate;
          _isAnimating = false;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimations(bool isSlideRight) {
    setState(() {
      _currentSlideAnimation = _animationController.drive(Tween<Offset>(
        begin: Offset.zero,
        end: Offset(isSlideRight ? 1 : -1, 0),
      ));

      _nextSlideAnimation = _animationController.drive(Tween<Offset>(
        begin: Offset(isSlideRight ? -1 : 1, 0),
        end: Offset.zero,
      ));
    });
  }

  Future<void> _goToPreviousMonth() async {
    if (_isAnimating) return;
    _isAnimating = true;
    _nextDate = DateTime(selectedDate.year, selectedDate.month - 1);
    _updateAnimations(true);
    await _animationController.forward();
  }

  Future<void> _goToNextMonth() async {
    if (_isAnimating) return;
    if (selectedDate.year == now.year && selectedDate.month == now.month) {
      return;
    }

    _isAnimating = true;
    _nextDate = DateTime(selectedDate.year, selectedDate.month + 1);
    _updateAnimations(false);
    await _animationController.forward();
  }

  Widget _buildMonthContent(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final consistentDays = _getConsistentDays(date);
    final completionRate = (consistentDays / daysInMonth * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMonthName(date.month),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.year}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.swipe,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              _buildProgressIndicator(completionRate),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '$consistentDays days consistent',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            shrinkWrap: true,
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final currentDate = DateTime(
                date.year,
                date.month,
                index + 1,
              );
              final isActive = widget.activityData[currentDate] ?? false;
              final isToday = currentDate.year == now.year &&
                  currentDate.month == now.month &&
                  currentDate.day == now.day;

              return _buildDayCell(context, index + 1, isActive, isToday);
            },
          ),
        ),
      ],
    );
  }

  int _getConsistentDays(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int consistentDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(date.year, date.month, day);
      if (widget.activityData[currentDate] ?? false) {
        consistentDays++;
      }
    }

    return consistentDays;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _goToPreviousMonth();
        } else if (details.primaryVelocity! < 0) {
          _goToNextMonth();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            SlideTransition(
              position: _currentSlideAnimation,
              child: _buildMonthContent(selectedDate),
            ),
            if (_isAnimating)
              SlideTransition(
                position: _nextSlideAnimation,
                child: _buildMonthContent(_nextDate),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.trending_up_rounded,
            color: Colors.green,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
      BuildContext context, int day, bool isActive, bool isToday) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
