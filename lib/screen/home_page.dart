import 'package:flutter/material.dart';

import 'package:profile_listing/models/user_model.dart';

import 'package:profile_listing/screen/add_user_screen.dart';
import 'package:profile_listing/screen/profile_page.dart';
import 'package:profile_listing/widget/slidable_widget.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel user;
  bool isDataLoaded = false;
  String errorMessage = '';
  // List<dynamic> user = [];
  bool isLoading = false;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isToggle = false;
  late bool _showSearchBar = false;
  bool _endReached = false;
  late int _currentPage = 1;
  late int _totalPage = 2;
  late int _perPage = 6;

  @override
  void initState() {
    super.initState();
    //load the saved state of the toggle button
    SharedPreferences.getInstance().then((prefs) {
      _isToggle = prefs.getBool("isToggle") ?? false;
      if (mounted) setState(() {});
    });
    // _searchController.addListener(_handleSearch);
    _scrollController.addListener(_checkEndReached);
    callAPIandAssignData();
    // this.fetchUserJson();
    // if (_currentPage < _totalPage) {
    //   _currentPage++;
    //   this.fetchUserJson();
    // }
  }

  Future<UserModel> getDataFromAPI() async {
    Uri uri = Uri.parse('https://reqres.in/api/users?page=1');
    var response = await http.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // All ok
      UserModel usersPets = userModelFromJson(response.body);
      setState(() {
        isDataLoaded = true;
      });
      return usersPets;
    } else {
      errorMessage = '${response.statusCode}: ${response.body} ';
      return UserModel(data: []);
    }
  }

  void deleteUser({required int id}) async {
    Uri uri = Uri.parse("https://reqres.in/api/users/$id");
    var response = await http.delete(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully delete user"),
          backgroundColor: Colors.blueAccent,
        ),
      );
      Navigator.pop(context);
    }
  }

  callAPIandAssignData() async {
    user = await getDataFromAPI();
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

  // void _handleSearch() {
  //   final keyword = _searchController.text.toLowerCase();
  //   setState(() {
  //     _filteredAttendance = user.where((user) {
  //       return user.user.toLowerCase().contains(keyword) ||
  //           user.phoneNum.toLowerCase().contains(keyword);
  //     }).toList();
  //   });
  // }

  // void _openSearchPage() {
  //   Navigator.pushNamed(context, SearchPage.routeName, arguments: {
  //     'attendance': _filteredAttendance,
  //     'onSearch': onSearch,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUserScreen(
                      addUser: user.data[_currentPage],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text("My Contact"),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh_outlined),
                  onPressed: getDataFromAPI,
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
                    child: isDataLoaded
                        ? errorMessage.isNotEmpty
                            ? Text(errorMessage)
                            : user.data.isEmpty
                                ? const Text('No Data')
                                : ListView.builder(
                                    itemCount: user.data.length,
                                    itemBuilder: (context, index) {
                                      return SlidableWidget(
                                        onDismissed: (action) =>
                                            dismissSlidableItem(
                                                context, index, action),
                                        edits: user.data[index],
                                        child: getCard(index),
                                      );
                                    })
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableActions action) {
    setState(() {
      user.data.removeAt(index);
      profile:
      user.data[index];
    });

    switch (action) {
      case SlidableActions.delete:
        break;
      // case SlidableActions.edit:
      //   break;
    }
  }

  // Widget getBody() {
  //   if (user.data.contains(null) || user.data.length < 0 || isLoading)
  //     return Center(
  //       child: CircularProgressIndicator(),
  //       heightFactor: 30,
  //       widthFactor: 30,
  //     );
  //   return ListView.builder(
  //       itemCount: user.data.length,
  //       itemBuilder: (context, index) {
  //         return getCard(index);
  //       });
  // }

  Widget getCard(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          trailing: Icon(Icons.send_rounded),
          onLongPress: () {
            final String userInfo =
                "Avatar: ${user.data[index].avatar}\nFirst Name: ${user.data[index].firstName}\nLast Name: ${user.data[index].lastName}\nEmail: ${user.data[index].email}";
            Share.share(userInfo, subject: "User Profile Info");
          },
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  profile: user.data[index],
                ),
              ),
            );
          },
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
                    image: NetworkImage(user.data[index].avatar),
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
                    user.data[index].firstName +
                        " " +
                        user.data[index].lastName,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.data[index].email,
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
