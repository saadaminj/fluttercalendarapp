import 'package:calendarapp/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OverlayPopup extends StatefulWidget {
  final VoidCallback onClose;
  final int id;
  final Function(int, Events) onSave;
  final Events? event;
  late TextEditingController _textController;
  late TimeOfDay _selectedTime;
  late DateTime _selectedDate;

  final _formKey = GlobalKey<FormState>();
  OverlayPopup(
      {super.key,
      required this.onClose,
      required this.onSave,
      required this.id,
      this.event}) {
    if (event != null) {
      _textController = TextEditingController(text: event!.title);
      _selectedTime = event!.time;
      _selectedDate = event!.date;
    } else {
      _textController = TextEditingController(text: '');
      _selectedTime = TimeOfDay.now();
      _selectedDate = DateTime.now();
    }
  }

  @override
  OverlayPopupState createState() => OverlayPopupState();
}

class OverlayPopupState extends State<OverlayPopup> {
  String? _errorMessage;
  OverlayPopupState();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget._selectedTime,
    );
    if (picked != null && picked != widget._selectedTime) {
      setState(() {
        widget._selectedTime = picked;
      });
    }
  }

  void onWidgetSave() {
    DateTime now = DateTime.now();
    bool sameDate = DateTime(widget._selectedDate.year,
            widget._selectedDate.month, widget._selectedDate.day) ==
        DateTime(now.year, now.month, now.day);
    if ((sameDate && widget._selectedTime.hour < now.hour) ||
        (sameDate &&
            widget._selectedTime.hour == now.hour &&
            widget._selectedTime.minute < now.minute) ||
        !(widget._formKey.currentState?.validate() ?? false)) {
      setState(() {
        _errorMessage = "Date and time should be in future";
      });
    } else {
      setState(() {
        _errorMessage = null;
        widget.onSave(
            widget.id,
            Events(widget.id, widget._textController.value.text.toString(),
                widget._selectedDate, widget._selectedTime));
        widget.onClose();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: widget._selectedDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget._selectedDate) {
      setState(() {
        widget._selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              )
            ],
          ),
          child: Form(
            key: widget._formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                  controller: widget._textController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Enter Title here',
                    labelStyle:
                        TextStyle(color: Colors.blueGrey[700]), // Label color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue[200]!), // Light blue border
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 1, 33, 66)), // Dark blue border when focused
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.blue[700]!), // Dark blue border for error
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.blue[200]!), // Light blue border for error
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[700], // Grey background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Round corners
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  ),
                  onPressed: () => _selectTime(context),
                  child: Text(
                      'Select Time: ${widget._selectedTime.format(context)}'),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[700], // Grey background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Round corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                  ),
                  child: Text(
                      'Select Date: ${widget._selectedDate.toLocal().toString().split(' ')[0]}'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[700], // Grey background
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100), // Round corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                      ),
                      onPressed: () {
                        onWidgetSave();
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[700], // Grey background
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100), // Round corners
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                      ),
                      onPressed: widget.onClose,
                      child: const Text('Close'),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
