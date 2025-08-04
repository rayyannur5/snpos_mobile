import 'package:get/get.dart';

class AttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Response> getAbsenStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'Sudah Absen',
        'data': 'N'
      },
    );
  }

  Future<Response> getShifts() async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'success',
        'data': [
          {
            'id' : 1,
            'name' : 'Shift 1'
          },
          {
            'id' : 2,
            'name' : 'Shift 2'
          },
          {
            'id' : 3,
            'name' : 'Shift 3'
          },
        ]
      },
    );
  }

  Future<Response> getOutlets() async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'success',
        'data': [
          {
            "id": 1,
            "area_id": 1,
            "name": "KETINTANG",
            "description": "Jalan Ketintang M",
            "active": 1,
            "latitude": -7.311411,
            "longitude": 112.724059,
            "created_at": "2025-07-28 19:57",
            "updated_at": "2025-07-28 20:49"
          },
          {
            "id": 2,
            "area_id": 2,
            "name": "TROPODO",
            "description": null,
            "active": 1,
            "latitude": -7.368702,
            "longitude": 112.763632,
            "created_at": "2025-07-29 08:21",
            "updated_at": "2025-07-29 08:21"
          }
        ]
      },
    );
  }

  Future<Response> sendAttendance({outletId, shiftId, latitude, longitude, namedLocation, path}) async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'success',
        'data' : []
      }
    );

  }

  Future<Response> getTransactionNotDepositYet () async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message': 'success',
          'data' : {
            'totalAmount' : 3000000,
            'items': [
              {
                'productId': 1,
                'productName': 'Service Rutin',
                'qty': 10,
                'price': 100000,
                'totalAmount': 1000000
              },
              {
                'productId': 2,
                'productName': 'Ganti Oli',
                'qty': 20,
                'price': 50000,
                'totalAmount': 1000000
              },
              {
                'productId': 3,
                'productName': 'Ganti Ban',
                'qty': 5,
                'price': 200000,
                'totalAmount': 1000000
              }
            ]
          },
        }
    );
  }

  Future<Response> deposit () async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message': 'success',
        }
    );
  }

}
