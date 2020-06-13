import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/widgets/editor/editor.dart';

class NewsfeedTransaction extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  NewsfeedTransaction({this.documentSnapshot});

  @override
  State<NewsfeedTransaction> createState() {
    return _NewsfeedTransaction();
  }

}

class _NewsfeedTransaction extends State<NewsfeedTransaction> {
  DocumentSnapshot _documentSnapshot;

  @override
  void initState() {
    super.initState();
    _documentSnapshot = widget.documentSnapshot;
  }

  void _goToPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostFragment()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Map<String, dynamic> data = _documentSnapshot.data;
    Widget postImage = data['imageUrls'].isNotEmpty ? Image.network(
      '${data['imageUrls'][0]}',
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.low,
    ) : Image.network(
      'https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819_1280.jpg',
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.low,
    );
    return GestureDetector(
      onTap: _goToPost,
      child: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.black,
                margin: EdgeInsets.only(
                    top: 10
                ),
                height: screenSize.height * 0.228,
                child: postImage
              ),
              Container(
                child: Text('${data['title']}', style: Theme.of(context).textTheme.title,),
              ),
            ],
          ),
          subtitle: Text('${data['subTitle']}', style: Theme.of(context).textTheme.subtitle,),
        ),
      ),
    );
  }

}