import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final Community community;

  const CommunityCard({Key? key, required this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Aumentar el valor de elevación para un borde más grueso
      shadowColor: Color.fromRGBO(126, 75, 138, 1),
      color: Color.fromRGBO(84, 50, 92, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Ajustar el radio del borde
        side: BorderSide(
          color: Color.fromRGBO(126, 75, 138, 1), // Color del borde
          width: 1.0, // Grosor del borde
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(3.0),
        height: 160.0,
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 115.0,
              width: 115.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(community.photo),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  community.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  community.followers.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
