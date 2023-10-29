import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../ui/pages/DetailsScreen.dart';

class JobWidgets extends StatefulWidget {
  const JobWidgets(
      {Key? key,
      required this.jobTitle,
      required this.jobDescription,
      required this.jobId,
      required this.UploadedBy,
      required this.userImage,
      required this.name,
      this.recruitment,
      required this.email,
      required this.location})
      : super(key: key);

  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String UploadedBy;
  final String userImage;
  final String name;
  final bool? recruitment;
  final String email;
  final String location;

  @override
  State<JobWidgets> createState() => _JobWidgetsState();
}

class _JobWidgetsState extends State<JobWidgets> {
  FirebaseAuth _auth = FirebaseAuth.instance;
// for delete job from home
  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try{
                      if (widget.UploadedBy == _uid) {
                        await FirebaseFirestore.instance
                            .collection('Jobs')
                            .doc(widget.jobId)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Job Deleted Successfully")));
                        Navigator.canPop(context)?Navigator.pop(context):null;
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("You Can't Delete")));
                      }
                    }catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("This task can't be deleted")));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.withOpacity(0.1),
      elevation: 3,
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailsScreen(JobId: widget.jobId, UploadedBy: widget.UploadedBy,),));
        },
        onLongPress: () {
          _deleteDialog();
        },
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration:
              const BoxDecoration(border: Border(right: BorderSide(width: 1))),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 18, color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.jobDescription,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, color: Colors.black))
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}
