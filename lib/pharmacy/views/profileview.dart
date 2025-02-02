import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchinv() async {
  final response = await http.get(
    Uri.parse('https://pharmalink-47enl.ondigitalocean.app/inventory/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'token df3116e9c3e61bed28cfda39ef561bde0cdfda48',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    var data = jsonDecode(response.body);
    print(data['medicines']);
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<Map<String, dynamic>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchinv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data?['medicines'].length,
                    itemBuilder: ((context, index) {
                      final dist = snapshot.data?['medicines'][index]['mrp'];

                      return ListTile(
                        title: Text(
                          snapshot.data?['medicines'][index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("₹${dist.toString()}"),
                      );
                    })));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
// Text(snapshot.data?[0]['name'].toString() ?? "")