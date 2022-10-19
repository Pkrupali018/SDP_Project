import 'package:flutter/material.dart';
import 'package:lookup/colors.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  const SenderMessageCard({Key? key, required this.message, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      // Deside the size of the  box for sender decrease the size of sender box.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width-45,
        ),
        //Give the apropriate layout to the messages.
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //Display the message and time
          child: Stack(
            children: [
              Padding(
                // To gave the padding to senders card.
                padding: const EdgeInsets.only(
                  left: 10, 
                  right: 30, 
                  top: 5, 
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style:const TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
              //This is with respect to message from message this is 2 point bottom and 10 point right
              Positioned(
                bottom: 2,
                right: 10,
                child:
                //  Row(
                //   children: [
                    Text(
                      date, 
                      style: const TextStyle(
                        fontSize: 13
                      ),
                    )
                //   ],
                // ),
              ),
            ],
          ),
       ),
      ),
    );
  }
}