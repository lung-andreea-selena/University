package com.example.mymedicalrecordsapp

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.widget.ImageButton
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.mymedicalrecordsapp.AddRecordActivity
import com.example.mymedicalrecordsapp.MedicalRecordAdapter
import com.example.mymedicalrecordsapp.MedicalRecordViewModel

class MainActivity : AppCompatActivity() {

    private val viewModel: MedicalRecordViewModel by viewModels()
    private lateinit var adapter: MedicalRecordAdapter

    companion object {
        private const val ADD_RECORD_REQUEST_CODE = 1
        private const val EDIT_RECORD_REQUEST_CODE = 2
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //set up RecyclerView
        adapter = MedicalRecordAdapter(
            onEditClick = { record -> editRecord(record) },
            onDeleteClick = { record -> showDeleteConfirmation(record)}
        )
        val recyclerView = findViewById<RecyclerView>(R.id.recyclerView)
        recyclerView.adapter = adapter
        recyclerView.layoutManager = LinearLayoutManager(this)

        //observe the LiveData from ViewModel
        viewModel.records.observe(this, Observer { records ->
            records?.let { adapter.setRecords(it) }
        })

        //initialize addRecordButton
        val addRecordButton = findViewById<ImageButton>(R.id.addRecordButton)
        addRecordButton.setOnClickListener {
            val intent = Intent(this, AddRecordActivity::class.java)
            startActivityForResult(intent, ADD_RECORD_REQUEST_CODE)
        }
    }

    private fun showDeleteConfirmation(record: MedicalRecord) {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Delete Record")
        builder.setMessage("Are you sure you want to delete ${record.title} from your medical records?")
        builder.setPositiveButton("Yes") { _, _ ->
            viewModel.deleteRecord(record.id)
        }
        builder.setNegativeButton("No") { dialog, _ ->
            dialog.dismiss()
        }
        builder.show()
    }

    //launch EditRecordActivity with existing record details
    private fun editRecord(record: MedicalRecord) {
        val intent = Intent(this, EditRecordActivity::class.java).apply {
            putExtra("recordId", record.id)
            putExtra("title", record.title)
            putExtra("type", record.type)
            putExtra("moneySpent", record.moneySpent.toString())
            putExtra("date", record.date)
            putExtra("details", record.details)
        }
        startActivityForResult(intent, EDIT_RECORD_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            when (requestCode) {
                ADD_RECORD_REQUEST_CODE -> {
                    val title = data?.getStringExtra("title").orEmpty()
                    val type = data?.getStringExtra("type").orEmpty()
                    val moneySpent = data?.getStringExtra("moneySpent").orEmpty()
                    val date = data?.getStringExtra("date").orEmpty()
                    val details = data?.getStringExtra("details").orEmpty()

                    viewModel.addRecord(title, type, moneySpent, date, details)
                }
                EDIT_RECORD_REQUEST_CODE -> {
                    val recordId = data?.getIntExtra("recordId", -1) ?: -1
                    val title = data?.getStringExtra("title").orEmpty()
                    val type = data?.getStringExtra("type").orEmpty()
                    val moneySpent = data?.getStringExtra("moneySpent").orEmpty().toFloatOrNull() ?: 0f
                    val date = data?.getStringExtra("date").orEmpty()
                    val details = data?.getStringExtra("details").orEmpty()

                    val updatedRecord = MedicalRecord(
                        id = recordId,
                        title = title,
                        type = type,
                        moneySpent = moneySpent,
                        date = date,
                        details = details
                    )
                    viewModel.updateRecord(updatedRecord)
                }
            }
        }
    }
}
