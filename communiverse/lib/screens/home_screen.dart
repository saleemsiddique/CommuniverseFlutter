import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communiverse/models/models.dart';
import 'package:communiverse/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    return Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.1),
            Center(
              child: Image(
                image: AssetImage("assets/LogoCommuniverse.png"),
                width: 200,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 16.0), // Add padding to the left
              child: Text(
                'Most Popular',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              height: size.height * 0.23,
              child: CommunityCarousel(
                  communities: communityService.top5Communities),
            ),
            SizedBox(height: 70),
            Padding(
              padding: EdgeInsets.only(left: 16.0), // Add padding to the left
              child: Text(
                'My Communities',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              height: size.height * 0.23,
              child: CommunityCarousel(
                  communities: communityService.myCommunties),
            ),
          ],
        ),
      ),
    );
  }
}
