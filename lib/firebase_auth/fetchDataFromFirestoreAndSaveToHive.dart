import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expanse_management/domain/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../domain/models/transaction_model.dart';
import '../global/common/toast.dart';
Future<void> fetchDataFromFirestoreAndSaveToHive() async {
  // Lấy thông tin về người dùng hiện tại
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Xử lý trường hợp không có người dùng đăng nhập
    return;
  }
  // Tham chiếu đến collection 'transactions' trên Firestore của người dùng hiện tại
  CollectionReference transactionCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('transactions');
  // Lấy dữ liệu từ Firestore
  QuerySnapshot transactionSnapshot = await transactionCollection.get();
  // Khởi tạo danh sách để lưu trữ các giao dịch
  List<Transaction> transactions = [];
  // Lặp qua các tài liệu từ Firestore
  transactionSnapshot.docs.forEach((QueryDocumentSnapshot transactionDoc) {
    Map<String, dynamic> data = transactionDoc.data() as Map<String, dynamic>;
    // Kiểm tra xem các trường dữ liệu có giá trị null hay không
    String type = data['type'] ?? ''; // Nếu giá trị null, gán một giá trị mặc định (trong trường hợp này là chuỗi rỗng)
    String amount = data['amount'] ?? '';
    String notes = data['notes'] ?? '';
    // Kiểm tra và gán giá trị cho category
    String categoryTitle = '';
    String categoryImage = '';
    String categoryType = '';
    if (data['category'] != null) {
      categoryTitle = data['category']['title'] ?? '';
      categoryImage = data['category']['image'] ?? '';
      categoryType = data['category']['type'] ?? '';
    }
    // Tạo một đối tượng Transaction từ dữ liệu Firestore
    DateTime createdAt = data['createAt'].toDate();
    Transaction transaction = Transaction(
      type,
      amount,
      createdAt,
      notes,
      CategoryModel(categoryTitle, categoryImage, categoryType),
    );
    // Thêm giao dịch vào danh sách
    transactions.add(transaction);
  });
  // Mở hoặc tạo một Hive box để lưu trữ các giao dịch
  var transactionBox = await Hive.openBox<Transaction>('transactions');
  // Xóa toàn bộ dữ liệu cũ trong Hive box
  await transactionBox.clear();
  // Thêm dữ liệu mới vào Hive box
  transactions.forEach((transaction) {
    transactionBox.add(transaction);
  });
  if(transactionBox.isNotEmpty){
    showToast(
      message: "Khôi phục dữ liệu thành công !",
    );
  }
  else{
    showToast(
      message: "Khôi phục dữ liệu thất bại !",
    );
  }
}
