import 'package:get/get.dart';

class HomeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> updateUserData(String token) => get('/attendance', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

  Future<Response> getListProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'success',
        'data': [
          {
            'id': 344,
            'name': 'Tambah Angin Motor',
            'type': 'Motor',
            'price': 5000
          },
          {
            'id': 345,
            'name': 'Tambah Angin Mobil',
            'type': 'Mobil',
            'price': 8000
          },
          {
            'id': 346,
            'name': 'Ganti Oli Motor',
            'type': 'Motor',
            'price': 35000
          },
          {
            'id': 347,
            'name': 'Ganti Oli Mobil',
            'type': 'Mobil',
            'price': 75000
          },
          {
            'id': 348,
            'name': 'Cuci Motor',
            'type': 'Motor',
            'price': 15000
          },
          {
            'id': 349,
            'name': 'Cuci Mobil',
            'type': 'Mobil',
            'price': 30000
          },
          {
            'id': 350,
            'name': 'Servis Ringan Motor',
            'type': 'Motor',
            'price': 50000
          },
          {
            'id': 351,
            'name': 'Servis Ringan Mobil',
            'type': 'Mobil',
            'price': 120000
          },

        ]
      },
    );
  }

  Future<Response> sendListProducts(transaction, item) async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message': 'success',
        }
    );
  }

}
