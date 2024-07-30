import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendarapp/blocs/title/title_event.dart';
import 'package:calendarapp/blocs/title/title_state.dart';

import '../blocs/title/title_bloc.dart';
import 'overlaywidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Events {
  String title;
  final int id;
  DateTime date;
  TimeOfDay time;
  Events(this.id, this.title, this.date, this.time);
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool loading = false;
  late TitleBloc _bloc;
  late List<Events> listOfEvents;

  @override
  void initState() {
    _bloc = BlocProvider.of<TitleBloc>(context);
    listOfEvents = [];
    super.initState();
  }

  void openWidget() {
    _bloc.add(ShowCalendarEvent(id: listOfEvents.length));
  }

  void closeWidget() {
    _bloc.add(HideCalendarEvent());
  }

  void deleteItem(int id) {
    setState(() {
      listOfEvents.removeWhere((item) => item.id == id);
    });
  }

  void updateItem(int id, String newName) {
    setState(() {
      int index = listOfEvents.indexWhere((item) => item.id == id);
      if (index != -1) {
        int index = listOfEvents.indexWhere((item) => item.id == id);
        listOfEvents[index].title = newName;
      }
    });
  }

  void saveWidget(int id, Events event) {
    int index = listOfEvents.indexWhere((item) => item.id == id);
    if (index == -1) {
      setState(() {
        listOfEvents.add(Events(id, event.title, event.date, event.time));
      });
    } else {
      setState(() {
        listOfEvents[index].date = event.date;
        listOfEvents[index].time = event.time;
        listOfEvents[index].title = event.title;
      });
    }
    _bloc.add(HideCalendarEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TitleBloc, TitleState>(listenWhen: (context, state) {
      return state is TitleLoaded || state is TitleLoading;
    }, listener: (context, state) {
      if (state is TitleLoading) {
        setState(() {
          loading = true;
        });
      }
      if (state is TitleLoaded) {
        setState(() {
          loading = false;
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text("Calendar"),
        ),
        body: state is ShowCalendarState
            ? Center(
                child: Stack(children: [
                GestureDetector(
                  onTap: closeWidget,
                  child: BackdropFilter(
                    filter: ImageFilter.dilate(radiusX: 10, radiusY: 10),
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.5), // Darken the background
                    ),
                  ),
                ),
                OverlayPopup(
                  onClose: closeWidget,
                  onSave: saveWidget,
                  id: state.id,
                  event: state.event,
                ),
              ]))
            : listOfEvents.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                              itemCount: listOfEvents.length,
                              itemBuilder: (context, index) {
                                final item = listOfEvents[index];
                                return Dismissible(
                                    key: Key(item.id.toString()),
                                    background: Container(
                                        color: Colors.green,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Icon(Icons.edit,
                                                    color: Colors.white)))),
                                    secondaryBackground: Container(
                                        color: Colors.red,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: Icon(Icons.delete,
                                                    color: Colors.white)))),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        // Update action
                                        _bloc.add(ShowCalendarEvent(
                                            id: item.id, event: item));
                                      } else if (direction ==
                                          DismissDirection.endToStart) {
                                        final bool? confirmed =
                                            await showConfirmationDialog(
                                                context,
                                                "Delete Confirmation",
                                                "Are you Sure you want to delete this");
                                        if (confirmed != null && confirmed) {
                                          deleteItem(item.id);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "${item.title} deleted")));
                                          return Future.value(true);
                                        }
                                        return Future.value(false);
                                      }
                                      return false;
                                    },
                                    // onDismissed: (direction) async {
                                    //   if (direction ==
                                    //       DismissDirection.endToStart) {

                                    //   }
                                    // },
                                    child: Card(
                                      margin: const EdgeInsets.all(8.0),
                                      color: Colors.grey[850],
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        onTap: () => {
                                          _bloc.add(ShowCalendarEvent(
                                              event: item, id: item.id))
                                        },
                                        contentPadding:
                                            const EdgeInsets.all(16.0),
                                        title: Text(
                                          item.title,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(children: [
                                          Row(children: [
                                            Text(
                                              item.date
                                                  .toString()
                                                  .split(' ')[0],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              '${item.time.hour.toString()}:${item.time.minute.toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                          ]),
                                        ]),
                                        tileColor: Colors.grey[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ));
                              }),
                        )
                      ],
                    ),
                  )
                : Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: openWidget,
          tooltip: 'Add new reminder',
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
