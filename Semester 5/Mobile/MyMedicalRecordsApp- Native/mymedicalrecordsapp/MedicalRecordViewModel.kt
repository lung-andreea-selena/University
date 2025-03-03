package com.example.mymedicalrecordsapp

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class MedicalRecordViewModel : ViewModel() {
    private val _records = MutableLiveData<MutableList<MedicalRecord>>(mutableListOf())
    val records: LiveData<MutableList<MedicalRecord>> = _records

    init{
        //mock data
        _records.value = mutableListOf(
            MedicalRecord(1, "Dentist", "Appointment", 100.0f, "2024-10-14", "Regular check-up"),
            MedicalRecord(2, "Upper body X-ray", "Lab tests", 150.0f, "2024-09-10", "Checked because of back pain"),
            MedicalRecord(3, "Back pain", "Medical issues", 14.0f, "2024-09-08", "Bought ibuprofen"),
            MedicalRecord(4, "Sore throat", "Medical issues", 20.0f, "2024-09-08", "Antibiotics for 7 days"),
            MedicalRecord(5, "Sore throat", "Medical issues", 20.0f, "2024-09-08", "Antibiotics for 7 days"),
            MedicalRecord(6, "Sore throat", "Medical issues", 20.0f, "2024-09-08", "Antibiotics for 7 days"),
            MedicalRecord(7, "Sore throat", "Medical issues", 20.0f, "2024-09-08", "Antibiotics for 7 days"),
            MedicalRecord(8, "Sore throat", "Medical issues", 20.0f, "2024-09-08", "Antibiotics for 7 days")
        )
    }

    // add, update, delete
    fun addRecord(title: String, type: String, moneySpent: String, date: String, details: String) {
        val nextId = (_records.value?.maxOfOrNull { it.id } ?: 0) + 1
        val newRecord = MedicalRecord(nextId, title, type, moneySpent.toFloat(), date, details)
        _records.value?.add(newRecord)
        _records.value = _records.value //trigger observers to refresh
    }

    fun getNextId(): Int {
        return (_records.value?.maxOfOrNull { it.id } ?: 0) + 1
    }

    fun updateRecord(record: MedicalRecord) {
        _records.value = _records.value?.map {
            if (it.id == record.id) record else it
        }?.toMutableList() //convert back to MutableList
    }

    fun deleteRecord(id: Int) {
        _records.value = _records.value?.filter { it.id != id }?.toMutableList() //convert back to MutableList
    }
}