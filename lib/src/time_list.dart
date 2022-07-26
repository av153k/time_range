import 'package:flutter/material.dart';
import 'package:time_range/src/arrow_button.dart';
import 'package:time_range/src/time_button.dart';
import 'util/time_of_day_extension.dart';

typedef TimeSelectedCallback = void Function(TimeOfDay hour);

class TimeList extends StatefulWidget {
  final TimeOfDay firstTime;
  final TimeOfDay lastTime;
  final TimeOfDay? initialTime;
  final int timeStep;
  final double padding;
  final TimeSelectedCallback onHourSelected;
  final Color? borderColor;
  final Color? activeBorderColor;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final ScrollController? scrollController;
  final bool showArrows;

  TimeList({
    Key? key,
    this.padding = 0,
    required this.timeStep,
    required this.firstTime,
    required this.lastTime,
    required this.onHourSelected,
    this.initialTime,
    this.borderColor,
    this.activeBorderColor,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.textStyle,
    this.activeTextStyle,
    this.scrollController,
    this.showArrows = false,
  })  : assert(lastTime.afterOrEqual(firstTime),
            'lastTime not can be before firstTime'),
        super(key: key);

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  ScrollController _scrollController = ScrollController();
  final double itemExtent = 90;
  TimeOfDay? _selectedHour;
  List<TimeOfDay?> hours = [];

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    }
    _initialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateScroll(hours.indexOf(widget.initialTime));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TimeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstTime != widget.firstTime ||
        oldWidget.timeStep != widget.timeStep ||
        oldWidget.initialTime != widget.initialTime) {
      _initialData();
      _animateScroll(hours.indexOf(widget.initialTime));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _initialData() {
    _selectedHour = widget.initialTime;
    _loadHours();
  }

  void _loadHours() {
    hours.clear();
    var hour =
        TimeOfDay(hour: widget.firstTime.hour, minute: widget.firstTime.minute);
    while (hour.beforeOrEqual(widget.lastTime)) {
      hours.add(
          hour.hour == TimeOfDay.hoursPerDay ? hour.replacing(hour: 0) : hour);
      hour = hour.add(minutes: widget.timeStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.showArrows)
            ArrowButton(
              direction: ArrowDirection.left,
              borderColor: widget.borderColor,
              backgroundColor: widget.backgroundColor,
              onTap: _scrollLeft,
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // padding: EdgeInsets.only(left: widget.padding),
              itemCount: hours.length,
              itemExtent: itemExtent,
              itemBuilder: (BuildContext context, int index) {
                final hour = hours[index]!;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TimeButton(
                    borderColor: widget.borderColor,
                    activeBorderColor: widget.activeBorderColor,
                    backgroundColor: widget.backgroundColor,
                    activeBackgroundColor: widget.activeBackgroundColor,
                    textStyle: widget.textStyle,
                    activeTextStyle: widget.activeTextStyle,
                    time: hour.format(context),
                    value: _selectedHour == hour,
                    onSelect: (_) => _selectHour(index, hour),
                  ),
                );
              },
            ),
          ),
          if (widget.showArrows)
            ArrowButton(
              direction: ArrowDirection.right,
              borderColor: widget.borderColor,
              backgroundColor: widget.backgroundColor,
              onTap: _scrollRight,
            ),
        ],
      ),
    );
  }

  void _selectHour(int index, TimeOfDay hour) {
    _selectedHour = hour;
    _animateScroll(index);
    widget.onHourSelected(hour);
    setState(() {});
  }

  void _animateScroll(int index) {
    double offset = index < 0 ? 0 : index * itemExtent;
    if (offset > _scrollController.position.maxScrollExtent) {
      offset = _scrollController.position.maxScrollExtent;
    }
    _scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    setState(() {});
  }

  void _scrollLeft() {
    _scrollController.animateTo(_scrollController.offset - itemExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    setState(() {});
  }

  void _scrollRight() {
    _scrollController.animateTo(_scrollController.offset + itemExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    setState(() {});
  }
}
