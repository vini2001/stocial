class Urls {
  static TDAmeritradeUrls tdAmeritrade = TDAmeritradeUrls();
}

class TDAmeritradeUrls {
  String tokenUrl = 'https://api.tdameritrade.com/v1/oauth2/token';

  String authenticate({required String consumerKey}) {
    return 'https://auth.tdameritrade.com/auth?response_type=code&redirect_uri=https://anjinhoseguros.com.br&client_id=$consumerKey@AMER.OAUTHAP';
  }
}