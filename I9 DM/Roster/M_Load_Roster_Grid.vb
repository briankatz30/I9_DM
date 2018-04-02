Module M_Load_Roster_Grid
    Public Sub Load_Roster_GridView()
        '****************************************************************************
        ' Sub Routine to load the Roster GridViews onto the Main Form
        '****************************************************************************
        Dim oledbAdapter As OleDbDataAdapter
        Dim Rs As New DataSet

        Try
            'Resets the Datasource for each DataGridView to Nothing for viewing purposes
            Form1.RosterDataGridView.DataSource = Nothing
            Form1.Refresh()
            Form1.Cursor = Cursors.WaitCursor
            'Load the Roster Grid View with the Roster Table Data
            Form1.ToolStripStatusLabel2.Text = "Loading Roster Data...."
            Form1.Refresh()
            oledbAdapter = New OleDbDataAdapter("EXEC dbo.SP_LOAD_ROSTER", Client_Conn)
            oledbAdapter.Fill(Rs)
            Form1.RosterDataGridView.DataSource = Rs.Tables(0)
            Form1.RosterDataGridView.Refresh()
            Form1.Refresh()
            Form1.ToolStripStatusLabel2.Text = "All Roster Records...."
            'Change the mouse cursor back to the default
            Form1.Cursor = Cursors.Default

            'Get the Stats from the Roster Table and Loads them into the Roster ListView
            Get_Stats_Roster()

            'Housekeeping
            oledbAdapter.Dispose()

        Catch ex As Exception
            MsgBox(ex.ToString)

        End Try

    End Sub

End Module
