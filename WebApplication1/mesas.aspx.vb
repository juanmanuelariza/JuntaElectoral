
Partial Class mesas
    Inherits System.Web.UI.Page

    Private Sub mesas_Init(sender As Object, e As EventArgs) Handles Me.Init
        mostrar_panel1()
    End Sub

    Private Sub mostrar_panel1()
        Panel1.Visible = True
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = False
        actualiza()
    End Sub

    Private Sub mostrar_panel2()
        Panel1.Visible = True
        Panel2.Visible = True
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = False
        actualiza()
    End Sub

    Private Sub mostrar_panel3()
        Panel1.Visible = True
        Panel2.Visible = False
        Panel3.Visible = True
        Panel4.Visible = False
        Panel5.Visible = False
        actualiza()
    End Sub

    Private Sub mostrar_panel4()
        Panel1.Visible = False
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = True
        Panel5.Visible = False
        actualiza()
    End Sub
    Private Sub mostrar_panel5()
        Panel1.Visible = True
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = True
        actualiza()
    End Sub

    Private Sub actualiza()
        Dim cant1 As Int16
        Dim cant2 As Int16
        Dim cant3 As Int16
        SqlDataSource2.DataBind()
        SqlDataSource3.DataBind()
        SqlDataSource4.DataBind()
        GridView1.DataBind()
        GridView2.DataBind()
        GridView3.DataBind()
        cant1 = GridView1.Rows.Count
        cant2 = GridView2.Rows.Count
        cant3 = GridView3.Rows.Count
        Button1.Text = "Mesas sin Carga (" + cant1.ToString + ")"
        Button2.Text = "Mesas Carga Parcial (" + cant2.ToString + ")"
        Button3.Text = "Mesas Carga Final (" + cant3.ToString + ")"
    End Sub
    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        mostrar_panel2()
    End Sub
    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        mostrar_panel3()

    End Sub
    Protected Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        mostrar_panel5()
    End Sub
End Class
