import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/button.dart';
import 'LoginScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
    final _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressNameController = TextEditingController();
  File? imageFile;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? imageUrl;

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressNameController.dispose();

  }

  final ImagePicker picker = ImagePicker();
// picked image from gallary
  Future<void> _picImageFromGallary() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    _imageCropper(photo!.path);
    Navigator.pop(context);
  }


  // picked image from Camera
  Future<void> _picImageFromCamera() async {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera );
      _imageCropper(photo!.path);
      Navigator.pop(context);
    }


// crop image function
    Future<void> _imageCropper(filePath) async {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,maxHeight: 1080,maxWidth: 1080
      );

      if(croppedFile != null){
        setState(() {
          imageFile =File(croppedFile.path);
        });
      }
    }




    // form for signUp
  Future<void> _submitFormFroSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if(isValid){
      if(imageFile == null){
        Fluttertoast.showToast(
            msg: "Please Select Image",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        // create user with createUserWithEmailAndPassword
        final credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        // upload user image to cloude storgae
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final storageRef = FirebaseStorage.instance.ref().child("userImages").child(_uid + ".jpg");
        await storageRef.putFile(imageFile!);
        imageUrl = await storageRef.getDownloadURL();

        // upload data to cloude firestore
        FirebaseFirestore.instance.collection('users').doc(_uid).set(
          {
            'id': _uid,
            'name': _companyNameController.text, // John Doe// Stokes and Sons
            'email': _emailController.text,
            'userImage': imageUrl,
            'password': _passwordController.text,
            'phoneNumber': _phoneNumberController.text,
            'location': _addressNameController.text,
            'createdAt': Timestamp.now(),
          }

        );
        Navigator.canPop(context)? Navigator.pop(context):null;
        _companyNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneNumberController.clear();
        _addressNameController.clear();

      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Form(
              key: _signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
               Center(
                 child: Container(
                   height: 100,
                   width: 100,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.black),
                     borderRadius: BorderRadius.all(Radius.circular(20)),

                   ),

                   child:ClipRRect(
                     borderRadius: BorderRadius.circular(20),
                     child: imageFile== null ? IconButton(icon: Icon(Icons.camera_alt_outlined), onPressed: () {
                       showDialog(context: context,
                           builder: (context)=>
                               AlertDialog(
                                 title: Text("Select Image"),
                                 actions: [
                                   Row(
                                     children: [
                                       Icon(Icons.camera_alt_outlined,size: 25,color: Colors.deepPurpleAccent,),
                                       SizedBox(width: 3,),
                                       TextButton(onPressed: (){
                                         _picImageFromCamera();
                                       }, child: Text("Camera",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),)
                                     ],),
                                   Row(
                                     children: [
                                       Icon(Icons.image,size: 25,color: Colors.deepPurpleAccent),
                                       SizedBox(width: 3,),
                                       TextButton(onPressed: (){
                                         _picImageFromGallary();
                                       }, child: Text("Gallary",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),)
                                     ],),
                                 ],
                               )
                       ); },):Image.file(imageFile!,fit: BoxFit.cover,),
                   )
                 ),
               ),
                  SizedBox(height: 30,),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    controller: _companyNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "please enter Name";
                      }else{
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: "Full Name / Company Name..",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty){
                        return "please enter email";
                      }else{
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _passwordController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "please enter Password";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),


                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _phoneNumberController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "please enter Phone";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),


                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _addressNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "please enter Address";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Company Address",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("You Have Already Account?"),
                      TextButton(onPressed: () {
                        Get.to(LoginScreen());
                      }, child: Text("Login")),
                    ],
                  ),
                  SizedBox(height: 30,),

                  Btn(name: 'SignUp', onPress: () {
                    _submitFormFroSignUp();
                    Fluttertoast.showToast(
                        msg: "Successful",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );


                  },)





                ],),
            ),
          ),
        ),
      ),
    );
  }
}
