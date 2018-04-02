Imports System.IO
Imports System.Data.SqlClient

Module M_Import_Excel
    Dim BuildTempTable As String

    Public Sub ImportDataFromExcel(ExcelFilePath As String)
        '*************************************************************
        ' Module to import an Excel Overlay Spreadsheet for receiving client 
        ' data to fix errors and allowing the user to mapped the fields to the roster
        ' table
        '*************************************************************

        Dim MyCommand As New System.Data.OleDb.OleDbDataAdapter
        'Dim MyConnection As System.Data.OleDb.OleDbConnection
        'Dim MyExcelDataQuery As String = "SELECT * FROM  [SHEET1$]"
        Dim Ds As New DataSet
        Dim Rs As New DataSet
        Dim Rt As New DataTable
        Dim Conn As New SqlConnection
        Dim Conn1 As New OleDbConnection(Client_Conn)
        Dim SR As StreamReader = New StreamReader(ExcelFilePath)
        Dim line As String = SR.ReadLine()
        Dim strArray As String() = line.Split(","c)
        Dim dtcsv As DataTable = New DataTable()
        Dim row1 As DataRow

        Try
            'Create a connection string to Excel
            'MyConnection = New System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0; Data Source='" & ExcelFilePath & " '; " & "Extended Properties='Excel 8.0;HDR=Yes;IMEX=1;';")
            'MyCommand = New OleDbDataAdapter(MyExcelDataQuery, MyConnection)
            'MyCommand.Fill(Ds)
            'Dt = Ds.Tables(0)
            BuildTempTable = Nothing

            'Need to load the combo box in the grid with the field names of the Roster Table
            Dim cmb As New DataGridViewComboBoxColumn()
            cmb.HeaderText = "Roster Field Names"
            cmb.Name = "RosterColumnField"
            MyCommand = New OleDbDataAdapter("Select Name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Roster') and column_id Between 2 and 36 ;", Client_Conn)
            MyCommand.Fill(Rs)
            Rt = Rs.Tables(0)

            BuildTempTable = ""

            For Each s As String In strArray
                dtcsv.Columns.Add(New DataColumn(s))
                BuildTempTable = BuildTempTable & "[" & s.ToString & "] NVARCHAR(255), "
            Next

            'Create a table based on fields of the file that is used for the Overlay
            BuildTempTable = "CREATE TABLE TEMP_ROSTER (" & BuildTempTable
            BuildTempTable = BuildTempTable.Remove(BuildTempTable.Length - 2) & "); "
            'Create a Temp Table for the File to be loaded into
            BuildTempTable = "IF OBJECT_ID('TEMP_ROSTER') IS NOT NULL BEGIN DROP TABLE TEMP_ROSTER End " & BuildTempTable
            'Console.Write(BuildTempTable.ToString)
            Dim cmd = New OleDbCommand(BuildTempTable, Conn1)
            Conn1.Open()
            cmd.ExecuteNonQuery()
            Conn1.Close()



            'Loads the remainder of the text file into the Data Table
            Do
                line = SR.ReadLine
                If Not line = String.Empty Then
                    row1 = dtcsv.NewRow()
                    row1.ItemArray = line.Split(","c)
                    dtcsv.Rows.Add(row1)
                Else
                    Exit Do
                End If
            Loop

            'Load the field header row from the spreadsheet to the grid
            For Each Column As DataColumn In dtcsv.Columns
                F_Mapping.FieldMappingGV.Rows.Add(False, Column.ColumnName, "->")
                F_Mapping.PrimaryKeyComboBox.Items.Add(Column.ColumnName)
            Next

            'Loads the Roster Columns into the Grid
            F_Mapping.ForeginKeyComboBox.Items.Add("ID")
            cmb.Items.Add(" ")
            For Each Row As DataRow In Rt.Rows
                cmb.Items.Add(Row(0).ToString)
                F_Mapping.ForeginKeyComboBox.Items.Add(Row(0).ToString)
            Next

            'Add the Combo Box to the grid
            F_Mapping.FieldMappingGV.Columns.Add(cmb)
            F_Mapping.FieldMappingGV.Columns(3).Width = 300

            Dim SqlConnect As String
            SqlConnect = Replace(Client_Conn, "Provider=SQLOLEDB.1;", "")
            Using cn As New SqlConnection(SqlConnect)
                cn.Open()
                Using copy As New SqlBulkCopy(cn)
                    'Uses the SqlBulk Copy Class to load the Data Table into the newly created Table
                    copy.DestinationTableName = "TEMP_ROSTER"
                    copy.WriteToServer(dtcsv)
                End Using
            End Using

            'Close the adaptor
            MyCommand.Dispose()
            dtcsv.Dispose()
            Rt.Dispose()

        Catch ex As Exception
            MsgBox(ex.ToString)

        End Try

    End Sub

End Module
