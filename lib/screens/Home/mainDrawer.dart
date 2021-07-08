import 'package:flutter/material.dart';
import 'package:shride/screens/Home/Home.dart';
import 'package:shride/screens/Home/Requests.dart';
import 'package:shride/screens/Home/profile.dart';
import 'package:shride/Services/AuthService.dart';
import 'package:shride/screens/Home/rider.dart';
import 'package:shride/screens/Home/passengar.dart';
import 'package:shride/screens/login.dart';

import 'Post.dart';
class MainDrawer extends StatelessWidget {

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                      height: 100,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1613905383527-8994ba2f9896?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80'
                        ),
                            fit:BoxFit.fill
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home',
            style: TextStyle(
              fontSize: 18,
            ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Home(),),(route)=>false
            );},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Profile(),), (route)=>false
            );},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out',
                style: TextStyle(
                  fontSize: 18,
                ),
            ),
            onTap: () {
              authService.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => Login(),), (route)=>false
              );
            },
          ),
          ListTile(

            title: Text('Passenger',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Passengar(),),(route)=>false
            );},
          ),
          ListTile(
            leading: Icon(Icons.bike_scooter),
            title: Text('Rider',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Rider(),),(route)=>false
            );},
          ),
          ListTile(
            leading: Icon(Icons.bike_scooter),
            title: Text('Posts',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Posts(),),(route)=>false
            );},
          ),
          ListTile(
            leading: Icon(Icons.bike_scooter),
            title: Text('Requests',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: (){Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Requests(),),(route)=>false
            );},
          ),
        ],
      )
    );
  }
}
