import 'package:get/get.dart';

class ProfileProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> logout(String token) {
    return post('/logout', {}, headers: {
      'Authorization': 'Bearer $token',
    });
  }

  Future<Response> summarySalesReport(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message' : 'success',
          'data' : {
            'total' : 45,
            'omset' : 2523525,
          }
        }
    );
  }

  Future<Response> fetchSalesReport(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
          'message' : 'success',
          'data' : [
            {
              "code": "TRX001",
              "user_id": 1,
              "date": "2025-08-01T09:15:00",
              "sell": 150000,
              "pay": 150000,
              "active": 1,
              "outlet" : "Tanggulangin"
            },
            {
              "code": "TRX002",
              "user_id": 2,
              "date": "2025-08-02T13:45:00",
              "sell": 200000,
              "pay": 180000,
              "active": 1,
              "outlet" : "Tanggulangin"
            },
            {
              "code": "TRX003",
              "user_id": 1,
              "date": "2025-08-03T10:00:00",
              "sell": 100000,
              "pay": 100000,
              "active": 0,
              "outlet" : "Tanggulangin"
            },
            {
              "code": "TRX004",
              "user_id": 3,
              "date": "2025-08-04T16:20:00",
              "sell": 50000,
              "pay": 50000,
              "active": 1,
              "outlet" : "Tanggulangin"
            },
            {
              "code": "TRX005",
              "user_id": 2,
              "date": "2025-08-05T11:10:00",
              "sell": 250000,
              "pay": 250000,
              "active": 1,
              "outlet" : "Tanggulangin"
            }
          ]
      }
    );
  }

  Future<Response> summaryAttendances(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message' : 'success',
          'data' : {
            'ontime' : 3,
            'late' : 2,
          }
        }
    );
  }

  Future<Response> fetchAttendances(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message' : 'success',
        'data' : [
          {
            "outlet": "Tanggulangi",
            "shift": "Shift 1",
            "is_late": false,
            "date_in": "2023-02-14T06:53:00",
            "date_out": "2023-02-14T06:53:00",
            "omset": 34543545,
            "is_deposit": true,
          },
          {
            "outlet": "Porong",
            "shift": "Shift 1",
            "is_late": false,
            "date_in": "2023-02-14T07:15:00",
            "date_out": "2023-02-14T15:00:00",
            "omset": 28750000,
            "is_deposit": true,
          },
          {
            "outlet": "Sidoarjo",
            "shift": "Shift 1",
            "is_late": false,
            "date_in": "2023-02-14T06:00:00",
            "date_out": "2023-02-14T14:00:00",
            "omset": 41200000,
            "is_deposit": true,
          },
          {
            "outlet": "Krian",
            "shift": "Shift 1",
            "is_late": false,
            "date_in": "2023-02-14T05:45:00",
            "date_out": "2023-02-14T13:45:00",
            "omset": 29890000,
            "is_deposit": true,
          },
          {
            "outlet": "Buduran",
            "shift": "Shift 1",
            "is_late": false,
            "date_in": "2023-02-14T07:05:00",
            "date_out": "2023-02-14T15:10:00",
            "omset": 36500000,
            "is_deposit": true,
          }
        ]
      }
    );
  }

  Future<Response> summaryDeposits(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message' : 'success',
          'data' : {
            'tabungan' : 334453434,
          }
        }
    );
  }

  Future<Response> fetchDeposits(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message' : 'success',
          'data' : [
            {
              "outlet": "Tanggulangi",
              "date": "2023-02-14T07:15:00",
              "omset": 34543545,
            },
            {
              "outlet": "Tanggulangi",
              "date": "2023-02-14T07:15:00",
              "omset": 34543545,
            },
            {
              "outlet": "Tanggulangi",
              "date": "2023-02-14T07:15:00",
              "omset": 34543545,
            },
            {
              "outlet": "Tanggulangi",
              "date": "2023-02-14T07:15:00",
              "omset": 34543545,
            },
          ]
        }
    );
  }

  Future<Response> fetchSchedule(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
      statusCode: 200,
      body: {
        'message': 'success',
        'data' : [
          {
            'outlet': 'Tanggulangin',
            'date': '2023-02-14T07:15:00',
            'shift': 'Shift 1',
          },
          {
            'outlet': 'Tanggulangin',
            'date': '2023-02-14T07:15:00',
            'shift': 'Shift 1',
          },
          {
            'outlet': 'Tanggulangin',
            'date': '2023-02-14T07:15:00',
            'shift': 'Shift 1',
          },
          {
            'outlet': 'Tanggulangin',
            'date': '2023-02-14T07:15:00',
            'shift': 'Shift 1',
          },
        ]
      }
    );
  }

  Future<Response> changePassword (String old_password, String new_password) async {
    await Future.delayed(Duration(seconds: 1));
    return Response(
        statusCode: 200, body: {
      'message': 'success'
    });
  }
}
