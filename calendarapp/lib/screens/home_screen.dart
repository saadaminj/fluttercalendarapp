import 'dart:ui';

import 'package:calendarapp/blocs/login/login_bloc.dart';
import 'package:calendarapp/blocs/login/login_event.dart';
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
  late EventBloc _eventBloc;
  late LoginBloc _loginBloc;
  late List<Event> listOfEvents;

  @override
  void initState() {
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _eventBloc.add(GetEvent());
    listOfEvents = [];
    super.initState();
  }

  void logout() {
    _loginBloc.add(LogoutEvent());
    Navigator.pop(context, '/login');
  }

  void openWidget() {
    _eventBloc.add(ShowCalendarEvent());
  }

  void closeWidget() {
    _eventBloc.add(HideCalendarEvent());
  }

  void deleteItem(int id) {
    // setState(() {
    //   listOfEvents.removeWhere((item) => item.id == id);
    // });
    _eventBloc.add(DeleteEvent(id));
  }

  void saveWidget(int? id, Event event) {
    if (id == null) {
      _eventBloc.add(CreateEvent(event));
    } else {
      int index = listOfEvents.indexWhere((item) => item.id == id);
      if (index == -1) {
        _eventBloc.add(CreateEvent(event));
      } else {
        _eventBloc.add(UpdateEvent(event));
      }
    }
    _eventBloc.add(HideCalendarEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventBloc, EventState>(listener: (context, state) {
      if (state is GetEventsState) {
        setState(() {
          listOfEvents = state.eventslist;
        });
      }
      if (state is UpdateEventState ||
          state is CreateEventState ||
          state is DeleteEventState) {
        _eventBloc.add(GetEvent());
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
        _eventBloc.add(EventInitialEvent());
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text("Calendar"),
          automaticallyImplyLeading: false,
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
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                              onRefresh: () {
                                _eventBloc.add(GetEvent());
                                return Future.value();
                              },
                              child: ListView.builder(
                                  itemCount: listOfEvents.isEmpty
                                      ? 1
                                      : listOfEvents.length,
                                  itemBuilder: (context, index) {
                                    if (listOfEvents.isEmpty) {
                                      return SizedBox(
                                          height: 20,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Center(
                                              child:
                                                  Text('No items available')));
                                    }

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
                                            _eventBloc.add(ShowCalendarEvent(
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
                                              _eventBloc.add(ShowCalendarEvent(
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
                                  })),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 16,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        shape: const CircleBorder(), // Make the button round
                        padding: const EdgeInsets.all(
                            20), // Adjust padding to increase button size
                      ),
                      onPressed: logout,
                      child: const Icon(Icons.logout),
                    ),
                  ),
                ],
              ),
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
