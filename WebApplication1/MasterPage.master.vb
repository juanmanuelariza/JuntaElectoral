
Partial Class MasterPage
    Inherits System.Web.UI.MasterPage

    Private Sub MasterPage_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("activa") <> 1 Then
            Dim Script As String
            Response.Redirect("login.aspx")
            Script = "<script type='text/javascript'>" & vbCr & vbLf & "alert('No se ha iniciado sesión');" & vbCr & vbLf & "                        </script>"
            'End If
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "alerta", Script, False)
        End If
    End Sub
End Class

