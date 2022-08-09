import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Theme.of(context).accentColor,
      minimumSize: Size.fromHeight(50),
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      text == "Done" ? Text('') : Icon(icon, size: 21),
      text == "Done" ? Text('') : SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    ],
  );
}