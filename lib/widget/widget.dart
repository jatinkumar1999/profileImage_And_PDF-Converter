import 'package:flutter/material.dart';

showdialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title:
              Text("edit YourName ", style: TextStyle(color: Colors.black38)),
          content: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "edit youe Name", border: InputBorder.none),
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {},
              child: Text("Update"),
            ),
          ],
        );
      });
}

textfield(text, icon, bool password) {
  bool clicked = true;
  return Container(
    decoration: BoxDecoration(
        color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
    child: TextField(
      obscureText: clicked,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        suffixIcon: password
            ? GestureDetector(onTap: () {}, child: Icon(Icons.remove_red_eye))
            : null,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
