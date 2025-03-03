package com.example.mymedicalrecordsapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class MedicalRecordAdapter(
    private val onEditClick: (MedicalRecord) -> Unit,
    private val onDeleteClick: (MedicalRecord) -> Unit // Lambda function to handle edit and delete click
) : RecyclerView.Adapter<MedicalRecordAdapter.MedicalRecordViewHolder>() {

    private var records = emptyList<MedicalRecord>()

    inner class MedicalRecordViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val title: TextView = itemView.findViewById(R.id.recordTitle)
        val type: TextView = itemView.findViewById(R.id.recordType)
        val date: TextView = itemView.findViewById(R.id.recordDate)
        val moneySpent: TextView = itemView.findViewById(R.id.recordMoneySpent)
        val details: TextView = itemView.findViewById(R.id.recordDetails)
        val editIcon: ImageView = itemView.findViewById(R.id.editIcon)
        val deleteIcon: ImageView = itemView.findViewById(R.id.deleteIcon)

        //bind data to the view holder
        fun bind(record: MedicalRecord) {
            title.text = record.title
            type.text = record.type
            date.text = record.date
            moneySpent.text = "$${record.moneySpent}"
            details.text = record.details

            //set up click listener for the edit icon
            editIcon.setOnClickListener {
                onEditClick(record)
            }

            deleteIcon.setOnClickListener {
                onDeleteClick(record)
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MedicalRecordViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_medical_record, parent, false)
        return MedicalRecordViewHolder(view)
    }

    override fun onBindViewHolder(holder: MedicalRecordViewHolder, position: Int) {
        holder.bind(records[position]) //call bind function to set data and listener
    }

    override fun getItemCount() = records.size

    fun setRecords(newRecords: List<MedicalRecord>) {
        records = newRecords
        notifyDataSetChanged()
    }
}
