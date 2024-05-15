import 'dart:io';
import 'package:flutter/material.dart';

class CommonProfileImage extends StatelessWidget {
  final File? imageFile;
  final String? imgLink;
  final VoidCallback onTap;
  const CommonProfileImage({super.key, this.imageFile, required this.onTap, this.imgLink});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.grey
                )
            ),
            child:   imageFile != null
                ? Image.file(
                  imageFile!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ):
            // imgLink != null?
            // CachedRectangularNetworkImageWidget(
            //   image: imgLink!,
            //   height: 120,
            //   width: double.infinity,
            // )
            //     :
            const Padding(
              padding: EdgeInsets.all(30),
              child: Icon(Icons.camera_alt, size: 18,)
            ),
          ),
        ],
      ),
    );
  }
}