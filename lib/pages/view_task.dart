import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/loader.dart';

import '../models/todo.dart';
import '../utils/constants.dart';

//This screen is used when task is edited and saved

class ViewTask extends StatefulWidget {
  final Todo? todo;
  const ViewTask({super.key, this.todo});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  String dropdownValue = 'Business';
  DateTime? _selectedTime;

  TextEditingController? viewtitleController = TextEditingController();
  TextEditingController? viewdescriptionController = TextEditingController();
  TextEditingController? viewplaceController = TextEditingController();
  TextEditingController? viewtimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      dropdownValue = widget.todo!.type;
      viewtitleController!.text = widget.todo!.title;
      viewdescriptionController!.text = widget.todo!.description;
      viewplaceController!.text = widget.todo!.place;
      viewtimeController!.text = widget.todo!.time;
    });
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final DateTime now = DateTime.now();
      _selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      final formattedTime = DateFormat('hh:mm a').format(_selectedTime!);
      setState(() {
        viewtimeController!.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiary,
      appBar: AppBar(
        backgroundColor: tertiary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: primary,
            size: 30,
          ),
        ),
        title: const Text(
          'Edit your thing',
          style: TextStyle(
              fontFamily: 'Medium', fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: getWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: primary),
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      color: primary,
                      height: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 100),
                  child: Form(
                      child: Column(
                    children: [
                      SizedBox(
                        width: getWidth(context),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          elevation: 0,
                          borderRadius: BorderRadius.circular(14),
                          dropdownColor: primary,
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 20,
                              color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['Business', 'Personal']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: viewtitleController,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 20,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.2)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: viewdescriptionController,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 20,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.2)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: viewplaceController,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 20,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Place',
                            hintStyle: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.2)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: viewtimeController,
                          onTap: () {
                            _selectTime(context);
                          },
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 20,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Time',
                            hintStyle: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.2)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3))),
                          ),
                        ),
                      ),
                      Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 28.0),
                          child: InkWell(
                            onTap: () async {
                              Todo newTodo = Todo(
                                  id: widget.todo!.id,
                                  title: viewtitleController!.text,
                                  description: viewdescriptionController!.text,
                                  place: viewplaceController!.text,
                                  time: viewtimeController!.text,
                                  type: dropdownValue,
                                  isCompleted: false);

                              await taskProvider.updateTodo(newTodo);
                              /*viewtitleController!.clear();
                              viewdescriptionController!.clear();
                              viewtimeController!.clear();
                              viewplaceController!.clear();*/
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: primary.withOpacity(0.08), width: 1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: getWidth(context),
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: Center(
                                        child: taskProvider.isLoading
                                            ? const Loader(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                'Update your thing',
                                                style: TextStyle(
                                                    fontFamily: 'SemiBold',
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
