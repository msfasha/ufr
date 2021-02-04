import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ufr/models/user.dart';
import 'package:ufr/services/firebase.dart';
import 'package:ufr/shared/export.dart';
import 'package:ufr/shared/modules.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Widget _exportTitle;

  @override
  void initState() {
    _exportTitle = Text('Export to CSV');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.personName ?? ''),
            accountEmail: Text(user.email) ?? '',
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                user.email.characters.first ?? '',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: _exportTitle,
            onTap: () async {
              setState(() {
                _exportTitle = SpinKitThreeBounce(
                  color: Colors.blue,
                  size: 20.0,
                );
              });
              
              ExportFromFireStore.exportToCSV(user.utilityId, context);
              
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              showADialog(context, "ME Application");
            },
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Logout'),
              onTap: () async {
                await AuthService.signOut();
              }),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Exit'),
            onTap: () async {              
                SystemNavigator.pop();
                if (Platform.isAndroid) {
                  await AuthService.signOut();
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    exit(0);
                  });
                } else if (Platform.isIOS) {
                  await AuthService.signOut();
                  exit(0);
                }           
            },
          ),
        ],
      ),
    );
  }
}
