import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

CoinData coinData = CoinData();

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> conversionRate = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    for (String crypto in cryptoList) {
      var coinData = await CoinData().getCoinData(crypto, selectedCurrency);
      isWaiting = false;
      double rate = coinData['rate'];
      setState(() {
        conversionRate[crypto] = rate.toStringAsFixed(0);
      });
    }
  }

  Widget getAndroidPicker() {
    List<DropdownMenuItem<String>> dropdownValues = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownValues.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownValues,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getData();
          },
        );
      },
    );
  }

  Widget getIOSPicker() {
    List<Text> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: dropdownItems,
    );
  }

  Column makeCards() {
    List<Widget> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          crypto: crypto,
          value: isWaiting ? '?' : conversionRate[crypto],
          currency: selectedCurrency,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? getAndroidPicker() : getIOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String crypto;
  final String value;
  final String currency;

  CryptoCard({this.crypto, this.value, this.currency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
