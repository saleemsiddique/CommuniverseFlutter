import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:communiverse/models/models.dart'; // Asegúrate de importar tu modelo de datos aquí

class CommunityCarousel extends StatelessWidget {
  final List<Community> communities;

  const CommunityCarousel({Key? key, required this.communities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (communities.isEmpty) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: Text("Communities not found",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: size.width / size.height,
          viewportFraction: 0.6,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false, // Desactiva la reproducción automática
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: communities.map((Community community) {
          community.uniqueId = 'carousel-${community.id}';
          return GestureDetector(
            onTap: () {
              // Acción al hacer clic en una comunidad
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      community.photo,
                      fit: BoxFit.cover,
                      width: size.width * 0.6,
                      height: size.height * 0.2,
                      cacheWidth: (size.width * 0.6).toInt(),
                      cacheHeight: (size.height * 0.2).toInt(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.transparent,
                    child: Text(
                      community.name,
                      style: TextStyle(
                        fontFamily: 'WorkSans', // Usando Roboto Bold
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
