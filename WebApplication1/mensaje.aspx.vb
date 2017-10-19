
Partial Class mensaje
    Inherits System.Web.UI.Page

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Response.Redirect("Default.aspx")
    End Sub

    Private Sub Label1_Init(sender As Object, e As EventArgs) Handles Label1.Init
        Label1.Text = "Se cargó correctamente la mesa "
        Label2.Text = Session("id_mesa_2").ToString
    End Sub
End Class
