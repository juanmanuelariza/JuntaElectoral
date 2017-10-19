
Partial Class resultados_aspx
    Inherits System.Web.UI.Page

    Private Sub mostrar_panel1()
        Panel1.Visible = True
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = False
    End Sub
    Private Sub mostrar_panel2()
        Panel1.Visible = False
        Panel2.Visible = True
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = False
    End Sub
    Private Sub mostrar_panel3()
        Panel1.Visible = False
        Panel2.Visible = False
        Panel3.Visible = True
        Panel4.Visible = False
        Panel5.Visible = False
    End Sub
    Private Sub mostrar_panel4()
        Panel1.Visible = False
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = True
        Panel5.Visible = False
    End Sub

    Private Sub mostrar_panl5()
        Panel1.Visible = False
        Panel2.Visible = False
        Panel3.Visible = False
        Panel4.Visible = False
        Panel5.Visible = True
    End Sub

    Private Sub resultados_aspx_Init(sender As Object, e As EventArgs) Handles Me.Init
        mostrar_panel1()
        SqlDataSource1.DataBind()
        DropDownList1.DataBind()
        If Session("rol_usuario") = 1 Or Session("rol_usuario") = 5 Then 'es general
            DropDownList1.Enabled = True
        ElseIf Session("rol_usuario") = 3 Then 'es departamento
            DropDownList1.Enabled = False
            SqlDataSource8.DataBind()
            DropDownList4.DataBind()
            If DropDownList4.Items.Count > 0 Then
                Session("id_dep") = DropDownList4.SelectedValue
                DropDownList1.SelectedIndex = DropDownList1.Items.IndexOf(DropDownList1.Items.FindByValue(DropDownList4.SelectedValue.ToString))
            End If
        Else   'es otro nivel
            Response.Redirect("Default.aspx")
        End If
        Label1.Text = Now.Hour.ToString + ":" + Now.Minute.ToString.ToString
        recarga()
    End Sub

    Private Sub recarga()
        Dim i As Int16
        Label1.Text = Now.Hour.ToString + ":" + Now.Minute.ToString.ToString
        If DropDownList1.SelectedValue = 0 Then 'calcula  para todos
            GridView1.DataSourceID = SqlDataSource4.ID
            SqlDataSource4.DataBind()
            GridView1.DataBind()
            DropDownList2.DataSourceID = SqlDataSource2.ID
            SqlDataSource2.DataBind()
            DropDownList2.DataBind()
            DropDownList3.DataSourceID = SqlDataSource3.ID
            SqlDataSource3.DataBind()
            DropDownList3.DataBind()
            DropDownList5.DataSourceID = SqlDataSource14.ID
            SqlDataSource14.DataBind()
            DropDownList5.DataBind()
            Session("cant_mesas") = DropDownList2.SelectedValue
            If DropDownList3.Items.Count > 0 Then
                Session("cant_cargadas") = DropDownList3.Items.Count
            Else
                Session("cant_cargadas") = 0
            End If
            Session("porcentajes_cargadas") = Convert.ToInt16(Session("cant_cargadas")) * 100 / Convert.ToInt16(Session("cant_mesas"))
            Label2.Text = "Cantidad de Mesas: " + Session("cant_mesas").ToString
            Label3.Text = "Cantidad Cargadas:  " + Session("cant_cargadas").ToString
            Label4.Text = "Porcentaje Mesas Escrutadas: " + Convert.ToSingle(Session("porcentajes_cargadas")).ToString + " %"
            If DropDownList5.Items.Count > 0 Then
                Label5.Text = "Cantidad Votantes: " + DropDownList5.SelectedValue.ToString
            Else
                Label5.Text = "Cantidad Votantes: 0"
            End If
            For i = 0 To GridView1.Rows.Count - 1
                'GridView1.Rows(i).Cells(3).Text = 1
                'GridView1.Rows(i).Cells(3).Text = Convert.ToInt16(GridView1.Rows(i).Cells(1)) * 100 / Convert.ToInt16(DropDownList5.SelectedValue)
            Next
        Else    'calcula para departamentos
            GridView1.DataSourceID = SqlDataSource5.ID
            SqlDataSource5.DataBind()
            GridView1.DataBind()
            DropDownList2.DataSourceID = SqlDataSource6.ID
            SqlDataSource6.DataBind()
            DropDownList2.DataBind()
            DropDownList3.DataSourceID = SqlDataSource7.ID
            SqlDataSource7.DataBind()
            DropDownList3.DataBind()
            DropDownList5.DataSourceID = SqlDataSource15.ID
            SqlDataSource15.DataBind()
            DropDownList5.DataBind()
            Session("cant_mesas") = DropDownList2.SelectedValue
            If DropDownList3.Items.Count > 0 Then
                Session("cant_cargadas") = DropDownList3.Items.Count
            Else
                Session("cant_cargadas") = 0
            End If
            Session("porcentajes_cargadas") = Convert.ToInt16(Session("cant_cargadas")) * 100 / Convert.ToInt16(Session("cant_mesas"))
            Label2.Text = "Cantidad de Mesas: " + Session("cant_mesas").ToString
            Label3.Text = "Cantidad Cargadas:  " + Session("cant_cargadas").ToString
            Label4.Text = "Porcentaje Mesas Escrutadas: " + Convert.ToSingle(Session("porcentajes_cargadas")).ToString + " %"
            If DropDownList5.Items.Count > 0 Then
                Label5.Text = "Cantidad Votantes: " + DropDownList5.SelectedValue.ToString
            Else
                Label5.Text = "Cantidad Votantes: 0"
            End If
        End If
    End Sub
    Protected Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        recarga()
    End Sub

    Protected Sub DropDownList1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList1.SelectedIndexChanged
        recarga()
    End Sub

End Class
