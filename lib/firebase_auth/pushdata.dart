import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../domain/models/transaction_model.dart';
import '../global/common/toast.dart';

Future<void> pushDataToFirestore() async {
  // Lấy thông tin về người dùng hiện tại
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Xử lý trường hợp không có người dùng đăng nhập
    return;
  }
  // Mở Hive box để lấy dữ liệu
  var transactionBox = await Hive.openBox<Transaction>('transactions');
  // Lấy dữ liệu từ Hive box
  List<Transaction> transactions = transactionBox.values.toList();
  // Tham chiếu đến collection 'transactions' trên Firestore của người dùng hiện tại
  CollectionReference transactionCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('transactions');
  // Biến đếm để theo dõi số lượng tài liệu đã thêm
  int count = 0;
  // Duyệt qua từng transaction và đẩy lên Firestore
  await Future.forEach(transactions, (transaction) async {
    await transactionCollection.doc('transaction_$count').set({
      'userId': user.uid,
      'type': transaction.type,
      'amount': transaction.amount,
      'createAt': transaction.createAt,
      'notes': transaction.notes,
      'category': {
        'type': transaction.category.type,
        'name': transaction.category.title,
        'image': transaction.category.categoryImage,
      },
    });
    count++;
  });
  if(transactions.isNotEmpty){
    showToast(
      message: "Lưu trữ dữ liệu thành công !",
    );
  }
  else{
    showToast(
      message: "Lưu trữ dữ liệu thất bại !",
    );
  }
}
