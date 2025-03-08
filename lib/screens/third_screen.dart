import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    setState(() {
      isLoading = true;
      users = [];
    });

    try {
      final response = await http
          .get(Uri.parse('https://reqres.in/api/users?page=1&per_page=12'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final totalPages = data['total_pages'];

        users.addAll(data['data']);

        for (int i = 2; i <= totalPages; i++) {
          final pageResponse = await http.get(
              Uri.parse('https://reqres.in/api/users?page=$i&per_page=12'));

          if (pageResponse.statusCode == 200) {
            final pageData = json.decode(pageResponse.body);
            users.addAll(pageData['data']);
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Third Screen",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return fetchAllUsers();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return InkWell(
                    onTap: () {
                      Provider.of<AppProvider>(context, listen: false)
                          .setSelectedUserName(
                              '${user['first_name']} ${user['last_name']}');
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(user['avatar']),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user['first_name']} ${user['last_name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user['email'].toString().toLowerCase(),
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
