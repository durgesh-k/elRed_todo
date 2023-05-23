import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/view_task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/completeDialog.dart';

import 'deleteDialog.dart';

//this is the basic card to show a task

class TodoCard extends StatefulWidget {
  final Todo? todo;
  const TodoCard({super.key, this.todo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool extend = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, todoProvider, child) => InkWell(
        onTap: () {
          setState(() {
            extend = !extend;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, extend ? 16.0 : 0.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 14),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: secondary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SvgPicture.asset(
                        widget.todo!.type == 'Business'
                            ? 'assets/icons/briefcase.svg'
                            : 'assets/icons/clipboard-text.svg',
                        height: 20,
                        color: primary,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      widget.todo!.isCompleted
                          ? Icon(Icons.check, color: Colors.green)
                          : Container(),
                      Text(
                        widget.todo!.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Bold', color: secondary, fontSize: 20),
                      ),
                    ],
                  ),
                  subtitle: Text(widget.todo!.description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Medium',
                          color: secondary.withOpacity(0.6),
                          fontSize: 16)),
                  trailing: Text(
                    widget.todo!.time,
                    style: TextStyle(
                        fontFamily: 'Medium',
                        color: secondary.withOpacity(0.3),
                        fontSize: 16),
                  ),
                ),
              ),
              extend
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut,
                                    type: PageTransitionType.bottomToTop,
                                    child: ViewTask(
                                      todo: widget.todo,
                                    ))),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 40),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      fontSize: 16,
                                      color: secondary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getWidth(context) * 0.02,
                          ),
                          InkWell(
                            onTap: (() =>
                                showConfirmDeleteDialog(context, widget.todo!)),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: getWidth(context) * 0.02,
                          ),
                          InkWell(
                            onTap: (() => showConfirmCompleteDialog(
                                context, widget.todo!)),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Divider(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
