import 'package:expanse_management/Constants/color.dart'; // Import một tập hợp các màu sắc được sử dụng trong ứng dụng
import 'package:flutter/material.dart'; // Import giao diện người dùng cho ứng dụng
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion Flutter Charts để vẽ biểu đồ
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Import để định dạng số
import '../../domain/models/transaction_model.dart'; // Import mô hình giao dịch

class CircularChart extends StatefulWidget {
  final String title; // Tiêu đề của biểu đồ (Khoản thu hoặc Khoản chi)
  final List<Transaction> transactions; // Danh sách các giao dịch
  final int currIndex; // Chỉ số hiện tại
  const CircularChart({
    super.key,
    required this.title,
    required this.currIndex,
    required this.transactions,
  });

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  late TooltipBehavior _tooltipBehavior; // Hành vi của tooltip
  final Map<String, double> mapIncomeData = {}; // Danh sách dữ liệu khoản thu
  final Map<String, double> mapExpenseData = {}; // Danh sách dữ liệu khoản chi
  final List<ChartData> incomeData = []; // Danh sách dữ liệu khoản thu cho biểu đồ
  final List<ChartData> expenseData = []; // Danh sách dữ liệu khoản chi cho biểu đồ

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, color: primaryColor); // Khởi tạo hành vi của tooltip
    super.initState();
    calculateChartData(); // Tính toán dữ liệu cho biểu đồ
  }

  @override
  void didUpdateWidget(CircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currIndex != oldWidget.currIndex || widget.transactions != oldWidget.transactions) {
      calculateChartData(); // Tính toán dữ liệu mới khi có sự thay đổi trong widget
    }
  }

  void calculateChartData() {
    mapExpenseData.clear(); // Xóa dữ liệu cũ của khoản chi
    mapIncomeData.clear(); // Xóa dữ liệu cũ của khoản thu
    for (var transaction in widget.transactions) {
      if (transaction.type == 'Khoản thu') {
        if (mapIncomeData.containsKey(transaction.category.title)) {
          mapIncomeData[transaction.category.title] = mapIncomeData[transaction.category.title]! + double.parse(transaction.amount);
        } else {
          mapIncomeData[transaction.category.title] = double.parse(transaction.amount);
        }
      } else {
        if (mapExpenseData.containsKey(transaction.category.title)) {
          mapExpenseData[transaction.category.title] = mapExpenseData[transaction.category.title]! + double.parse(transaction.amount);
        } else {
          mapExpenseData[transaction.category.title] = double.parse(transaction.amount);
        }
      }
    }

    incomeData.clear(); // Xóa dữ liệu cũ của khoản thu
    expenseData.clear(); // Xóa dữ liệu cũ của khoản chi

    mapIncomeData.forEach((key, value) {
      incomeData.add(ChartData(key, value)); // Thêm dữ liệu khoản thu mới vào danh sách
    });
    mapExpenseData.forEach((key, value) {
      expenseData.add(ChartData(key, value)); // Thêm dữ liệu khoản chi mới vào danh sách
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu không có dữ liệu cho khoản thu hoặc khoản chi
    if (widget.title == 'Khoản thu' && incomeData.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 130,
        child: Opacity(opacity: 0.2, child: Image.asset('images/ChartIllustrator.png')), // Hiển thị một hình ảnh mờ nếu không có dữ liệu
      );
    } else if (widget.title == 'Khoản chi' && expenseData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child: Opacity(opacity: 0.2, child: Image.asset('images/ChartIllustrator.png')), // Hiển thị một hình ảnh mờ nếu không có dữ liệu
        ),
      );
    }
    // Trả về biểu đồ tròn
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: SfCircularChart(
        palette: widget.title == 'Khoản thu' ? const <Color>[
          Colors.lightGreenAccent,
          Colors.green,
          Colors.cyanAccent,
          Colors.blue,
          Colors.indigo,
          Colors.teal
        ] : const <Color>[
          Colors.red,
          Colors.amberAccent,
          Colors.deepPurpleAccent,
          Colors.pinkAccent,
          Colors.brown,
          Colors.orange
        ],
        title: ChartTitle(
          text: widget.title,
          textStyle: TextStyle(
            color: widget.title == 'Khoản thu' ? Colors.green : Colors.red,
          ),
        ),
        legend: Legend(isVisible: true),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          // Vẽ biểu đồ tròn
          DoughnutSeries<ChartData, String>(
            dataSource: widget.title == 'Khoản thu' ? incomeData : expenseData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => '${NumberFormat.compactCurrency(
              symbol: '',
              decimalDigits: 1,
            ).format(data.y / 1000000)}M',
            animationDuration: 1000,
            dataLabelSettings: const DataLabelSettings(
              showZeroValue: true,
              isVisible: true,
              labelIntersectAction: LabelIntersectAction.shift,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
                length: '25%',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x; // Tên danh mục
  final double y; // Giá trị tương ứng
}
