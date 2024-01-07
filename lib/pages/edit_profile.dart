import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/blocs/internet_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String imageUrl;

  const EditProfile({Key? key, required this.name, required this.imageUrl})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(name, imageUrl);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(this.name, this.imageUrl);

  String name;
  String imageUrl;

  File? imageFile;
  late String fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image is selected!');
    }
  }

  Future<void> uploadPicture() async {
    final SignInBloc sb = context.read<SignInBloc>();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Profile Pictures/${sb.uid}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    if (uploadTask.snapshot != null &&
        uploadTask.snapshot.state == TaskState.success) {
      print('Upload complete');
    }

    var _url =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    var _imageUrl = _url.toString();
    setState(() {
      imageUrl = _imageUrl;
    });
  }

  Future<void> handleUpdateData() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    final sb = context.read<SignInBloc>();
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      Get.snackbar("Error", 'no internet');
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        setState(() => loading = true);
        imageFile == null
            ? await sb.updateUserProfile(nameCtrl.text, imageUrl).then((value) {
                Get.snackbar("Success", 'Profile updated successfully');
                setState(() => loading = false);
              })
            : await uploadPicture().then((value) =>
                sb.updateUserProfile(nameCtrl.text, imageUrl).then((_) {
                  Get.snackbar("Success", 'Profile updated successfully');
                  setState(() => loading = false);
                }));
        if (passwordCtrl.text.isNotEmpty) {
          if (passwordCtrl.text.length < 6) {
            Get.snackbar("Error", 'password must be at least 6 characters');
          } else {
            await sb.updatePassword(passwordCtrl.text).then((value) {
              Get.snackbar("Success", 'Profile updated successfully');
              setState(() => loading = false);
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameCtrl.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('edit profile').tr(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: <Widget>[
          InkWell(
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey[300],
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: Colors.grey[500],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageFile == null
                        ? CachedNetworkImageProvider(imageUrl)
                        : FileImage(imageFile!) as ImageProvider,
                    //FileImage(imageFile ?? File(imageUrl)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            onTap: () {
              pickImage();
            },
          ),
          SizedBox(
            height: 50,
          ),
          Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'enter new name',
              ),
              controller: nameCtrl,
              validator: (value) {
                if (value!.isEmpty) return "Name can't be empty";
                return null;
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter new password',
            ),
            controller: passwordCtrl,
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) return 'Password must not be empty';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: loading == true
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ))
                  : Text('update profile',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))
                      .tr(),
              onPressed: () {
                handleUpdateData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
