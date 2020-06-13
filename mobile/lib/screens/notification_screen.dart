import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/widgets/loading_widget.dart';

class NotificationScreen extends StatelessWidget {
  User user;
  NotificationScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NotificationDelegate.getNotificationsFromUid(uid: user.uid),
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: SafeArea(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) {
                    print(snapshot.data[index]['createdTime']);
                    MyNotification notification = MyNotification.fromJson(
                        snapshot.data[index].data
                    );
                    return ListTile(
                      title: Text(notification.message,),
                      subtitle: Text(DateTimeDelegate.toHumanString(notification.createdTime)),
                    );
                  },
                  itemCount: snapshot.data.length,
                ),
              ),
            );
          default:
            return LoadingWidget();
        }
      },
    );
  }
}