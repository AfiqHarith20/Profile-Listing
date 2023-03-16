import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/screen/add_user_screen.dart';
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
  final List<GetUserModel> _user;
  const HomePage({
    key,
    required List<GetUserModel> user,
  }) : _user = user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GetUserModel> _filtereduser = List.from(widget._user);
  late List<GetUserModel> _filtereduserList;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isToggle = false;
  late bool _showSearchBar = false;
  bool _endReached = false;

  void _adduserRecord() {
    final newuser = GetUserModel(
      email: '',
      first_name: '',
      last_name: '',
      avatar: '',
      id: '' as int,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAttandanceRecordScreen(
            user: newuser,
            onSave: (user) {
              setState(() {
                widget._user.add(user);
                _filtereduser.add(user);
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
    //load the saved state of the toggle button
    SharedPreferences.getInstance().then((prefs) {
      _isToggle = prefs.getBool("isToggle") ?? false;
      if (mounted) setState(() {});
    });
    _filtereduserList = widget._user;
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
      _filtereduser = widget._user.where((user) {
        return user.first_name.toLowerCase().contains(keyword) ||
            user.last_name.toLowerCase().contains(keyword) ||
            user.email.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  void onSearch(List<GetUserModel> filteredList) {
    setState(() {
      _filtereduserList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Contacts"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_showSearchBar)
                SizedBox(
                  height: 10,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search Contact",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _filtereduserList = widget._user.where((user) {
                        final keyword = text.toLowerCase();
                        return user.first_name
                                .toLowerCase()
                                .contains(keyword) ||
                            user.last_name.toLowerCase().contains(keyword) ||
                            user.email.toLowerCase().contains(keyword);
                      }).toList();
                    });
                  },
                ),
              ),
              Expanded(
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: _filtereduser.length + (_endReached ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_endReached && index == _filtereduser.length) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: const Text("You have reached the end of the list"),
                    );
                  }
                  final user = _filtereduser[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordDetailsPage(user: user),
                          ),
                        );
                      },
                      title: Text(user.first_name + " " + user.last_name),
                      subtitle: Text(user.email),
                    ),
                  );
                },
              ))
            ],
          ),
          floatingActionButton: AnimatedIconButton(
            duration: const Duration(milliseconds: 100),
            splashColor: Colors.transparent,
            onPressed: _adduserRecord,
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
      content: Text("New user Record added Successfully!"),
    ));
  }
}
