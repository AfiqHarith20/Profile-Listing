import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/screen/edit_profile_page.dart';
import 'package:profile_listing/widget/alert_dialog.dart';

enum SlidableActions { delete }

class SlidableWidget<T> extends StatelessWidget {
  final Datum edits;
  final Widget child;
  // final Function(SlidableActions action) onDismissed;
  final Function(SlidableActions action) confirmDismiss;
  SlidableWidget({
    super.key,
    required this.child,
    // required this.onDismissed,
    required this.confirmDismiss,
    required this.edits,
  });

  @override
  Widget build(BuildContext context) => Slidable(
        endActionPane: ActionPane(motion: DrawerMotion(), children: [
          SlidableAction(
            onPressed: (context) => EditProfilePage(edit: edits),
            backgroundColor: Color.fromARGB(0, 130, 135, 3),
            foregroundColor: Colors.yellow,
            icon: Icons.edit_outlined,
          ),
          SlidableAction(
            onPressed: (context) async {
              final action = await AlertDialogs.yesCancelDialog(context,
                  "Delete", "Are you sure you want to  delete this contact? ");
              confirmDismiss(SlidableActions.delete);
            },
            backgroundColor: Color.fromARGB(0, 254, 73, 73),
            foregroundColor: Colors.red,
            icon: Icons.delete_outline_rounded,
          ),
        ]),
        child: child,
      );
}
