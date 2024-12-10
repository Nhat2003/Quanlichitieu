import 'package:expanse_management/domain/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:expanse_management/Constants/color.dart';

class ColumnChart extends StatefulWidget {
  final List<Transaction> transactions; // Danh sách các giao dịch
  final int currIndex; // Chỉ số hiện tại
  const ColumnChart({
    super.key,
    required this.transactions,
    required this.currIndex,
  });

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  late TooltipBehavior _tooltipBehavior; // Hành vi của tooltip
  List<String> customFormats = [
    'Tháng 1',
    'Tháng 2',
    'Tháng 3',
    'Tháng 4',
    'Tháng 5',
    'Tháng 6',
    'Tháng 7',
    'Tháng 8',
    'Tháng 9',
    'Tháng 10',
    'Tháng 11',
    'Tháng 12'
  ]; // Dinh dạng ngày tùy chỉnh cho biểu đồ cột
  final List<ChartData> chartData = []; // Danh sách dữ liệu cho biểu đồ

  Map<String, List<double>> mapData = {}; // Dữ liệu từng tháng được nhóm lại
  DateFormat dateFormat = DateFormat.MMM(); // Định dạng ngày tháng

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, color: primaryColor); // Khởi tạo hành vi của tooltip
    super.initState();
    calculateChartData(); // Tính toán dữ liệu cho biểu đồ
  }

  @override
  void didUpdateWidget(ColumnChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currIndex != oldWidget.currIndex ||
        widget.transactions != oldWidget.transactions) {
      calculateChartData(); // Tính toán dữ liệu mới khi có sự thay đổi trong widget
    }
  }

  void calculateChartData() {
    mapData.clear(); // Xóa dữ liệu cũ

    // Lặp qua từng giao dịch và nhóm dữ liệu theo tháng
    for (var element in widget.transactions) {
      String formattedDate =
      getFormattedDate(widget.currIndex, element.createAt);
      if (mapData.containsKey(formattedDate)) {
        if (element.type == 'Khoản thu') {
          mapData[formattedDate]![0] += double.parse(element.amount);
        } else {
          mapData[formattedDate]![1] += double.parse(element.amount);
        }
      } else {
        mapData[formattedDate] = [0, 0];
        if (element.type == 'Khoản thu') {
          mapData[formattedDate]![0] = double.parse(element.amount);
        } else {
          mapData[formattedDate]![1] = double.parse(element.amount);
        }
      }
    }

    chartData.clear(); // Xóa dữ liệu cũ

    // Chuyển dữ liệu từ map thành danh sách ChartData
    mapData.forEach((key, value) {
      chartData.add(ChartData(key, value[0], value[1]));
    });

    chartData.sort((a, b) => a.x.compareTo(b.x)); // Sắp xếp theo thời gian
  }

  String getFormattedDate(int index, DateTime dateTime) {
    if (index == 3) {
      return customFormats[dateTime.month - 1]; // Trả về tên tháng
    } else {
      return '${dateFormat.format(dateTime)} ${dateTime.day}'; // Trả về ngày tháng
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 380,
      child: SfCartesianChart(  // vẽ biểu đồ
        primaryXAxis: CategoryAxis(), // Trục x là các danh mục
        primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()), // Trục y có dạng số
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          toggleSeriesVisibility: true,
        ), // Hiển thị chú thích ở dưới
        tooltipBehavior: _tooltipBehavior, // Hiển thị tooltip
        series: <ChartSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            name: 'Khoản thu',
            dataSource: chartData,
            color: Colors.green,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true,
          ),
          ColumnSeries<ChartData, String>(
            name: 'Khoản chi',
            color: Colors.red,
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y1,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final String x; // Thời gian (ngày/tháng)
  final double y; // Tổng khoản thu
  final double y1; // Tổng khoản chi
}
