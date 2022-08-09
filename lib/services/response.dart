import 'package:flutter/material.dart';

class Response {
  Future<String?> successAlertDialog(BuildContext context,
      {required String desc,
        required String title}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            // Image(image: AssetImage('asset/image/ok.png'),),
            // SizedBox(width: 10,),
            Text('$title'),
          ],
        ),
        content: Text('$desc'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel',
              style: TextStyle(color: Theme.of(context).accentColor),),
          ),
          TextButton(
            onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

            },
            child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ],
      ),
    );
  }


  Future<String?> failureAlertDialog(BuildContext context,
      {required String title, required String desc}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            // Image(image: AssetImage('asset/image/failed.png'),),
            // SizedBox(width: 10,),
            Text('$title'),
          ],),
        content: Text('$desc'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel',  style: TextStyle(color: Theme.of(context).accentColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor),),
          ),
        ],
      ),
    );
  }

  Future<String?> warningAlertDialog(BuildContext context,
      {required String title, required String desc,  required Null alertAction}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Image(image: AssetImage('assets/images/warning.png'),),
            SizedBox(width: 10,),
            Text('$title'),
          ],),
        content: Text('$desc'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              alertAction;
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
