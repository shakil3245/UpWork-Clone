
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upworkclone/service/globalVariable.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key, required this.JobId, required this.UploadedBy})
      : super(key: key);
  final String JobId;
  final String UploadedBy;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? authorName;
  String? userImageUrl;

  String? jobCategory;
  String? jobdescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadLineDateTimeStamp;
  String? postedDate;
  String? deadLineDate;
  String? locationCompany = "";
  String? emailCompany = "";
  int applicants = 0;
  bool isDeadLineAvailable = false;

  Future<void> getJobData() async {
    //for user dat a
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.UploadedBy)
        .get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get("name");
        userImageUrl = userDoc.get("userImage");
      });
    }

    //for job data
    final DocumentSnapshot jobdataDoc = await FirebaseFirestore.instance
        .collection('Jobs')
        .doc(widget.JobId)
        .get();
    if (jobdataDoc == null) {
      return;
    } else {
      setState(() {
        jobCategory = jobdataDoc.get("jobCategory");
        jobdescription = jobdataDoc.get("jobDescription");
        jobTitle = jobdataDoc.get("jobTitle");
        recruitment = jobdataDoc.get("requirement");
        emailCompany = jobdataDoc.get("email");
        applicants = jobdataDoc.get("applicants");
        locationCompany = jobdataDoc.get("location");
        postedDateTimeStamp = jobdataDoc.get("createdAt");
        deadLineDateTimeStamp = jobdataDoc.get("deadLinedateTimeStamp");
        deadLineDate = jobdataDoc.get("deadlineDate");
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate!.year} - ${postDate!.month}- ${postDate!.day}';
      });

      var date = deadLineDateTimeStamp!.toDate();
      isDeadLineAvailable = date.isAfter(DateTime.now());
    }
  }

  applyJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query: 'Subject= Apply For $jobTitle&body Hello ,please attacthed resume',
    );
    final url = params.toString();
    launchUrlString(url);
    addnewApplicants();
  }

  void addnewApplicants() {
    var docRef =
        FirebaseFirestore.instance.collection('Jobs').doc(widget.JobId);
    docRef.update({
      'applicants': applicants + 1,
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Descriptions",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF091fce),
        leading: IconButton(
          icon: const Icon(Icons.close,color: Colors.white,),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Card(
              color: Color(0xFF091fce),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      jobTitle == null ? "No name" : jobTitle!,
                      maxLines: 3,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Image.network(
                              userImageUrl == null
                                  ? "https://media.istockphoto.com/id/1332100919/vector/man-icon-black-icon-person-symbol.jpg?s=612x612&w=0&k=20&c=AVVJkvxQQCuBhawHrUhDRTCeNQ3Jgt0K1tXjJsFy1eg="
                                  : userImageUrl!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              authorName == null ? "No name" : authorName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                            Text(locationCompany == null
                                ? "No name"
                                : locationCompany!,style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          applicants.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Applicant',style: TextStyle(color: Colors.white),),
                        Icon(Icons.perm_identity_rounded,color: Colors.white,),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Job Description",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    Text(jobdescription == null ? "" : jobdescription!,style: TextStyle(color: Colors.white),),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Color(0xFF091fce),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Actively Recruting, Sent CV/Resume:",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          applyJob();
                        },
                        child: Text("Easy Apply Now",style: TextStyle(color: Colors.black),)),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Uploaded On:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        Text(postedDate == null ? "" : postedDate!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Deadline Date:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                        Text(deadLineDate == null ? "" : deadLineDate!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
