Module M_Load_Transcription_Grid
    Public Sub Load_Transcription_GridView()
        '****************************************************************************
        '  Sub Routine to load the Transcription GridViews on the Main Form
        '****************************************************************************
        Dim oledbAdapter As OleDbDataAdapter
        Dim I9S As New DataSet

        Try
            'Resets the Datasource for each DataGridView to Nothing for viewing purposes
            Form1.I9DataGridView.DataSource = Nothing
            Form1.Refresh()
            Form1.Cursor = Cursors.WaitCursor
            'Load the Transcription Grid View with the I9 Table
            Form1.ToolStripStatusLabel2.Text = "Loading Transcription Data..."
            Form1.Refresh()
            oledbAdapter = New OleDbDataAdapter("EXEC dbo.SP_LOAD_I9", Client_Conn)
            oledbAdapter.Fill(I9S)
            Form1.I9DataGridView.DataSource = I9S.Tables(0)
            Form1.I9DataGridView.Refresh()

            'Hides 2 of the Columns that are not needed
            Form1.I9DataGridView.Columns("2 Page Flag").Visible = False
            Form1.I9DataGridView.Columns("Section 3 Flag").Visible = False
            Form1.ToolStripStatusLabel2.Text = "All Transcript Records...."

            'Load the Transcription ListView
            Load_Transcription_ListView()

            'Change the mouse cursor back to the default
            Form1.Cursor = Cursors.Default

            'Housekeeping
            oledbAdapter.Dispose()

        Catch ex As Exception
            MsgBox(ex.ToString)
        End Try

    End Sub

End Module
