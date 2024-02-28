import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//''
// ""
// =
// +
// {}

void main() async {
  ExchangeRates tradeInfo = await fetchData();
  // print(tradeInfo.result);
  // print(tradeInfo.documentation);
  // print(tradeInfo.timeLastUpdate);
  // print(tradeInfo.baseCode);
  // print(tradeInfo.conversion[1].key);
  // print(tradeInfo.conversion[1].value);

  //getting currency data from user to convert in USD
  print("Enter Symbol");
  String? enteredSymbol = stdin.readLineSync();
  print("Enter Amount");
  num enteredAmount = num.parse(stdin.readLineSync() ?? "1.0");
  dynamic? obtainedInDollars;

  //---using for loop
  // for (int i = 0; i < tradeInfo.conversion.length; i++) {
  //   if (tradeInfo.conversion[i].key == (enteredSymbol)?.toUpperCase()) {
  //     obtainedInDollars = tradeInfo.conversion[i].value * enteredAmount;
  //     print(tradeInfo.conversion[i].key);
  //   }
  // }
  // if (obtainedInDollars != null) {
  //   print("Your amount in dollars will be $obtainedInDollars");
  // } else {
  //   print("The entered data in incorrect");
  // }

  //---using firstWhere method (best-- bana e is kam k liye)
  // final symbolFoundFirstWhere = (tradeInfo.conversion).firstWhere((e) {
  //   if (e.key == enteredSymbol) {
  //     return true;
  //   }
  //   return false;
  // });
  // print(
  //     "The value for conversion of ${symbolFoundFirstWhere.key} is ${symbolFoundFirstWhere.value}");

  //---using where method
  // final symbolFoundWhere = tradeInfo.conversion.where((e) {
  //   if (e.key == enteredSymbol) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // });
  // print(
  //     "The value for conversion of ${symbolFoundWhere.elementAt(0).key} is ${symbolFoundWhere.elementAt(0).value}");


}//main



//fetching the api data
Future<ExchangeRates> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://v6.exchangerate-api.com//v6/0a9a46f3bcd3746201b7c7ed/latest/USD'));
  //returning data
  return ExchangeRates.fromJson(jsonDecode(response.body));
}

//class to make objects from api data
class ExchangeRates {
  final String result;
  final String documentation;
  final String timeLastUpdate;
  final String baseCode;
  final List<Conversion> conversion;

  const ExchangeRates(
      {required this.result,
      required this.documentation,
      required this.timeLastUpdate,
      required this.baseCode,
      required this.conversion});

  factory ExchangeRates.fromJson(Map<String, dynamic> map) {
    return ExchangeRates(
        result: map["result"],
        documentation: map["documentation"],
        timeLastUpdate: map["time_last_update_utc"],
        baseCode: map["base_code"], //Conversion.fromJson()
        conversion: (map["conversion_rates"])
            .entries
            .map<Conversion>((e) => Conversion.fromJson(e.key, e.value))
            .toList());
  }
}

//a class to deal map data in the api data
class Conversion {
  final String key;
  final num value;

  const Conversion({required this.key, required this.value});

  factory Conversion.fromJson(String kkey, num vvalue) {
    return Conversion(key: kkey, value: vvalue);
  }
}



// "result": "success",
// "documentation": "https://www.exchangerate-api.com/docs",
// "terms_of_use": "https://www.exchangerate-api.com/terms",
// "time_last_update_unix": 1708560001,
// "time_last_update_utc": "Thu, 22 Feb 2024 00:00:01 +0000",
// "time_next_update_unix": 1708646401,
// "time_next_update_utc": "Fri, 23 Feb 2024 00:00:01 +0000",
// "base_code": "USD",
// "conversion_rates": {
//     "USD": 1,
//     "AED": 3.6725,
