import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/jobWidegts.dart';

class SearchJob extends StatefulWidget {
  const SearchJob({Key? key}) : super(key: key);

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';
  Widget _searchFild() {
    return TextField(
      autocorrect: true,
      controller: _searchQueryController,
      decoration: InputDecoration(
        hintText: "Search fo jobs...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildAction() {
    return <Widget>[
      IconButton(
          onPressed: () {
            clearSearchQuery();
          },
          icon: Icon(Icons.clear)),
    ];
  }

  void clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF091fce),
        title: _searchFild(),
        actions: _buildAction(),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Jobs')
            .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
            .where('requirement', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context,int index) {
                    return JobWidgets(
                      jobTitle: snapshot.data?.docs[index]["jobTitle"],
                      jobDescription: snapshot.data?.docs[index]
                          ["jobDescription"],
                      jobId: snapshot.data?.docs[index]["JobId"],
                      UploadedBy: snapshot.data?.docs[index]["UploadedBy"],
                      userImage: snapshot.data?.docs[index]["userImage"],
                      name: snapshot.data?.docs[index]["name"],
                      email: snapshot.data?.docs[index]["email"],
                      location: snapshot.data?.docs[index]["location"],
                    );
                  });
            } else {
              return const Text("There is no job");
            }
          }
          return const Text("Something wents wrong");
        },
      ),
    );
  }
}
