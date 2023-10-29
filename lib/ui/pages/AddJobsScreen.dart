import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../service/globalVariable.dart';
import '../../widgets/button.dart';
import '../persistent/persistent.dart';

class AddJobs extends StatefulWidget {
  const AddJobs({Key? key}) : super(key: key);

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  final TextEditingController _dateDeadlineController =
      TextEditingController(text: " Job Deadline Date");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _Jobsecription = TextEditingController();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job Category");

  final _formKey = GlobalKey<FormState>();
  DateTime? Picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;


//this fuction will show a category
  _showCategoryDialog({required Size size}) {
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
                        _jobCategoryController.text =
                            Persistent.CategoryList[index];
                      });
                      Navigator.pop(context);
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
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ],
          );
        });
  }
//this fucktion will show a date time picker
  void _dateTimePicker() async {
    Picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));
    if (Picked != null) {
      setState(() {
        _dateDeadlineController.text =
            "${Picked!.year} - ${Picked!.month} - ${Picked!.day}";
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            Picked!.microsecondsSinceEpoch);
      });
    }
  }
// this method create new job
  Future<void> _addNewJob() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_dateDeadlineController.text == "Job Deadline Date" ||
          _jobCategoryController.text == "Select Job Category") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please piked every Things")));
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection("Jobs").doc(jobId).set({
          "JobId": jobId,
          "UploadedBy": _uid,
          "email": user.email,
          "jobTitle": _jobTitleController.text,
          "jobDescription": _Jobsecription.text,
          "deadlineDate": _dateDeadlineController.text,
          "deadLinedateTimeStamp": deadlineDateTimeStamp,
          "jobCategory": _jobCategoryController.text,
          "jobComment": [],
          "requirement": true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "location": location,
          "applicants": 0,
        });
        await ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("New Job Added successful")));
        _jobTitleController.clear();
        _jobCategoryController.clear();
        _dateDeadlineController.clear();
        _Jobsecription.clear();
        setState(() {
          _jobCategoryController.text = "chose job category";
          _dateDeadlineController.text = "chose job deadline";
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something Wrong")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // there we put some user data when we create post. the method add user into to empty veriable .
  Future<void> _getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      name = userDoc.get("name");
      userImage = userDoc.get("userImage");
      location = userDoc.get("location");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF091fce),
        automaticallyImplyLeading: false,
        title: Center(child: Text("Add New Jobs",style: GoogleFonts.nosifer(
          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,),
        ),)),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Job Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      _showCategoryDialog(size: size);
                    },
                    child: TextFormField(
                      controller: _jobCategoryController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      enabled: false,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please enter Text";
                        } else {
                          return null;
                        }
                      },
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _jobTitleController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter Text";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: "Job Tittle", border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _Jobsecription,
                    textInputAction: TextInputAction.next,
                    enabled: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter Text";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Job Descriptiosn....",
                        border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _dateTimePicker();
                    },
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      enabled: false,
                      controller: _dateDeadlineController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please select date";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Btn(
                              name: 'Submit',
                              onPress: () {
                                _addNewJob();
                              },
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
