// import 'package:profile_listing/models/attendance.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   static const String routeName = "/search";
//   final List<Attendance> _attendance;
//   final Function(List<Attendance>) onSearch;
//   const SearchPage({
//     super.key,
//     required List<Attendance> attendance,
//     required this.onSearch,
//   }) : _attendance = attendance;

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
//               itemCount: widget._attendance.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final attendance = widget._attendance[index];
//                 return ListTile(
//                   title: Text(attendance.user),
//                   subtitle: Text(attendance.phoneNum),
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
//     final filteredAttendanceList = widget._attendance.where((attendance) {
//       return attendance.user.toLowerCase().contains(keyword) ||
//           attendance.phoneNum.toLowerCase().contains(keyword);
//     }).toList();
//     widget.onSearch(filteredAttendanceList);
//     Navigator.pop(context);
//   }
// }
