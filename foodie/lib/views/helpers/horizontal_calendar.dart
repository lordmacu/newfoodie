import 'package:flutter/material.dart';
import 'package:foodie/views/helpers/date_helper.dart';
import 'package:foodie/views/helpers/date_widget.dart';

typedef DateBuilder = bool Function(DateTime dateTime);

typedef DateSelectionCallBack = void Function(DateTime dateTime);

class HorizontalCalendar extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final double height;
  final TextStyle monthTextStyle;
  final TextStyle selectedMonthTextStyle;
  final String monthFormat;
  final TextStyle dateTextStyle;
  final TextStyle selectedDateTextStyle;
  final String dateFormat;
  final TextStyle weekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final String weekDayFormat;
  final DateSelectionCallBack onDateSelected;
  final DateSelectionCallBack onDateLongTap;
  final DateSelectionCallBack onDateUnSelected;
  final VoidCallback onMaxDateSelectionReached;
  final Decoration defaultDecoration;
  final Decoration selectedDecoration;
  final Decoration disabledDecoration;
  final DateBuilder isDateDisabled;
  final List<DateTime> initialSelectedDates;
  final ScrollController scrollController;
  final double spacingBetweenDates;
  final EdgeInsetsGeometry padding;
  final List<LabelType> labelOrder;
  final int maxSelectedDateCount;
  final Function breakFastOnPressed;
  final Function launchOnPressed;
  final Function dinnerOnPressed;

  HorizontalCalendar({
    Key key,
    this.height = 100,
    @required this.firstDate,
    @required this.lastDate,
    this.scrollController,
    this.onDateSelected,
    this.onDateLongTap,
    this.onDateUnSelected,
    this.onMaxDateSelectionReached,
    this.maxSelectedDateCount = 1,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.monthFormat,
    this.dateTextStyle,
    this.selectedDateTextStyle,
    this.dateFormat,
    this.weekDayTextStyle,
    this.selectedWeekDayTextStyle,
    this.weekDayFormat,
    this.defaultDecoration,
    this.selectedDecoration,
    this.disabledDecoration,
    this.isDateDisabled,
    this.initialSelectedDates,
    this.spacingBetweenDates = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.labelOrder = const [
      LabelType.month,
      LabelType.date,
      LabelType.weekday,
    ],
    this.breakFastOnPressed,
    this.launchOnPressed,
    this.dinnerOnPressed
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(
          toDateMonthYear(lastDate) == toDateMonthYear(firstDate) ||
              toDateMonthYear(lastDate).isAfter(toDateMonthYear(firstDate)),
        ),
        assert(labelOrder != null && labelOrder.isNotEmpty,
            'Label Order should not be empty'),
        super(key: key);

  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final List<DateTime> allDates = [];
  final List<DateTime> selectedDates = [];
  final List<Widget> contentBreakfast = [];
  final List<Widget> contentLaunch = [];
  final List<Widget> contentDinner = [];

  @override
  void initState() {
    super.initState();
    allDates.addAll(getDateList(widget.firstDate, widget.lastDate));

    if (widget.initialSelectedDates != null) {
      selectedDates.addAll(widget.initialSelectedDates.map((toDateMonthYear)));
    }
    _initContainer();
  }

  void _initContainer() {
    int i = 0;
    allDates.forEach((item) {
      i++;
      contentBreakfast.add(_getDefaultContent("Desayuno"));
      contentLaunch.add(_getDefaultContent("Almuerzo"));
      contentDinner.add(_getDefaultContent("Cena"));
    });
  }

  Widget _getDefaultContent(String initLabel) {
    return Container(
      child:  Center(
        child: Text(
          initLabel,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontFamily: 'Quicksand Regular',
              color: Color.fromRGBO(63, 63, 63, 1),
              fontSize: 10
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Center(
        child: ListView.builder(
          controller: widget.scrollController ?? ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: allDates.length,
          itemBuilder: (context, index) {
            final date = allDates[index];

            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    DateWidget(
                      key: Key(date.toIso8601String()),
                      padding: widget.padding,
                      isSelected: selectedDates.contains(date),
                      isDisabled: widget.isDateDisabled != null
                          ? widget.isDateDisabled(date)
                          : false,
                      date: date,
                      monthTextStyle: widget.monthTextStyle,
                      selectedMonthTextStyle: widget.selectedMonthTextStyle,
                      monthFormat: widget.monthFormat,
                      dateTextStyle: widget.dateTextStyle,
                      selectedDateTextStyle: widget.selectedDateTextStyle,
                      dateFormat: widget.dateFormat,
                      weekDayTextStyle: widget.weekDayTextStyle,
                      selectedWeekDayTextStyle: widget.selectedWeekDayTextStyle,
                      weekDayFormat: widget.weekDayFormat,
                      defaultDecoration: widget.defaultDecoration,
                      selectedDecoration: widget.selectedDecoration,
                      disabledDecoration: widget.disabledDecoration,
                      labelOrder: widget.labelOrder,
                      onTap: () {
                        if (!selectedDates.contains(date)) {
                          if (widget.maxSelectedDateCount == 1 &&
                              selectedDates.length == 1) {
                            selectedDates.clear();
                          } else if (widget.maxSelectedDateCount ==
                              selectedDates.length) {
                            if (widget.onMaxDateSelectionReached != null) {
                              widget.onMaxDateSelectionReached();
                            }
                            return;
                          }

                          selectedDates.add(date);
                          if (widget.onDateSelected != null) {
                            widget.onDateSelected(date);
                          }
                        } else {
                          final isRemoved = selectedDates.remove(date);
                          if (isRemoved && widget.onDateUnSelected != null) {
                            widget.onDateUnSelected(date);
                          }
                        }
                        setState(() {});
                      },
                      onLongTap: () => widget.onDateLongTap != null
                          ? widget.onDateLongTap(date)
                          : null,
                    ),
                    SizedBox(width: widget.spacingBetweenDates),
                  ],
                ),
                SizedBox(height: 10.0,),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          widget.breakFastOnPressed(this, date, index, contentBreakfast);
                        },
                        child: Container(
                          width: 120,
                          height: 55,
                          child: contentBreakfast[index],
                          decoration: BoxDecoration(
                              border: Border.all(color: Color.fromRGBO(193, 191, 202, 1))
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: () {
                          widget.launchOnPressed(this, date, index, contentLaunch);
                        },
                        child: Container(
                          width: 120,
                          height: 55,
                          child: contentLaunch[index],
                          decoration: BoxDecoration(
                              border: Border.all(color: Color.fromRGBO(193, 191, 202, 1))
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: () {
                          widget.dinnerOnPressed(this, date, index, contentDinner);
                        },
                        child: Container(
                          width: 120,
                          height: 55,
                          child: contentDinner[index],
                          decoration: BoxDecoration(
                              border: Border.all(color: Color.fromRGBO(193, 191, 202, 1))
                          ),
                        )
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
