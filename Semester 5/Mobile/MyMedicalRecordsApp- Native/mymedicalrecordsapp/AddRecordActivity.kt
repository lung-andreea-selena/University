package com.example.mymedicalrecordsapp

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity

class AddRecordActivity : AppCompatActivity() {

    private lateinit var titleInput: EditText
    private lateinit var typeSpinner: Spinner
    private lateinit var moneySpentInput: EditText
    private lateinit var dateInput: EditText
    private lateinit var detailsInput: EditText
    private lateinit var saveButton: Button
    private lateinit var cancelButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_record)

        //initialize UI elements
        titleInput = findViewById(R.id.titleInput)
        typeSpinner = findViewById(R.id.typeSpinner)
        moneySpentInput = findViewById(R.id.moneySpentInput)
        dateInput = findViewById(R.id.dateInput)
        detailsInput = findViewById(R.id.detailsInput)
        saveButton = findViewById(R.id.saveButton)
        cancelButton = findViewById(R.id.cancelButton)

        //set up the Spinner with predefined types
        val adapter = ArrayAdapter.createFromResource(
            this,
            R.array.record_types, //reference to the string array in strings.xml
            android.R.layout.simple_spinner_item //default layout for the spinner item
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        typeSpinner.adapter = adapter

        //set up save button with validation checks
        saveButton.setOnClickListener {
            val isTitleValid = validateTitle()
            val isMoneySpentValid = validateMoneySpent()
            val isDateValid = validateDate()

            //proceed if all validations are true
            if (isTitleValid && isMoneySpentValid && isDateValid) {
                val title = titleInput.text.toString()
                val type = typeSpinner.selectedItem?.toString() ?: ""
                val moneySpent = moneySpentInput.text.toString()
                val date = dateInput.text.toString()
                val details = detailsInput.text.toString()

                val resultIntent = Intent().apply {
                    putExtra("title", title)
                    putExtra("type", type)
                    putExtra("moneySpent", moneySpent)
                    putExtra("date", date)
                    putExtra("details", details)
                }
                setResult(Activity.RESULT_OK, resultIntent)
                finish()
            }
        }

        cancelButton.setOnClickListener {
            finish() //close the activity without returning any data
        }
    }

    //validation functions
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
