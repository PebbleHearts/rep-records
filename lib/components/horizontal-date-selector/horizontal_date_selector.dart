import 'package:flutter/material.dart';
import 'package:rep_records/components/horizontal-date-selector/date_item.dart';
import 'package:rep_records/theme/app_theme.dart';
import 'package:rep_records/util/date.dart';
import 'package:rep_records/util/debounce.dart';

class HorizontalDateSelector extends StatefulWidget {
  final String selectedDate;
  final ValueSetter<DateTime> onDateTap;
  final VoidCallback? onPeriodLabel;
  const HorizontalDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
    this.onPeriodLabel,
  });

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  final _debouncer = Debouncer(milliseconds: 100);
  final _scrollController = ScrollController();
  List<DateTime> _datesList = [];
  double _initialMaxScrollExtent = 0.0;
  String _yearMonthLabel = getHorizontalListDateMonthLabel(
    DateTime.now(),
    DateTime.now().subtract(
      const Duration(days: 7),
    ),
  );

  void _handleYearMonthLabel(double pixels, double viewPortDimension) {
    int firstIndex = ((pixels + 0.001) / 50).ceil();
    int numberOfItemsViewable = (viewPortDimension / 50).floor();
    int lastIndex = firstIndex + numberOfItemsViewable;
    setState(() {
      _yearMonthLabel = getHorizontalListDateMonthLabel(
          _datesList[firstIndex], _datesList[lastIndex]);
    });
  }

  void _loadMore() {
    final pixels = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final viewportDimension = _scrollController.position.viewportDimension;

    _debouncer.run(() {
      _handleYearMonthLabel(pixels, viewportDimension);
    });

    if (_initialMaxScrollExtent == 0) {
      _initialMaxScrollExtent = maxScrollExtent;
    }
    if (pixels >= maxScrollExtent) {
      List<DateTime> nextPreviousList = getPrevious30Days(
        fromDate: _datesList[_datesList.length - 1],
        includeFromDate: false,
      );
      setState(() {
        _datesList = [
          ..._datesList,
          ...nextPreviousList,
        ];
      });
    } else if (pixels <= 0) {
      List<DateTime> nextList = getNext30Days(
        fromDate: _datesList[0],
        includeFromDate: false,
      );
      setState(() {
        _datesList = [
          ...nextList,
          ..._datesList,
        ];
      });
      
      // Wait for the widget to rebuild before jumping to the new position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _initialMaxScrollExtent + viewportDimension - 0.5,
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _datesList = getPrevious30Days(
      fromDate: DateTime.now(),
      includeFromDate: true,
    );

    Future.delayed(const Duration(seconds: 1), () {
      final pixels = _scrollController.position.pixels;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final viewportDimension = _scrollController.position.viewportDimension;

      List<DateTime> nextList = getNext30Days(
        fromDate: _datesList[0],
        includeFromDate: false,
      );
      setState(() {
        _datesList = [
          ...nextList,
          ..._datesList,
        ];
      });
      
      // Wait for the widget to rebuild before jumping to the new position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            maxScrollExtent + viewportDimension - 0.5,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppTheme>()!.background3,
      ),
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: widget.onPeriodLabel,
                splashColor: Colors.deepPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.deepPurple.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _yearMonthLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.deepPurple,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: _datesList.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return DateItem(
                  dateObject: _datesList[index],
                  selectedDate: widget.selectedDate,
                  onDateTap: widget.onDateTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
