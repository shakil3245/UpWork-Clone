import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upworkclone/ui/pages/searchJob.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import '../../widgets/jobWidegts.dart';
import '../persistent/persistent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? jobCategoryFilter;

  //showdialoge for categoryList. it requied a sie that you need to give when you call from fucntion.
  _showCategoryDialogForFilter({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Job Category",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.CategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_right_alt),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.CategoryList[index],
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: Persistent.CategoryList.length,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text("Cancel Filter")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF091fce),
        automaticallyImplyLeading: false,
        title: Center(child: Text("Job Hunt",style: GoogleFonts.nosifer(
          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,),
        ),)),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Get.to(SearchJob());
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),

        //     .where('jobCategory', isEqualTo: jobCategoryFilter)
        // .where('requirement', isEqualTo: true)
        // .orderBy('createdAt', descending: false)

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Jobs')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
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
      ),
    );
  }
}

