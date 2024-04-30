import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


Future<List<String>> uploadXImages(List<XFile> images, {required String storageFolderName}) async {
  List<String> imgDownloadUrls=[];
  for(int i=0;i<images.length;i++){
    String imgUrl=await uploadXImage(images[i],storageFolderName: storageFolderName );
    imgDownloadUrls.add(imgUrl);
  }
  return imgDownloadUrls;
}

Future<String> uploadXImage(XFile image, {required String storageFolderName}) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  var name = const Uuid().v4();
  final path = storage.ref().child(storageFolderName).child(name);
  // final path = _storage.ref().child(path);
  Uint8List imgInBytes=await image.readAsBytes();
  UploadTask uploadTask = path.putData(imgInBytes);
  TaskSnapshot snap = await uploadTask.whenComplete(() {});
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;

}
