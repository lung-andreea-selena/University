package com.example.mymedicalrecordsapp

data class MedicalRecord (
    val id: Int,
    val title: String,
    val type: String,
    val moneySpent: Float,
    val date: String,
    val details: String
)