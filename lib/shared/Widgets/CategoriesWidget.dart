// import 'package:flutter/material.dart';
//
// class CategoriesWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//           child: Row(
//             children: [
//               Text(
//                 "Category",
//                 style: TextStyle(
//                     fontSize: 25,
//                     color: Color(0xFF5E8941),
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
//
// import '../../features/home/screens/CategoryPage.dart';
//
// class CategoriesWidget extends StatelessWidget {
//   final String title;
//   final String imagePath;
//
//   const CategoriesWidget({super.key, required this.title, required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CategoryPage(categoryName: title),
//           ),
//         );
//       },
//       child: Container(
//         height: 200,
//         width: 165,
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               imagePath,
//               height: 115,
//               width: 115,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../features/home/screens/CategoryPage.dart';

class CategoriesWidget extends StatelessWidget {
  final String title;
  final String imageUrl;


  // Updated constructor
  const CategoriesWidget({super.key, required this.title, required this.imageUrl,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(categoryName: title,),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // Updated to Image.network
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}