import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/loader.dart';

//this screen is used to add a new task

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String dropdownValue = 'Business';
  DateTime? _selectedTime;

  //This function provides time in suitable format
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
        timeController!.text = formattedTime;
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
          'Add new thing',
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
                          controller: titleController,
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
                          controller: descriptionController,
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
                          controller: placeController,
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
                          controller: timeController,
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
                              await taskProvider.addTodo({
                                'title': titleController!.text,
                                'description': descriptionController!.text,
                                'place': placeController!.text,
                                'time': timeController!.text,
                                'timestamp': FieldValue.serverTimestamp(),
                                'type': dropdownValue,
                                'isCompleted': false,
                              });
                              titleController!.clear();
                              descriptionController!.clear();
                              timeController!.clear();
                              placeController!.clear();
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
                                                'Add your thing',
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
