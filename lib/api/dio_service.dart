import 'package:cattlehealthtracker/api/api.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
class DioService {
  // create a private constructor

  // private constructor
  DioService._internal();

  static DioService? _instance;

  factory DioService() {
    _instance ??= DioService._internal();
    return _instance!;
  }
  late Dio _dio;

   Dio getDioInstance(){
    return _dio;
  }

  Future<Response> _executeWithTimeout(Future<Response> future){
     return future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
          error: "Manual timeout: request took too long to connect"
        );
      },
     );
  }

  void configureDio({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    void Function(RequestOptions options, RequestInterceptorHandler handler)? onRequest,
    void Function(Response response, ResponseInterceptorHandler handler)? onResponse,
    void Function(DioException e, ErrorInterceptorHandler handler)? onError
  }){
   
   _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout ?? const Duration(seconds: 20),
    receiveTimeout: receiveTimeout ?? const Duration(seconds: 20),
    headers: defaultHeaders ?? 
    {
      'Content-Type': 'application/json',
      'Accept' : 'application/json'
    }
    )
    );

    // _dio.interceptors.add(PrettyDioLogger());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest ??
        (options, handler){
          debugPrint('Request: ${options.method} ${options.path}');
          debugPrint('Headrs: ${options.headers}');
          debugPrint('Query Params: ${options.queryParameters}');
          handler.next(options);
        },
        onResponse: onResponse ??
        (response, handler){
          print('Response: ${response.statusCode} ${response.data}');
          debugPrint('Response: ${response.statusCode} ${response.data}');
          handler.next(response);
        },
        onError: onError ??
        (DioException e, handler)async{
           print("Interceptor error triggered");
          try{
            if(e.response?.statusCode == 400 || e.response?.statusCode == 403 || e.response?.statusCode == 429){
               return handler.resolve(e.response!);
            }
         if(e.response?.statusCode == 401){
           if (e.response?.data["error"] == "Refresh token expired") {
              AuthenticationCubit cubit = GetIt.instance<AuthenticationCubit>();
              print("logging out locally");
              await cubit.logoutLocally();
              return handler.reject(e); 

            }
          String oldAuth = e.requestOptions.headers["Authorization"];
          print("oldAuth $oldAuth");
          List<String?>? newTokens = await refreshToken();
          if(newTokens != null){
            e.requestOptions.headers["Authorization"] = "Bearer ${newTokens[0]}";
            String newAuth = e.requestOptions.headers["Authorization"];
            print("newAuth $newAuth");
            print("old auth == new auth: ${oldAuth == newAuth}");
            final clonedRequest = await _dio.request(
              e.requestOptions.path,
              data: e.requestOptions.path.endsWith("/logout")?{"refresh": newTokens[1]}: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters,
              options: Options(
                method: e.requestOptions.method,
                headers: {
                  "Authorization": newAuth
                  }
              )
            );

          return handler.resolve(clonedRequest);

          }
         }
         }
         catch(_){
          return handler.next(e);
         }
         

        }
      )
    );

  }


  Future<List<String?>?> refreshToken()async{
  final storage = FlutterSecureStorage();
          String? refreshToken = await storage.read(key: "refresh");
          Response response = await _dio.post(API.refreshTokenEnpoint, data: {
           "refresh": refreshToken
          });
await storage.write(key: "refresh", value: response.data["refresh"]);
await storage.write(key:"access", value: response.data["access"]);
List<String?>? newTokens = [response.data["access"], response.data["refresh"]];
      return newTokens;
  }

  Future<Response> getRequest(String endpoint,
  {Map<String, dynamic>? queryParameters})async{
    try{
      final response =  _dio.get(
        endpoint,
        queryParameters: queryParameters
      );
    return await _executeWithTimeout(response);
    }catch(e){
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint,
  Map<String, dynamic>? data,
  Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers) async {
    try{
      final response =  _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers
        )
      );
      return await _executeWithTimeout(response);
    }catch(e){
      rethrow;
    }
  }

}