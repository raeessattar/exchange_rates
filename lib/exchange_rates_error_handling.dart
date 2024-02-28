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

  bool loopFlagCurrency = true;
  bool loopFlagAmount = true;
  late Conversion symbolFoundFirstWhere;
  num? enteredAmount;
  print("Please Enter the following details for currency conversion:");

  //loop for name of currency
  while (loopFlagCurrency) {
    //getting currency data from user to convert in USD
    print("Enter Symbol of currency you want");
    String enteredSymbol = stdin.readLineSync()?.toUpperCase() ?? "";
    //check if the entered string is empty and length is correct?
    if (enteredSymbol.isEmpty) {
      print("You didnot entered any symbol! Please try again");
      continue;
    } else if (enteredSymbol.length != 3) {
      print("You entered wrong abbreviation of symbol! Please try again");
      continue;
    }
    //---using firstWhere method (best-- bana e is kam k liye)
    symbolFoundFirstWhere = (tradeInfo.conversion).firstWhere((e) {
      if (e.key == enteredSymbol) {
        loopFlagCurrency = false;
        return true;
      }
      return false;
    }, orElse: () {
      //dummy value to highlight wrond details entered
      return Conversion.fromJson("USD", -1);
    });
    //check if orElse executed to start again
    if (symbolFoundFirstWhere.value == -1) {
      print("Entered Symbol is incorrect: Try again");
      continue;
    }
  } //loop currency

  //loop for amount of currency
  while (loopFlagAmount) {
    //entering the amount
    print("Enter Amount in Dollars to convert");
    String? dummyAmount = stdin.readLineSync();
    enteredAmount = num.tryParse(dummyAmount ?? "");
    //check if the entered amount is not null and in minus
    if (dummyAmount == "") {
      print("You didnot entered any amount! Please try again");
      continue;
    } else if (enteredAmount == null) {
      print("You entered wrong amount! Please try again");
      continue;
    } else if (enteredAmount <= 0) {
      print("You entered currency in minus! Please try again");
      continue;
    } else {
      loopFlagAmount = false;
    }
  } //loop amount

  //remaining calculations
  dynamic amountInNewCurrency;
  amountInNewCurrency = enteredAmount! * symbolFoundFirstWhere.value;
  print("The amount in ${symbolFoundFirstWhere.key} will be $amountInNewCurrency");

} //main

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
