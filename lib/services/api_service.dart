import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _apiKey = 'reqres-free-v1';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://reqres.in/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Fetch daftar pengguna / mahasiswa dari ReqRes API (P02 & P03)
  /// Menggunakan Future (Spesifikasi Async P01 & P02)
  Future<List<UserModel>> fetchUsers({String? token}) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {'per_page': 12},
        options: Options(
          headers: {
            'x-api-key': _apiKey,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      final List data = response.data['data'] as List;
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Fetch detail satu mahasiswa berdasarkan ID
  Future<UserModel> fetchUserById(int id) async {
    try {
      final response = await _dio.get(
        '/users/$id',
        options: Options(headers: {'x-api-key': _apiKey}),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    } catch (e) {
      throw Exception('Gagal memuat detail mahasiswa: $e');
    }
  }

  /// Helper penanganan pesan error Dio yang ramah pengguna (Sesuai Materi P02 & P03)
  String _friendlyMessage(DioException e) {
    final status = e.response?.statusCode;
    final serverError = e.response?.data is Map
        ? (e.response?.data as Map)['error']?.toString()
        : null;

    if (status == 401) {
      return '401 Unauthorized${serverError != null ? ': $serverError' : ''}. '
          'ReqRes wajib header x-api-key. Periksa ApiService._apiKey.';
    }
    if (status == 403) {
      return '403 Forbidden${serverError != null ? ': $serverError' : ''}. '
          'API key ditolak atau batas kuota habis.';
    }
    if (status != null && status >= 500) {
      return 'Server error ($status). Coba beberapa saat lagi.';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout: Server tidak merespons. Periksa koneksi internet Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet / server ReqRes tidak terjangkau.';
      case DioExceptionType.badResponse:
        return serverError ?? 'Respons server tidak valid (Kode: $status).';
      default:
        return serverError ?? e.message ?? 'Gagal mengambil data dari server ReqRes.';
    }
  }
}
