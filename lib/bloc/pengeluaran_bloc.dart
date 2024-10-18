import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/pengeluaran.dart';

class PengeluaranBloc {
  static Future<List<Pengeluaran>> getPengeluarans() async {
    String apiUrl = ApiUrl.listPengeluaran;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPengeluaran = (jsonObj as Map<String, dynamic>)['data'];
    List<Pengeluaran> pengeluarans = [];
    for (int i = 0; i < listPengeluaran.length; i++) {
      pengeluarans.add(Pengeluaran.fromJson(listPengeluaran[i]));
    }
    return pengeluarans;
  }

  static Future addPengeluaran({Pengeluaran? pengeluaran}) async {
    String apiUrl = ApiUrl.createPengeluaran;

    var body = {
      "expense": pengeluaran!.expense,
      "cost": pengeluaran.cost.toString(),
      "category": pengeluaran.category
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePengeluaran({required Pengeluaran pengeluaran}) async {
    String apiUrl = ApiUrl.updatePengeluaran(pengeluaran.id!);
    print(apiUrl);

    var body = {
      "expense": pengeluaran.expense,
      "cost": pengeluaran.cost,
      "category": pengeluaran.category
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePengeluaran({int? id}) async {
    String apiUrl = ApiUrl.deletePengeluaran(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}