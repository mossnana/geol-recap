import 'package:flutter/material.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';

class UserView extends StatefulWidget {
  @override
  State<UserView> createState() {
    return _UserView();
  }
}

class _UserView extends State<UserView> {
  TextEditingController _name;
  TextEditingController _position;
  final FocusNode _nameNode = FocusNode();
  final FocusNode _positionNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _position = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Setting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name',
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _name,
                focusNode: _nameNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _nameNode.unfocus();
                  FocusScope.of(context).requestFocus(_positionNode);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Position',
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _position,
                focusNode: _positionNode,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () async {
                  var result = await TableUserDelegate.save({'name': _name.text, 'role': _position.text});
                  print(result);
                  Navigator.of(context).pop();
                },
                color: Colors.lightBlue,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Set',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}