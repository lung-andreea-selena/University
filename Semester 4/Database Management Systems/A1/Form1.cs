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
using System.Configuration;

namespace A1
{
    public partial class Form1 : Form
    {
        SqlConnection connection;
        SqlDataAdapter dataAdapterParent,dataAdapterChild;
        DataSet dataSet;
        SqlCommandBuilder commandBuilder;
        BindingSource bsParent, bsChild;
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
                string con = ConfigurationManager.ConnectionStrings["cn"].ConnectionString;
                connection = new SqlConnection(con);
                dataSet = new DataSet();
                string selectparent = ConfigurationManager.AppSettings["selectParent"];
                string selectchild = ConfigurationManager.AppSettings["selectChild"];
                dataAdapterParent = new SqlDataAdapter(selectparent, connection);
                dataAdapterChild = new SqlDataAdapter(selectchild, connection);
                commandBuilder = new SqlCommandBuilder(dataAdapterChild); //because we are modifing only the child table

                //we fill the dataset
                string parentname = ConfigurationManager.AppSettings["ParentTableName"];
                string childname = ConfigurationManager.AppSettings["ChildTableName"];
                string parentid = ConfigurationManager.AppSettings["ParentID"];
                string foreignkey = ConfigurationManager.AppSettings["ForeignKeyName"];
                dataAdapterChild.Fill(dataSet, childname);
                dataAdapterParent.Fill(dataSet, parentname);

                //define dataRelation between the tables
                DataRelation dr = new DataRelation(foreignkey, dataSet.Tables[parentname].Columns[parentid], dataSet.Tables[childname].Columns[parentid]);
                dataSet.Relations.Add(dr);

                //define 2 binding sources
                //the binding source is going to be associated with the content of the DataSet and aslo with the DataGridView in which the dataset is displayed
                bsParent = new BindingSource();
                bsChild = new BindingSource();

                //the connection between the tables (when i click in the datagridview of the Project to show the relevant children)
                bsParent.DataSource = dataSet;
                bsParent.DataMember = parentname;
                bsChild.DataSource = bsParent;
                bsChild.DataMember = foreignkey;

                ChildTable.DataSource = bsChild;
                ParentTable.DataSource = bsParent;
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
                string childname = ConfigurationSettings.AppSettings["ChildTableName"];
                dataAdapterChild.Update(dataSet, childname);
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


        private void Form1_Load(object sender, EventArgs e)
        {
            

        }

    }
}
