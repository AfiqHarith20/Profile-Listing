import 'dart:convert';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:profile_listing/models/attendance.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/scoped/scoped_user.dart';
import 'package:profile_listing/screen/add_user_screen.dart';
import 'package:profile_listing/screen/record_detail_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
  List<dynamic> user = [];
  bool isLoading = false;
  late int _id;
  late String _email, _first_name, _last_name, _avatar;
  late List<Attendance> _filteredAttendance = List.from(widget._attendance);
  late List<Attendance> _filteredAttendanceList;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isToggle = false;
  late bool _showSearchBar = false;
  bool _endReached = false;
  late int _currentPage = 1;
  late int _totalPage = 2;
  late int _perPage = 6;

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
    //load the saved state of the toggle button
    SharedPreferences.getInstance().then((prefs) {
      _isToggle = prefs.getBool("isToggle") ?? false;
      if (mounted) setState(() {});
    });
    _filteredAttendanceList = widget._attendance;
    _searchController.addListener(_handleSearch);
    _scrollController.addListener(_checkEndReached);
    this.fetchUserJson();
    if (_currentPage < _totalPage) {
      _currentPage++;
      this.fetchUserJson();
    }
  }

  fetchUserJson() async {
    setState(() {
      isLoading = true;
    });
    var basedUrl = "https://reqres.in/api/users?page=1";
    var response = await http.get(Uri.parse(basedUrl)).catchError((error) {
      print(error.toString());
      return false;
    });
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      // print(items);
      setState(() {
        user = items;
        isLoading = false;
      });
    } else {
      isLoading = false;
      throw Exception("Failed to load Data");
    }
    print(response.statusCode);
  }

  // Future fetchUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   isLoading = true;

  //   var dataFromResponse = await fetchUserJson();
  //   print('USER INFO DATA *********');
  //   print(dataFromResponse);

  //   _id = dataFromResponse['data']['id'];
  //   _first_name = dataFromResponse['data']['first_name'];
  //   _last_name = dataFromResponse['data']['last_name'];
  //   _email = dataFromResponse['data']['email'];
  //   _avatar = dataFromResponse['data']['avatar'];

  //   prefs.setInt('user_id', _id);
  //   isLoading = false;
  // }

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
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("My Contact"),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh_outlined),
                  onPressed: fetchUserJson,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Search Contact",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        prefixIcon: Icon(
                          Icons.search_outlined,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      OutlinedButton(
                          child: const Text(
                            'All',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 121, 235, 208)))),
                      SizedBox(
                        width: 5,
                      ),
                      OutlinedButton(
                        child: const Text('Favourite'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: getBody(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getBody() {
    if (user.contains(null) || user.length < 0 || isLoading)
      return Center(
        child: CircularProgressIndicator(),
        heightFactor: 30,
        widthFactor: 30,
      );
    return ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          return getCard(user[index]);
        });
  }

  Widget getCard(items) {
    var fullName = items['first_name'] + '' + items['last_name'];
    var email = items['email'];
    var avatar = items['avatar'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(60 / 2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(avatar.toString()),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    fullName.toString(),
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    email.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("New Attendance Record added Successfully!"),
    ));
  }
}
