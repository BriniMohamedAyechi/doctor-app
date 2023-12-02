import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class getImage extends StatelessWidget {
  const getImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.lightGreen,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selection d'image",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    // Add code here to open the camera and capture an image (if needed).
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    try {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );

                      if (result != null) {
                        PlatformFile file = result.files.first;
                        // Handle the selected image file, e.g., save it or use it.
                        // The file path can be accessed using file.path.
                      }
                    } catch (e) {
                      // Handle any errors that occur during file picking.
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
