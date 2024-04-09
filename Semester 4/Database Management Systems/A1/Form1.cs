using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace A1
{
    public partial class Form1 : Form
    {
        SqlConnection connection;
        SqlDataAdapter dataAdapterOrganization,dataAdapterDepartment;
        DataSet dataSet;
        SqlCommandBuilder commandBuilder;
        BindingSource bsOrganization, bsDepartment;
        public Form1()
        {
            InitializeComponent();

            //adding the ChildTable_DataError method as an event handler for the DataError event of the ChildTable DataGridView control
            ChildTable.DataError += ChildTable_DataError;
        }

        private void Connect_button_Click(object sender, EventArgs e)
        {
            try
            {
                connection = new SqlConnection(getConnectionString());
                dataSet = new DataSet();
                dataAdapterOrganization = new SqlDataAdapter("select * from Organization", connection);
                dataAdapterDepartment = new SqlDataAdapter("select * from Department", connection);
                commandBuilder = new SqlCommandBuilder(dataAdapterDepartment); //because we are modifing only the child table

                //we fill the dataset
                dataAdapterDepartment.Fill(dataSet, "Department");
                dataAdapterOrganization.Fill(dataSet, "Organization");

                //define dataRelation between the tables
                DataRelation dr = new DataRelation("FK_Organization_Department", dataSet.Tables["Organization"].Columns["OId"], dataSet.Tables["Department"].Columns["OId"]);
                dataSet.Relations.Add(dr);

                //define 2 binding sources
                //the binding source is going to be associated with the content of the DataSet and aslo with the DataGridView in which the dataset is displayed
                bsOrganization = new BindingSource();
                bsDepartment = new BindingSource();

                //the connection between the tables (when i click in the datagridview of the Project to show the relevant children)
                bsOrganization.DataSource = dataSet;
                bsOrganization.DataMember = "Organization";
                bsDepartment.DataSource = bsOrganization;
                bsDepartment.DataMember = "FK_Organization_Department";

                ChildTable.DataSource = bsDepartment;
                ParentTable.DataSource = bsOrganization;
            }catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void Update_button_Click(object sender, EventArgs e)
        {
            //to delete -> select the line and press delete from keybord
            try
            {
                dataAdapterDepartment.Update(dataSet, "Department");
                MessageBox.Show("Update successful.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Invalid data type. Please check the data you are inserting or updating.");
            }
        }
        private void ChildTable_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            // cancel the error from being shown in the DataGridView's default error dialog
            e.Cancel = true;

            // handling the error here
            MessageBox.Show("Error! Please provide valid input types", "Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private static String getConnectionString()
        {
            return "Data Source=DESKTOP-TK1OG7J\\SQLEXPRESS;Initial Catalog=\"Student Organizations\"; Integrated Security = true";
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            

        }

    }
}
