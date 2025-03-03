class MedicalRecord {
  int? id;
  String title;
  String type;
  double moneySpent;
  String date;
  String details;

  MedicalRecord({
    this.id,
    required this.title,
    required this.type,
    required this.moneySpent,
    required this.date,
    required this.details,
  });

  //convert a record into a Map, the keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'moneySpent': moneySpent,
      'date': date,
      'details': details,
    };
  }

  //convert a map into a MedicalRecord instance
  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      moneySpent: map['moneySpent'],
      date: map['date'],
      details: map['details'],
    );
  }

  @override
  String toString() {
    return 'MedicalRecord{id: $id, title: $title, type: $type, moneySpent: $moneySpent, date: $date, details: $details}';
  }
}
