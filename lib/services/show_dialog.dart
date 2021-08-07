import 'package:flutter/material.dart';

class ShowDialog {
  Future<void> showDialogg(
      String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  "https://media.istockphoto.com/vectors/red-alert-icon-vector-id1152189152?k=6&m=1152189152&s=612x612&w=0&h=4V3_21-wv25cMtdjBCL78WtFueQAdpVxwCQUNQW7IcA=",
                  height: 20,
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              )
            ],
          ),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                fct();
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
  Future<void> authErrorDialog(
       String subtitle, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  "https://media.istockphoto.com/vectors/red-alert-icon-vector-id1152189152?k=6&m=1152189152&s=612x612&w=0&h=4V3_21-wv25cMtdjBCL78WtFueQAdpVxwCQUNQW7IcA=",
                  height: 20,
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Error occurred"),
              )
            ],
          ),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
