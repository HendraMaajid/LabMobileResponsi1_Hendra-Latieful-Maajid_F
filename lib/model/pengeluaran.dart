class Pengeluaran {
  int? id;
  String? expense;
  int? cost;
  String? category;

  Pengeluaran({this.id, this.expense, this.cost, this.category});

  factory Pengeluaran.fromJson(Map<String, dynamic> obj) {
    return Pengeluaran(
      id: obj['id'],
      expense: obj['expense'],
      cost: obj['cost'],
      category: obj['category'],
    );
  }
}