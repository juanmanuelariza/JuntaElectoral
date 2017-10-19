
Partial Class login
    Inherits System.Web.UI.Page

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        auntentica()
    End Sub

    Private Sub login_Init(sender As Object, e As EventArgs) Handles Me.Init
        TextBox2.Focus()
    End Sub

    Private Sub auntentica()
        If TextBox2.Text = "" Then
            TextBox2.Focus()
            Label3.Text = "Completar contraseña"
        Else
            SqlDataSource1.DataBind()
            GridView1.DataBind()
            If GridView1.Rows.Count > 0 Then
                Session("id_usuario") = GridView1.Rows(0).Cells(0).Text
                Session("rol_usuario") = GridView1.Rows(0).Cells(1).Text
                Session("descrip_usuario") = GridView1.Rows(0).Cells(2).Text
                Session("activa") = 1
                'If Session("rol_usuario") = 5 Then
                '    Response.Redirect("resultados.aspx")
                'Else
                '    Response.Redirect("Default.aspx")
                'End If
                Response.Redirect("/reportes/tablero.aspx")
            Else
                Label3.Text = "Error de autentificación"
            End If
        End If
    End Sub

    Protected Sub TextBox2_TextChanged(sender As Object, e As EventArgs) Handles TextBox2.TextChanged
        auntentica()
    End Sub
End Class
