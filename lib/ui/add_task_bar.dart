// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_import, avoid_unnecessary_containers, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/theme.dart';
import 'package:reminder_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = '09:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind=5;
  List<int> remindList = [5, 10, 15, 30, 60];
  String _selectedRepeat="None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly", "Yearly"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter Title',
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon:
                            Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon:
                            Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes before',
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  style: subTitleStyle,
                  value: _selectedRemind,
                  items: remindList.map((int value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedRemind = value!;
                    });
                  },
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: '$_selectedRepeat',
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  style: subTitleStyle,
                  value: _selectedRepeat,
                  items: repeatList.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Color", style: titleStyle),
                      Wrap(
                        children: [

                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

//workflow check
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/vit.png"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2123),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }


  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("Time Canceled");
    }else if(isStartTime == true){
        setState(() {
          _startTime = _formattedTime;
        });
    }else if(isStartTime == false){
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

}
