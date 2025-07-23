class Urls {
  static const String _baseUrl = 'https://api.restful-api.dev/objects';

  static const String getAllData = _baseUrl;

  static const String createData = _baseUrl;


  static String getSingleData(String taskId) =>
      '$_baseUrl/$taskId';

  static String updateData(String taskId) =>
      '$_baseUrl/$taskId';

  static String deleteData(String taskId) =>
      '$_baseUrl/$taskId';
}