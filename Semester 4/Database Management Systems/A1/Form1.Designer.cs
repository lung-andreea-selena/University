namespace A1
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ParentTable = new System.Windows.Forms.DataGridView();
            this.ChildTable = new System.Windows.Forms.DataGridView();
            this.Connect_button = new System.Windows.Forms.Button();
            this.Update_button = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.ParentTable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ChildTable)).BeginInit();
            this.SuspendLayout();
            // 
            // ParentTable
            // 
            this.ParentTable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.ParentTable.Location = new System.Drawing.Point(28, 33);
            this.ParentTable.Name = "ParentTable";
            this.ParentTable.RowHeadersWidth = 51;
            this.ParentTable.RowTemplate.Height = 24;
            this.ParentTable.Size = new System.Drawing.Size(556, 183);
            this.ParentTable.TabIndex = 0;
            // 
            // ChildTable
            // 
            this.ChildTable.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.ChildTable.Location = new System.Drawing.Point(28, 236);
            this.ChildTable.Name = "ChildTable";
            this.ChildTable.RowHeadersWidth = 51;
            this.ChildTable.RowTemplate.Height = 24;
            this.ChildTable.Size = new System.Drawing.Size(556, 184);
            this.ChildTable.TabIndex = 1;
            // 
            // Connect_button
            // 
            this.Connect_button.Location = new System.Drawing.Point(642, 71);
            this.Connect_button.Name = "Connect_button";
            this.Connect_button.Size = new System.Drawing.Size(163, 57);
            this.Connect_button.TabIndex = 2;
            this.Connect_button.Text = "Connect";
            this.Connect_button.UseVisualStyleBackColor = true;
            this.Connect_button.Click += new System.EventHandler(this.Connect_button_Click);
            // 
            // Update_button
            // 
            this.Update_button.Location = new System.Drawing.Point(642, 270);
            this.Update_button.Name = "Update_button";
            this.Update_button.Size = new System.Drawing.Size(163, 60);
            this.Update_button.TabIndex = 3;
            this.Update_button.Text = "Update";
            this.Update_button.UseVisualStyleBackColor = true;
            this.Update_button.Click += new System.EventHandler(this.Update_button_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(881, 450);
            this.Controls.Add(this.Update_button);
            this.Controls.Add(this.Connect_button);
            this.Controls.Add(this.ChildTable);
            this.Controls.Add(this.ParentTable);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.ParentTable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ChildTable)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView ParentTable;
        private System.Windows.Forms.DataGridView ChildTable;
        private System.Windows.Forms.Button Connect_button;
        private System.Windows.Forms.Button Update_button;
    }
}

