// import 'package:profile_listing/models/user.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   static const String routeName = "/search";
//   final List<user> _user;
//   final Function(List<user>) onSearch;
//   const SearchPage({
//     super.key,
//     required List<user> user,
//     required this.onSearch,
//   }) : _user = user;

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final _searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Search"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: _handleSearch,
//           )
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 hintText: "Search by name or phone number",
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget._user.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final user = widget._user[index];
//                 return ListTile(
//                   title: Text(user.user),
//                   subtitle: Text(user.phoneNum),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleSearch() {
//     final keyword = _searchController.text.toLowerCase();
//     final filtereduserList = widget._user.where((user) {
//       return user.user.toLowerCase().contains(keyword) ||
//           user.phoneNum.toLowerCase().contains(keyword);
//     }).toList();
//     widget.onSearch(filtereduserList);
//     Navigator.pop(context);
//   }
// }
