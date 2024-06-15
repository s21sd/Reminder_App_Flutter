import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/ui/theme.dart';
import 'package:reminder_app/ui/widgets/input_field.dart';
import 'package:reminder_app/ui/widgets/buttons.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9.30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                  title: "Note",
                  hint: "Enter your note",
                  controller: _noteController),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStarTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStarTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                  )),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  value: _selectedRemind,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedRemind = newValue!;
                    });
                  },
                  items: remindList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  value: _selectedRepeat,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateForm()),
                ],
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  // To validate the form
  _validateForm() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // Add to the database
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmail) {
      Get.snackbar("Required", "All field are required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 30,
          ));
    }
  }

  // For the app bar
  _appBar(BuildContext context) {
    return AppBar(
      // elevation: 0,
      backgroundColor: Colors.amber,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back,
            size: 20, color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/user3.jpg'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  // For the calender

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  // For the time pick

  _getTimeFromUser({required bool isStarTime}) async {
    var _pickedTime = await _showTimePicker();

    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("time Cancelled");
    } else if (isStarTime == true) {
      setState(() {});
      _startTime = _formatedTime;
    } else if (isStarTime == false) {
      setState(() {});
      _endTime = _formatedTime;
    }
  }

  // For the t
  _showTimePicker() {
    return showTimePicker(
        // initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

  // For the color Pallet
  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                _selectedColor = index;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
