import 'dart:io';

import 'package:flutter/material.dart';

class EditingThumbnailRow extends StatefulWidget {

  EditingThumbnailRow({key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditingThumbnailRow();
  }
}

class _EditingThumbnailRow extends State<EditingThumbnailRow> {
  List<File> pictures = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          // Action Row
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('From Camera'),
              ),
              FlatButton(
                child: Text('From Albums'),
              ),
            ],
          ),
          // Picture Thumbnail
          Row(
            children: pictures.map<Widget>((picture) {
              return Container(
                child: Image.file(picture),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}