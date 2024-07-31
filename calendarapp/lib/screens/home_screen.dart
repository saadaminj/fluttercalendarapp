import 'dart:ui';

import 'package:calendarapp/screens/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendarapp/blocs/events/events_event.dart';
import 'package:calendarapp/blocs/events/events_state.dart';

import '../blocs/events/events_bloc.dart';
import '../src/generated/protos/events.pb.dart';
import 'overlaywidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool loading = false;
  late EventBloc _bloc;
  late List<Event> listOfEvents;

  @override
  void initState() {
    _bloc = BlocProvider.of<EventBloc>(context);
    _bloc.add(GetEvent());
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
    // setState(() {
    //   listOfEvents.removeWhere((item) => item.id == id);
    // });
    _bloc.add(DeleteEvent(id));
  }

  void saveWidget(int id, Event event) {
    int index = listOfEvents.indexWhere((item) => item.id == id);
    if (index == -1) {
      _bloc.add(CreateEvent(event));
      // setState(() {
      //   listOfEvents.add(Event(
      //       id: id, title: event.title, date: event.date, time: event.time));
      // });
    } else {
      _bloc.add(UpdateEvent(event));
      // setState(() {
      //   listOfEvents[index].date = event.date;
      //   listOfEvents[index].time = event.time;
      //   listOfEvents[index].title = event.title;
      // });
    }
    _bloc.add(HideCalendarEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventBloc, EventState>(listener: (context, state) {
      print(state);
      print(state);
      if (state is GetEventsState) {
        setState(() {
          listOfEvents = state.eventslist;
        });
      }
      if (state is UpdateEventState ||
          state is CreateEventState ||
          state is DeleteEventState) {
        _bloc.add(GetEvent());
      }
      if (state is EventLoading) {
        setState(() {
          loading = true;
        });
      }
      if (state is EventLoaded) {
        setState(() {
          loading = false;
        });
      }
      if (state is RequestFailedState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${state.msg} ")));
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
                        RefreshIndicator(
                            onRefresh: () {
                              _bloc.add(GetEvent());
                              return Future.value();
                            },
                            child: Flexible(
                              child: ListView.builder(
                                  itemCount: listOfEvents.length,
                                  itemBuilder: (context, index) {
                                    final item = listOfEvents[index];
                                    final itemDate = parseTimeOfDay(item.time);
                                    return Dismissible(
                                        key: Key(item.id.toString()),
                                        background: Container(
                                            color: Colors.green,
                                            child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0),
                                                    child: Icon(Icons.edit,
                                                        color: Colors.white)))),
                                        secondaryBackground: Container(
                                            color: Colors.red,
                                            child: const Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
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
                                            if (confirmed != null &&
                                                confirmed) {
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  '${itemDate.hour.toString()}:${itemDate.minute.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            ))
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
