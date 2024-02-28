import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//''
// ""
// =
// +
// {}

void main() async {
  bool loopFlag = true;

  while (loopFlag) {
    print("Enter base currency: ");
    String baseCurrency = stdin.readLineSync()?.toUpperCase() ?? "";
    print("Enter target currency: ");
    String targetCurrency = stdin.readLineSync()?.toUpperCase() ?? "";

    final response = await http.get(Uri.parse(
        "https://v6.exchangerate-api.com/v6/0a9a46f3bcd3746201b7c7ed/pair/$baseCurrency/$targetCurrency"));

    if (response.statusCode == 200) {
      //jsonData["result"] == "error"
      loopFlag = false;
    } else {
      print("Entered data is incorrect: try again!");
      continue;
    }

    final jsonData = jsonDecode(response.body);
    print("Conversion rate is: ${jsonData["conversion_rate"]}");
  }

  //print("API call result: ${jsonData["result"]}");
} //main



    // "base_code": "EUR",
    // "target_code": "GBP",
    // "conversion_rate": 0.8552
