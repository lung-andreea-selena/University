package com.example.mymedicalrecordsapp

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity

class EditRecordActivity : AppCompatActivity() {

    private lateinit var titleInput: EditText
    private lateinit var typeSpinner: Spinner
    private lateinit var moneySpentInput: EditText
    private lateinit var dateInput: EditText
    private lateinit var detailsInput: EditText
    private lateinit var saveButton: Button
    private lateinit var cancelButton: Button

    private var recordId: Int = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_edit_record)

        //initialize UI elements
        titleInput = findViewById(R.id.titleInput)
        typeSpinner = findViewById(R.id.typeSpinner)
        moneySpentInput = findViewById(R.id.moneySpentInput)
        dateInput = findViewById(R.id.dateInput)
        detailsInput = findViewById(R.id.detailsInput)
        saveButton = findViewById(R.id.saveButton)
        cancelButton = findViewById(R.id.cancelButton)

        //set up the Spinner with predefined types from resources
        val adapter = ArrayAdapter.createFromResource(
            this,
            R.array.record_types, //reference to the string array in strings.xml
            android.R.layout.simple_spinner_item //default layout for the spinner item
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        typeSpinner.adapter = adapter

        //retrieve and populate data
        recordId = intent.getIntExtra("recordId", -1)
        titleInput.setText(intent.getStringExtra("title"))
        moneySpentInput.setText(intent.getStringExtra("moneySpent"))
        dateInput.setText(intent.getStringExtra("date"))
        detailsInput.setText(intent.getStringExtra("details"))

        //set the Spinner's selection to match the existing type
        val recordType = intent.getStringExtra("type")
        if (recordType != null) {
            val spinnerPosition = adapter.getPosition(recordType)
            typeSpinner.setSelection(spinnerPosition)
        }

        //set up save button with validation checks
        saveButton.setOnClickListener {
            val isTitleValid = validateTitle()
            val isMoneySpentValid = validateMoneySpent()
            val isDateValid = validateDate()

            if (isTitleValid && isMoneySpentValid && isDateValid) {
                val updatedTitle = titleInput.text.toString()
                val updatedType = typeSpinner.selectedItem?.toString() ?: "" // Retrieve selected type from Spinner
                val updatedMoneySpent = moneySpentInput.text.toString()
                val updatedDate = dateInput.text.toString()
                val updatedDetails = detailsInput.text.toString()

                val resultIntent = Intent().apply {
                    putExtra("recordId", recordId)
                    putExtra("title", updatedTitle)
                    putExtra("type", updatedType)
                    putExtra("moneySpent", updatedMoneySpent)
                    putExtra("date", updatedDate)
                    putExtra("details", updatedDetails)
                }
                setResult(Activity.RESULT_OK, resultIntent)
                finish()
            }
        }

        // Cancel button listener
        cancelButton.setOnClickListener {
            finish() // Close the activity without returning any data
        }
    }

    // Validation functions
    private fun validateTitle(): Boolean {
        return if (titleInput.text.isNullOrBlank()) {
            titleInput.error = "Title is required"
            false
        } else {
            titleInput.error = null
            true
        }
    }

    private fun validateMoneySpent(): Boolean {
        val money = moneySpentInput.text.toString()
        return if (money.isBlank() || money.toFloatOrNull() == null) {
            moneySpentInput.error = "Enter a valid amount"
            false
        } else {
            moneySpentInput.error = null
            true
        }
    }

    private fun validateDate(): Boolean {
        return if (dateInput.text.isNullOrBlank()) {
            dateInput.error = "Date is required"
            false
        } else {
            dateInput.error = null
            true
        }
    }
}
