import 'package:expanse_management/firebase_auth/fetchDataFromFirestoreAndSaveToHive.dart';
import 'package:expanse_management/firebase_auth/pushdata.dart';
import 'package:expanse_management/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/transaction_model.dart';
import 'setting_mode.dart';
import 'dark_mode.dart';
import 'package:provider/provider.dart';
import 'loginpage.dart';
import 'Passcode_screen.dart';
class SettingsScreen extends StatelessWidget {
  String selectedLanguage = 'Vietnamese'; // Ngôn ngữ mặc định
  List<String> languages = ['English', 'Spanish', 'French', 'Vietnamese']; // Danh sách ngôn ngữ
  final List<String> cochu = ['Nhỏ', 'Trung Bình', 'Lớn'];
  String selectedDateTimeFormat = 'dd/MM/yyyy HH:mm:ss'; // Định dạng ngày giờ mặc định
  List<String> dateTimeFormats = [
    'dd/MM/yyyy HH:mm:ss',
    'MM/dd/yyyy HH:mm:ss',
    'yyyy-MM-dd HH:mm:ss',
    'HH:mm:ss dd/MM/yyyy',
  ]; // Danh sách định dạng ngày giờ

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff368983),
        title: Text('Cài đặt',style: TextStyle(fontSize: 26)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode,size: 35,),
            title: Text('Chế độ ban đêm',style: TextStyle(fontSize: 20),),
            trailing: Switch(
              value: settings.darkMode, // Giá trị chế độ ban đêm (có thể thay đổi)
              onChanged: (value) {
                settings.toggleDarkMode(value);
                    // Xử lý sự kiện khi chế độ ban đêm được thay đổi
                // Thay đổi chế độ ban đêm ở đây
              },
            ),
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.language,size: 35),
            title: Text('Ngôn ngữ',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Chọn ngôn ngữ'),
                    content: DropdownButtonFormField<String>(
                      value: selectedLanguage,
                      items: languages.map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        Navigator.pop(context);
                        // Xử lý sự kiện khi người dùng chọn ngôn ngữ ở đây
                      },
                    ),
                  );
                },
              );
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.today_sharp,size: 35),
            title: Text('Định dạng ngày giờ',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Chọn định dạng ngày giờ'),
                    content: DropdownButtonFormField<String>(
                      value: selectedDateTimeFormat,
                      items: dateTimeFormats.map((String format) {
                        return DropdownMenuItem<String>(
                          value: format,
                          child: Text(format),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        Navigator.pop(context);
                        // Xử lý sự kiện khi người dùng chọn định dạng ngày giờ ở đây
                      },
                    ),
                  );
                },
              );
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.font_download,size: 35),
            title: Text('Cỡ chữ',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Chọn cỡ chữ'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: cochu.map((cochu) {
                        return ListTile(
                          title: Text(cochu),
                          onTap: () {
                            print('Bạn đã chọn $cochu');
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.lock,size: 35),
            title: Text('Mã bảo vệ',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {

              Navigator.push(context,
                MaterialPageRoute(builder: (builder) => PasscodeScreen()),
              );
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return PasscodeScreen();
              //   },
              // );
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.save,size: 35),
            title: Text('Lưu trữ dữ liệu',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý sự kiện khi người dùng chọn liên kết tài khoản
              // Hiển thị hộp thoại hoặc điều hướng đến trang liên kết tài khoản
              _showSaveData(context);
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(Icons.download,size: 35),
            title: Text('Khôi phục dữ liệu',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showInputdata(context);
            },
          ),
          Divider(), // Đường kẻ ngăn cách
          ListTile(
            leading: Icon(FontAwesomeIcons.trash,size: 30,color: Colors.red,),
            title: Text('Xóa tất cả dữ liệu',style: TextStyle(fontSize: 20,color: Colors.red)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showdeleteData(context);
            },
          ),
          Divider(),
          Center(
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout, color: Colors.black),
              label: Text(
                "Đăng xuất",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  letterSpacing: 1.8,
                ),
              ),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.grey.shade400,
              ),
            ),
          ),

        ],
      ),
    );
  }
  void _showSaveData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lưu trữ dữ liệu'),
          content: Text('Bạn có chắc chắn muốn lưu trữ dữ liệu không?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy',style: TextStyle(fontSize: 20),),
            ),
            TextButton(
              onPressed: () async {
                pushDataToFirestore();
                Navigator.of(context).pop();
              },
              child: Text('Đồng ý',style: TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }
  void _showInputdata(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Khôi phục dữ liệu'),
          content: Text('Bạn có chắc chắn muốn khôi phục dữ liệu không?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy',style: TextStyle(fontSize: 20),),
            ),
            TextButton(
              onPressed: () async {
                fetchDataFromFirestoreAndSaveToHive();
                Navigator.of(context).pop();
              },
              child: Text('Đồng ý',style: TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }
  void _showdeleteData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa dữ liệu'),
          content: Text('Bạn có muốn xóa tât cả dữ liệu?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy',style: TextStyle(fontSize: 20),),
            ),
            TextButton(
              onPressed: () async {
                var transactionBox = Hive.box<Transaction>('transactions');
                await transactionBox.clear();
                var categoryBox = Hive.box<CategoryModel>('categories');
                await categoryBox.clear();
                showToast(message: "Xóa dữ liệu thành công");
                Navigator.of(context).pop();
              },
              child: Text('Đồng ý',style: TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất không?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy',style: TextStyle(fontSize: 20),),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  print('Đăng xuất không thành công: $e');
                }
              },
              child: Text('Đăng xuất',style: TextStyle(fontSize: 20),),
            ),
          ],
        );
      },
    );
  }
}







// class PasscodeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _controller = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff368983),
//         title: Text('Nhập mã bảo vệ'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Nhập mã bảo vệ',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _controller,
//               keyboardType: TextInputType.number,
//               maxLength: 4,
//               decoration: InputDecoration(
//                 labelText: 'Mã bảo vệ',
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String passcode = _controller.text;
//                 if (passcode.length == 4) {
//                   // Kiểm tra xem độ dài của mã bảo vệ có đúng là 4 ký tự không
//                   print('Mã bảo vệ đã nhập: $passcode');
//                   // Thực hiện các xử lý khác ở đây
//                   Navigator.pop(context);
//                 } else {
//                   // Hiển thị thông báo cho người dùng nhập lại nếu độ dài không đúng
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Lỗi'),
//                         content: Text('Vui lòng nhập mã bảo vệ gồm 4 chữ số.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('OK'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//               child: Text('Xác nhận'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

