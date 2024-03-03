 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class bannerController extends GetxController{
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit(){
    super.onInit();

    fetchBannersUrls();
  }

  // fetching banners
  Future<void> fetchBannersUrls()async{
    try{
      QuerySnapshot bannersScapshot = await FirebaseFirestore.instance.collection('banners').get();

      if(bannersScapshot.docs.isNotEmpty){
        bannerUrls.value = bannersScapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      }
    }
    catch(e){
      print ('Error $e');
    }
  }
}
