import '../models/medical_record.dart';

class MockData {
  static List<MedicalRecord> records = [
    MedicalRecord(
      id: 1,
      title: "Remake prescription",
      type: "Other",
      moneySpent: 0,
      date: "2024-10-02",
      details: "Regular check-up",
    ),
    MedicalRecord(
      id: 2,
      title: "Dentist",
      type: "Appointment",
      moneySpent: 100,
      date: "2024-10-14",
      details: "Regular check-up",
    ),
    MedicalRecord(
      id: 3,
      title: "Upper body X-ray",
      type: "Lab Tests",
      moneySpent: 150,
      date: "2024-11-10",
      details: "Checked because of back pain",
    ),
    MedicalRecord(
      id: 4,
      title: "Back pain",
      type: "Medical Issues",
      moneySpent: 14,
      date: "2024-09-08",
      details: "Bought ibuprofen",
    ),
  ];
}
