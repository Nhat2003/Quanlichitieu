import 'package:expanse_management/domain/models/category_model.dart';

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel('Tiền lương', 'Salary.png', 'Khoản thu'),
  CategoryModel('Tiền thưởng', 'Gifts.png', 'Khoản thu'),
  CategoryModel('Tiền lãi đầu tư', 'Investments.png', 'Khoản thu'),
  CategoryModel('Tiền cho vay', 'Rentals.png', 'Khoản thu'),
  CategoryModel('Tiền tiết kiệm', 'Savings.png', 'Khoản thu'),
  CategoryModel('Tiền khác', 'Others.png', 'Khoản thu'),
];
final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel('Đồ ăn', 'Food.png', 'Khoản chi'),
  CategoryModel('Đi lại', 'Transportation.png', 'Khoản chi'),
  CategoryModel('Học phí', 'Education.png', 'Khoản chi'),
  CategoryModel('Hóa đơn', 'Bills.png', 'Khoản chi'),
  CategoryModel('Du lịch', 'Travels.png', 'Khoản chi'),
  CategoryModel('Thú cưng', 'Pets.png', 'Khoản chi'),
  CategoryModel('Thu', 'Tax.png', 'Khoản chi'),
  CategoryModel('Khoản chi khác', 'Others.png', 'Khoản chi'),
];
