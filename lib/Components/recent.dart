import 'package:flutter/material.dart';

class recent extends StatefulWidget {
  const recent({super.key});

  @override
  State<recent> createState() => _recentState();
}

class _recentState extends State<recent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Cardsqueue(),
        Cardsqueue(),
        Cardsqueue(),
      ],
    );
  }
}
class Cardsqueue extends StatelessWidget {
  const Cardsqueue({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          cardsBild("assets/images/liked.png", "Liked Songs"),
          cardsBild("assets/images/logo.png", "Liked Songs"),
        ],

      ),
    );
  }
}

Card cardsBild(String img, String text){
  return Card(
    color: Colors.grey[800],
    child: Container(
      child: Row(
        children: [
          SizedBox(width: 10,),
          Image(
            width: 50,
            height: 50,
            image: AssetImage(img),
          ),
          Padding(padding: EdgeInsets.fromLTRB(10, 20,20, 20),
          child: Text(text,style: TextStyle(color: Colors.white),),)
        ],
      ),

    ),
  );
}
