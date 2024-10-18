class ApiUrl {
  static const String baseUrl = 'http://103.196.155.42/api';

  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Pengeluaran endpoints
  static const String listPengeluaran = '$baseUrl/keuangan/pengeluaran';
  static const String createPengeluaran = '$baseUrl/keuangan/pengeluaran';

  static String showPengeluaran(int id) {
    return '$baseUrl/keuangan/pengeluaran/$id';
  }

  static String updatePengeluaran(int id) {
    return '$baseUrl/keuangan/pengeluaran/$id/update';
  }

  static String deletePengeluaran(int id) {
    return '$baseUrl/keuangan/pengeluaran/$id/delete';
  }


}