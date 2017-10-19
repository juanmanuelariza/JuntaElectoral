
Partial Class faltantes
    Inherits System.Web.UI.Page

    Private Sub faltantes_Init(sender As Object, e As EventArgs) Handles Me.Init
        mostrar_panel1()
        SqlDataSource11.DataBind()
        DropDownList4.DataBind()
        Dim r As Single
        r = (Convert.ToInt32(DropDownList4.SelectedValue) * 100 / 554528)
        Label2.Text = "Porcentaje Votado: " + r.ToString
        If Session("rol_usuario") = 1 Or Session("rol_usuario") = 5 Then 'es general

        Else   'es otro nivel
            Response.Redirect("Default.aspx")
        End If

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
        GridView1.DataSourceID = SqlDataSource2.ID
        GridView2.DataSourceID = SqlDataSource3.ID
        GridView3.DataSourceID = SqlDataSource4.ID
        SqlDataSource2.DataBind()
        SqlDataSource3.DataBind()
        SqlDataSource4.DataBind()
        GridView1.DataBind()
        GridView2.DataBind()
        GridView3.DataBind()
        SqlDataSource5.DataBind()
        DropDownList1.DataBind()
        DropDownList2.DataBind()
        DropDownList3.DataBind()
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
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

    End Sub
    Protected Sub DropDownList1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList1.SelectedIndexChanged
        If DropDownList1.SelectedValue = 0 Then
            GridView1.DataSourceID = SqlDataSource2.ID
        Else
            GridView1.DataSourceID = SqlDataSource6.ID
        End If
        SqlDataSource2.DataBind()
        SqlDataSource6.DataBind()
        GridView1.DataBind()
    End Sub
    Protected Sub DropDownList2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList2.SelectedIndexChanged
        If DropDownList2.SelectedValue = 0 Then
            GridView2.DataSourceID = SqlDataSource3.ID
        Else
            GridView2.DataSourceID = SqlDataSource7.ID
        End If
        SqlDataSource3.DataBind()
        SqlDataSource7.DataBind()
        GridView2.DataBind()
    End Sub
    Protected Sub DropDownList3_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList3.SelectedIndexChanged
        If DropDownList3.SelectedValue = 0 Then
            GridView3.DataSourceID = SqlDataSource4.ID
        Else
            GridView3.DataSourceID = SqlDataSource8.ID
        End If
        SqlDataSource4.DataBind()
        SqlDataSource8.DataBind()
        GridView3.DataBind()
    End Sub
    Protected Sub DropDownList4_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList4.SelectedIndexChanged

    End Sub
End Class
