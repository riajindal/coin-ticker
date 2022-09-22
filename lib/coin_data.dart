import 'utilities/networking.dart';

const appid = '5B71C86C-BCF2-4817-9461-8890CA6D64DA';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(
      String selectedCoin, String selectedCurrency) async {
    Networking networking = Networking(
        url:
            'https://rest.coinapi.io/v1/exchangerate/$selectedCoin/$selectedCurrency?apikey=$appid');
    var coinData = await networking.getData();
    return coinData;
  }
}
