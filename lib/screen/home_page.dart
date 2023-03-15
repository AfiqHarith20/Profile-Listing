import 'package:profile_listing/models/attendance.dart';
import 'package:profile_listing/screen/add_attendance_record_screen.dart';
import 'package:profile_listing/screen/record_detail_page.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:profile_listing/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final List<Attendance> _attendance;
  const HomePage({
    super.key,
    required List<Attendance> attendance,
  }) : _attendance = attendance;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Attendance> _filteredAttendance = List.from(widget._attendance);
  late List<Attendance> _filteredAttendanceList;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isToggle = false;
  late bool _showSearchBar = false;
  bool _endReached = false;

  final DateFormat _ddMMMYYFormat = DateFormat("dd MM yyyy, h:mm:a");

  void _addAttendanceRecord() {
    final newAttendance = Attendance(
      user: '',
      phoneNum: '',
      checkIn: DateTime.now(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAttandanceRecordScreen(
            attendance: newAttendance,
            onSave: (attendance) {
              setState(() {
                widget._attendance.add(attendance);
                _filteredAttendance.add(attendance);
              });
              Navigator.pop(context);
              _showSuccessSnackBar();
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
    timeago.setLocaleMessages('en', timeago.FrMessages());
    //load the saved state of the toggle button
    SharedPreferences.getInstance().then((prefs) {
      _isToggle = prefs.getBool("isToggle") ?? false;
      if (mounted) setState(() {});
    });
    _filteredAttendanceList = widget._attendance;
    _searchController.addListener(_handleSearch);
    _scrollController.addListener(_checkEndReached);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _scrollController.removeListener(_checkEndReached);
    super.dispose();
  }

  void _checkEndReached() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _endReached = true;
      });
    }
  }

  void _handleSearch() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredAttendance = widget._attendance.where((attendance) {
        return attendance.user.toLowerCase().contains(keyword) ||
            attendance.phoneNum.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  // void _openSearchPage() {
  //   Navigator.pushNamed(context, SearchPage.routeName, arguments: {
  //     'attendance': _filteredAttendance,
  //     'onSearch': onSearch,
  //   });
  // }

  void onSearch(List<Attendance> filteredList) {
    setState(() {
      _filteredAttendanceList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedAttendances = _filteredAttendance.sort(
      (a, b) => b.checkIn.compareTo(a.checkIn),
    );
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Attendance Record"),
            actions: <Widget>[
              AnimatedIconButton(
                splashColor: Colors.transparent,
                duration: const Duration(seconds: 2),
                icons: const [
                  AnimatedIconItem(
                    icon: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 218, 237, 47),
                    ),
                  ),
                ],
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Search"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                    labelText: "Enter name or phone number"),
                                onChanged: (text) {
                                  setState(() {
                                    _filteredAttendanceList =
                                        widget._attendance.where((attendance) {
                                      final keyword = text.toLowerCase();
                                      return attendance.user
                                              .toLowerCase()
                                              .contains(keyword) ||
                                          attendance.phoneNum
                                              .toLowerCase()
                                              .contains(keyword);
                                    }).toList();
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              child: const Text("Search"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _showSearchBar = true;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              //toggle button to change the time format
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  activeColor: Colors.blue,
                  value: _isToggle,
                  onChanged: (value) {
                    setState(() {
                      _isToggle = value;
                    });
                    // save the state of the toggle button
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setBool('isToggle', _isToggle);
                    });
                  },
                ),
              )
            ],
          ),
          body: _showSearchBar
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredAttendance.length + (_endReached ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_endReached && index == _filteredAttendance.length) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child:
                            const Text("You have reached the end of the list"),
                      );
                    }
                    final attendance = _filteredAttendance[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecordDetailsPage(attendance: attendance),
                            ),
                          );
                        },
                        title: Text(attendance.user),
                        subtitle: Text(attendance.phoneNum),
                        trailing: Text(
                          _isToggle
                              ? _ddMMMYYFormat.format(attendance.checkIn)
                              : timeago.format(attendance.checkIn,
                                  locale: "en_short"),
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredAttendance.length + (_endReached ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_endReached && index == _filteredAttendance.length) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child:
                            const Text("You have reached the end of the list"),
                      );
                    }

                    final attendance = _filteredAttendance[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecordDetailsPage(attendance: attendance),
                            ),
                          );
                        },
                        title: Text(attendance.user),
                        subtitle: Text(attendance.phoneNum),
                        trailing: Text(
                          _isToggle
                              ? _ddMMMYYFormat.format(attendance.checkIn)
                              : timeago.format(attendance.checkIn,
                                  locale: "en_short"),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: AnimatedIconButton(
            duration: const Duration(milliseconds: 100),
            splashColor: Colors.transparent,
            onPressed: _addAttendanceRecord,
            icons: const [
              AnimatedIconItem(
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("New Attendance Record added Successfully!"),
    ));
  }
}
