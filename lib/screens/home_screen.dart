import 'package:flutter/material.dart';
import 'package:map_project/screens/current_location.dart';
import 'package:map_project/screens/simple_map_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){return SimpleMapScreen();}));
            }, child: Text('Simple Map')),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){return CurrentLocationScreen();}));
            }, child: Text('Get current Location')),
          ],
        ),
      ),
    );
  }
}
