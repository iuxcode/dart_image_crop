import 'dart:io'; // Import the dart:io library to handle file I/O.
import 'dart:math'; // Import the dart:math library to use mathematical functions.
import 'package:image/image.dart'; // Import the image package to handle image processing.

void main() {
  // Define the path to the directory containing the images.
  String path = "./images";

  // Create a Directory object representing the specified path.
  Directory dir = Directory(path);

  // Get a list of all files and directories within the specified directory.
  List files = dir.listSync();

  // Loop through each item in the directory.
  for (var f in files) {
    // Check if the item is not a File object (i.e., it is a directory or something else).
    if (f is! File) {
      continue; // Skip to the next item in the loop.
    }

    // Read the bytes of the file.
    final bytes = f.readAsBytesSync();

    // Decode the image bytes to get an Image object.
    Image? decodedImage = decodeImage(bytes);

    // If the image cannot be decoded, skip to the next item in the loop.
    if (decodedImage == null) {
      continue;
    }

    // Determine the size of the crop area (the smaller dimension of the image).
    var cropSize = min(decodedImage.width, decodedImage.height);

    // Calculate the horizontal offset to center the crop area.
    int offsetX = (decodedImage.width - cropSize) ~/ 2;

    // Calculate the vertical offset to center the crop area.
    int offsetY = (decodedImage.height - cropSize) ~/ 2;

    // Create a cropped version of the image.
    Image cropOne = copyCrop(
      decodedImage,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );

    // Extract the file name from the file path.
    String name = f.path.split(RegExp(r'(/|\\)')).last;

    // Save the cropped image as a new file with a "trimmed-" prefix in the file name.
    File('$path/trimmed-$name').writeAsBytesSync(encodePng(cropOne));
  }
}
