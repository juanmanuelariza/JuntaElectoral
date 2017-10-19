
Imports System.Data

Partial Class mapas_aspx
    Inherits System.Web.UI.Page
    Dim porcentajes As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'ScriptManager.GetCurrent(Page).RegisterPostBackControl(DDL_Departamento)
    End Sub



    Public Function ObtenerDatosDiputados() As String
        Dim tmp_rslt As String = ""
        Dim dt, dt_seccion As DataTable
        Dim StrSQL As String = ""

        StrSQL = "SELECT seccion FROM seccion"
        dt_seccion = GetTableFromSQL(StrSQL, "testReportes")

        StrSQL = "SELECT s.seccion, l.lista, SUM(cant_diputados) as diputados, SUM(cant_senadores) as senadores, SUM(rm.cant_votantes) as cant_votantes FROM mesas m " &
                "INNER JOIN establecimientos e On m.rela_establecimientos = e.id_establecimiento " &
                "INNER JOIN circuitos c on e.rela_circuito = c.id_circuito " &
                "INNER JOIN seccion s On c.rela_seccion = s.id_seccion " &
                "INNER JOIN resultados_mesas rm on m.id_mesa = rela_mesa " &
                "INNER JOIN detalle_resultados dr On rm.id_resultado = rela_resultado " &
                "INNER JOIN listas l on dr.rela_lista = l.id_lista " &
                "group by s.seccion, l.lista order by s.seccion"

        dt = GetTableFromSQL(StrSQL, "testReportes")
        Dim tmp_Todos_Diputados As Integer = 0
        Dim tmp_Todos_Senadores As Integer = 0
        Dim tmp_Cambiemos_Diputados As Integer = 0
        Dim tmp_Cambiemos_Senadores As Integer = 0
        Dim tmp_1Pais_Diputados As Integer = 0
        Dim tmp_1Pais_Senadores As Integer = 0
        Dim tmp_Otros_Diputados As Integer = 0
        Dim tmp_Otros_Senadores As Integer = 0
        Dim tmp_sumaDiputados As Integer = 0
        Dim tmp_totalVotantes As Integer = 0
        For Each dr In dt_seccion.Rows
            tmp_sumaDiputados = 0
            tmp_totalVotantes = 0
            tmp_rslt &= "['" & dr("seccion") & "',"
            For Each drs In dt.Select("seccion = '" & dr("seccion") & "'")
                Select Case drs("lista")
                    Case "San Juan Primero"
                        tmp_Todos_Diputados = drs("diputados")
                    Case "Cambiemos Juntos"
                        tmp_Cambiemos_Diputados = drs("diputados")
                    Case "Lista Renovación"
                        tmp_1Pais_Diputados = drs("diputados")
                    Case Else
                        tmp_Otros_Diputados = drs("diputados")
                End Select
                tmp_sumaDiputados = tmp_sumaDiputados + drs("diputados")
                tmp_totalVotantes = drs("cant_votantes")
            Next
            tmp_Otros_Diputados = tmp_Otros_Diputados + (tmp_totalVotantes - tmp_sumaDiputados)
            tmp_rslt &= tmp_Todos_Diputados & "," & tmp_Cambiemos_Diputados & "," & tmp_1Pais_Diputados & "," & tmp_Otros_Diputados & "," & tmp_totalVotantes & "," & IIf(tmp_Todos_Diputados > tmp_Cambiemos_Diputados, 0, 1) & "],"
        Next
        Return tmp_rslt

    End Function



    Public Function ObtenerDatosSenadores() As String
        Dim tmp_rslt As String = ""
        Dim dt, dt_seccion As DataTable
        Dim StrSQL As String = ""

        StrSQL = "SELECT seccion FROM seccion"
        dt_seccion = GetTableFromSQL(StrSQL, "testReportes")

        StrSQL = "SELECT s.seccion, l.lista, SUM(cant_diputados) as diputados, SUM(cant_senadores) as senadores, SUM(rm.cant_votantes) as cant_votantes FROM mesas m " &
                "INNER JOIN establecimientos e On m.rela_establecimientos = e.id_establecimiento " &
                "INNER JOIN circuitos c on e.rela_circuito = c.id_circuito " &
                "INNER JOIN seccion s On c.rela_seccion = s.id_seccion " &
                "INNER JOIN resultados_mesas rm on m.id_mesa = rela_mesa " &
                "INNER JOIN detalle_resultados dr On rm.id_resultado = rela_resultado " &
                "INNER JOIN listas l on dr.rela_lista = l.id_lista " &
                "group by s.seccion, l.lista order by s.seccion"

        dt = GetTableFromSQL(StrSQL, "testReportes")
        Dim tmp_Todos_Senadores As Integer = 0
        Dim tmp_Cambiemos_Senadores As Integer = 0
        Dim tmp_1Pais_Senadores As Integer = 0
        Dim tmp_Otros_Senadores As Integer = 0
        Dim tmp_sumaSenadores As Integer = 0
        Dim tmp_totalVotantes As Integer = 0
        For Each dr In dt_seccion.Rows
            tmp_sumaSenadores = 0
            tmp_totalVotantes = 0
            tmp_rslt &= "['" & dr("seccion") & "',"
            For Each drs In dt.Select("seccion = '" & dr("seccion") & "'")
                Select Case drs("lista")
                    Case "San Juan Primero"
                        tmp_Todos_Senadores = drs("senadores")
                    Case "Cambiemos Juntos"
                        tmp_Cambiemos_Senadores = drs("senadores")
                    Case "Lista Renovación"
                        tmp_1Pais_Senadores = drs("senadores")
                    Case Else
                        tmp_Otros_Senadores = drs("senadores")
                End Select
                tmp_sumaSenadores = tmp_sumaSenadores + drs("senadores")
                tmp_totalVotantes = drs("cant_votantes")
            Next
            tmp_Otros_Senadores = tmp_Otros_Senadores + (tmp_totalVotantes - tmp_sumaSenadores)
            tmp_rslt &= tmp_Todos_Senadores & "," & tmp_Cambiemos_Senadores & "," & tmp_1Pais_Senadores & "," & tmp_Otros_Senadores & "," & tmp_totalVotantes & "," & IIf(tmp_Todos_Senadores > tmp_Cambiemos_Senadores, 0, 1) & "],"
        Next
        Return tmp_rslt

    End Function
    'Public Function ObtenerDatosSenadores() As String
    '    Dim tmp_rslt As String = ""
    '    Dim dt As DataTable
    '    Dim StrSQL As String = ""
    '    If DDL_Departamento.SelectedValue = 0 Then
    '        StrSQL = "Select listas.lista As Lista, SUM(detalle_resultados_1.cant_senadores) As Senadores, SUM(detalle_resultados_1.cant_diputados) As Diputados, CAST(SUM(detalle_resultados_1.cant_senadores) As float) / CAST((Select SUM(cant_votantes) As total " &
    '                            "FROM resultados_mesas WHERE (id_resultado In (Select rela_resultado FROM detalle_resultados WHERE (cant_diputados > 0) Or (cant_senadores > 0) GROUP BY rela_resultado))) As float) * 100 As [PorcentajeSenadores], CAST(SUM(detalle_resultados_1.cant_diputados) As float) / CAST((Select SUM(cant_votantes) As total FROM resultados_mesas As resultados_mesas_2 WHERE (id_resultado In (Select rela_resultado FROM detalle_resultados As detalle_resultados_2 WHERE (cant_diputados > 0) Or (cant_senadores > 0) GROUP BY rela_resultado))) As float) * 100 As [PorcentajeDiputados] FROM resultados_mesas As resultados_mesas_1 INNER JOIN detalle_resultados As detalle_resultados_1 On resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas On detalle_resultados_1.rela_lista = listas.id_lista GROUP BY listas.lista, listas.id_lista ORDER BY listas.id_lista"
    '    Else
    '        StrSQL = "Select listas.lista As Lista, SUM(detalle_resultados_1.cant_senadores) As Senadores, " &
    '                    "SUM(detalle_resultados_1.cant_diputados) As Diputados, " &
    '                    "CAST(SUM(detalle_resultados_1.cant_senadores) As float) / CAST((Select SUM(cant_votantes) As total " &
    '                    "FROM resultados_mesas WHERE " &
    '                    "(id_resultado In (Select detalle_resultados.rela_resultado FROM detalle_resultados " &
    '                    "INNER JOIN resultados_mesas As resultados_mesas_3 On detalle_resultados.rela_resultado = resultados_mesas_3.id_resultado " &
    '                    "INNER JOIN mesas On resultados_mesas_3.rela_mesa = mesas.id_mesa " &
    '                    "INNER JOIN establecimientos On mesas.rela_establecimientos = establecimientos.id_establecimiento " &
    '                    "INNER JOIN circuitos On establecimientos.rela_circuito = circuitos.id_circuito " &
    '                    "WHERE (detalle_resultados.cant_diputados > 0) Or (detalle_resultados.cant_senadores > 0) " &
    '                    "GROUP BY detalle_resultados.rela_resultado, circuitos.rela_seccion " &
    '                    "HAVING (circuitos.rela_seccion = " & DDL_Departamento.SelectedValue & ")))) As float) * 100 As [PorcentajeSenadores], " &
    '                    "CAST(SUM(detalle_resultados_1.cant_diputados) As float) / CAST((Select SUM(cant_votantes) As total " &
    '                    "FROM resultados_mesas As resultados_mesas_2 " &
    '                    "WHERE (id_resultado In (Select detalle_resultados_2.rela_resultado " &
    '                    "FROM detalle_resultados As detalle_resultados_2 " &
    '                    "INNER JOIN resultados_mesas As resultados_mesas_3 On detalle_resultados_2.rela_resultado = resultados_mesas_3.id_resultado " &
    '                    "INNER JOIN mesas As mesas_2 On resultados_mesas_3.rela_mesa = mesas_2.id_mesa " &
    '                    "INNER JOIN establecimientos As establecimientos_2 On mesas_2.rela_establecimientos = establecimientos_2.id_establecimiento " &
    '                    "INNER JOIN circuitos As circuitos_2 On establecimientos_2.rela_circuito = circuitos_2.id_circuito " &
    '                    "WHERE (detalle_resultados_2.cant_diputados > 0) Or (detalle_resultados_2.cant_senadores > 0) " &
    '                    "GROUP BY detalle_resultados_2.rela_resultado, circuitos_2.rela_seccion " &
    '                    "HAVING (circuitos_2.rela_seccion = " & DDL_Departamento.SelectedValue & ")))) As float) * 100 As [PorcentajeDiputados] FROM resultados_mesas As resultados_mesas_1 INNER JOIN detalle_resultados As detalle_resultados_1 On resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas On detalle_resultados_1.rela_lista = listas.id_lista INNER JOIN mesas As mesas_1 On resultados_mesas_1.rela_mesa = mesas_1.id_mesa INNER JOIN establecimientos As establecimientos_1 On mesas_1.rela_establecimientos = establecimientos_1.id_establecimiento INNER JOIN circuitos As circuitos_1 On establecimientos_1.rela_circuito = circuitos_1.id_circuito INNER JOIN seccion On circuitos_1.rela_seccion = seccion.id_seccion GROUP BY listas.lista, listas.id_lista, seccion.id_seccion HAVING (seccion.id_seccion = " & DDL_Departamento.SelectedValue & ") " &
    '                    "ORDER BY listas.id_lista"
    '    End If
    '    dt = GetTableFromSQL(StrSQL)
    '    Dim tmp_index As Integer = 1
    '    Dim tmp_SumSenadores As Double = 0
    '    'tmp_rslt &= """["
    '    For Each dr In dt.Rows
    '        tmp_rslt &= "{name: '" & dr("Lista") & "', y: " & Convert.ToDouble(dr("PorcentajeSenadores")).ToString("F2").Replace(",", ".") & "}," '& IIf(dt.Rows.Count > tmp_index, ",", "")
    '        tmp_SumSenadores = tmp_SumSenadores + Convert.ToDouble(dr("PorcentajeSenadores"))
    '        tmp_index = tmp_index + 1
    '    Next
    '    'tmp_rslt &= "]"""

    '    tmp_rslt &= "{name: 'Otros', y: " & (100 - tmp_SumSenadores).ToString("F2").Replace(",", ".") & "}"
    '    Return tmp_rslt
    'End Function

    'Public Function ObtenerDatosDiputados() As String
    '    Dim tmp_rslt As String = ""
    '    Dim dt As DataTable
    '    Dim StrSQL As String = ""
    '    If DDL_Departamento.SelectedValue = 0 Then
    '        StrSQL = "SELECT listas.lista AS Lista, SUM(detalle_resultados_1.cant_senadores) AS Senadores, SUM(detalle_resultados_1.cant_diputados) AS Diputados, CAST(SUM(detalle_resultados_1.cant_senadores) AS float) / CAST((SELECT SUM(cant_votantes) AS total " &
    '                            "FROM resultados_mesas WHERE (id_resultado IN (SELECT rela_resultado FROM detalle_resultados WHERE (cant_diputados > 0) OR (cant_senadores > 0) GROUP BY rela_resultado))) AS float) * 100 AS [PorcentajeSenadores], CAST(SUM(detalle_resultados_1.cant_diputados) AS float) / CAST((SELECT SUM(cant_votantes) AS total FROM resultados_mesas AS resultados_mesas_2 WHERE (id_resultado IN (SELECT rela_resultado FROM detalle_resultados AS detalle_resultados_2 WHERE (cant_diputados > 0) OR (cant_senadores > 0) GROUP BY rela_resultado))) AS float) * 100 AS [PorcentajeDiputados] FROM resultados_mesas AS resultados_mesas_1 INNER JOIN detalle_resultados AS detalle_resultados_1 ON resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas ON detalle_resultados_1.rela_lista = listas.id_lista GROUP BY listas.lista, listas.id_lista ORDER BY listas.id_lista"
    '    Else
    '        StrSQL = "SELECT listas.lista AS Lista, SUM(detalle_resultados_1.cant_senadores) AS Senadores, " &
    '                    "SUM(detalle_resultados_1.cant_diputados) As Diputados, " &
    '                    "CAST(SUM(detalle_resultados_1.cant_senadores) As float) / CAST((Select SUM(cant_votantes) As total " &
    '                    "FROM resultados_mesas WHERE " &
    '                    "(id_resultado In (Select detalle_resultados.rela_resultado FROM detalle_resultados " &
    '                    "INNER JOIN resultados_mesas As resultados_mesas_3 On detalle_resultados.rela_resultado = resultados_mesas_3.id_resultado " &
    '                    "INNER JOIN mesas On resultados_mesas_3.rela_mesa = mesas.id_mesa " &
    '                    "INNER JOIN establecimientos On mesas.rela_establecimientos = establecimientos.id_establecimiento " &
    '                    "INNER JOIN circuitos On establecimientos.rela_circuito = circuitos.id_circuito " &
    '                    "WHERE (detalle_resultados.cant_diputados > 0) Or (detalle_resultados.cant_senadores > 0) " &
    '                    "GROUP BY detalle_resultados.rela_resultado, circuitos.rela_seccion " &
    '                    "HAVING (circuitos.rela_seccion = " & DDL_Departamento.SelectedValue & ")))) As float) * 100 As [PorcentajeSenadores], " &
    '                    "CAST(SUM(detalle_resultados_1.cant_diputados) As float) / CAST((Select SUM(cant_votantes) As total " &
    '                    "FROM resultados_mesas As resultados_mesas_2 " &
    '                    "WHERE (id_resultado In (Select detalle_resultados_2.rela_resultado " &
    '                    "FROM detalle_resultados As detalle_resultados_2 " &
    '                    "INNER JOIN resultados_mesas As resultados_mesas_3 On detalle_resultados_2.rela_resultado = resultados_mesas_3.id_resultado " &
    '                    "INNER JOIN mesas As mesas_2 On resultados_mesas_3.rela_mesa = mesas_2.id_mesa " &
    '                    "INNER JOIN establecimientos As establecimientos_2 On mesas_2.rela_establecimientos = establecimientos_2.id_establecimiento " &
    '                    "INNER JOIN circuitos As circuitos_2 On establecimientos_2.rela_circuito = circuitos_2.id_circuito " &
    '                    "WHERE (detalle_resultados_2.cant_diputados > 0) Or (detalle_resultados_2.cant_senadores > 0) " &
    '                    "GROUP BY detalle_resultados_2.rela_resultado, circuitos_2.rela_seccion " &
    '                    "HAVING (circuitos_2.rela_seccion = " & DDL_Departamento.SelectedValue & ")))) As float) * 100 As [PorcentajeDiputados] FROM resultados_mesas As resultados_mesas_1 INNER JOIN detalle_resultados As detalle_resultados_1 On resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas On detalle_resultados_1.rela_lista = listas.id_lista INNER JOIN mesas As mesas_1 On resultados_mesas_1.rela_mesa = mesas_1.id_mesa INNER JOIN establecimientos As establecimientos_1 On mesas_1.rela_establecimientos = establecimientos_1.id_establecimiento INNER JOIN circuitos As circuitos_1 On establecimientos_1.rela_circuito = circuitos_1.id_circuito INNER JOIN seccion On circuitos_1.rela_seccion = seccion.id_seccion GROUP BY listas.lista, listas.id_lista, seccion.id_seccion HAVING (seccion.id_seccion = " & DDL_Departamento.SelectedValue & ") " &
    '                    "ORDER BY listas.id_lista"
    '    End If
    '    dt = GetTableFromSQL(StrSQL)
    '    Dim tmp_index As Integer = 1
    '    Dim tmp_SumSenadores As Double = 0
    '    'tmp_rslt &= """["
    '    For Each dr In dt.Rows
    '        tmp_rslt &= "{name: '" & dr("Lista") & "', y: " & Convert.ToDouble(dr("PorcentajeDiputados")).ToString("F2").Replace(",", ".") & "}," '& IIf(dt.Rows.Count > tmp_index, ",", "")
    '        tmp_SumSenadores = tmp_SumSenadores + Convert.ToDouble(dr("PorcentajeDiputados"))
    '        tmp_index = tmp_index + 1
    '    Next
    '    'tmp_rslt &= "]"""

    '    tmp_rslt &= "{name: 'Otros', y: " & (100 - tmp_SumSenadores).ToString("F2").Replace(",", ".") & "}"
    '    Return tmp_rslt
    'End Function

    Public Function GetTableFromSQL(ByVal ArgSQL As String, Optional ByVal ArgConecctionString As String = "") As System.Data.DataTable
        Dim DataConnection As New SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings(IIf(ArgConecctionString = "", "modod_eleccion", ArgConecctionString)).ConnectionString)
        Dim DataCommand = BuildDataCommand(ArgSQL, DataConnection)
        Dim DataReader As SqlClient.SqlDataReader

        Dim tmp_DataRow As System.Data.DataRow
        Dim tmp_DataTable As New System.Data.DataTable()
        Dim tmp_Indx As Integer

        DataConnection.Open()
        DataReader = DataCommand.ExecuteReader(CommandBehavior.CloseConnection)
        For tmp_Indx = 0 To DataReader.FieldCount - 1
            tmp_DataTable.Columns.Add(DataReader.GetName(tmp_Indx), DataReader.GetFieldType(tmp_Indx))
        Next
        While DataReader.Read()
            tmp_DataRow = tmp_DataTable.NewRow()
            For tmp_Indx = 0 To DataReader.FieldCount - 1
                If Not DataReader.IsDBNull(tmp_Indx) Then
                    tmp_DataRow(tmp_Indx) = DataReader.GetValue(tmp_Indx)
                End If
            Next
            tmp_DataTable.Rows.Add(tmp_DataRow)
        End While
        DataReader.Close()
        DataCommand.Dispose()
        DataConnection.Close()
        Return tmp_DataTable
    End Function 'GetTableFromSQL

    Public Function BuildDataCommand(ByVal ArgSQL As String, ByVal DataConnection As Object) As SqlClient.SqlCommand
        Dim DataCommand As New SqlClient.SqlCommand(SecureSqlString(ArgSQL), DataConnection)
        Return DataCommand
    End Function 'BuildDataCommand

    Public Function SecureSqlString(ByVal ArgSqlString As String) As String
        Dim tmp_rslt As String = ArgSqlString
        'las comillas
        tmp_rslt.Replace("'", "''")
        'los comodines de like
        tmp_rslt.Replace("[", "[[]")
        tmp_rslt.Replace("%", "[%]")
        tmp_rslt.Replace("_", "[_]")
        'nada de exec
        Return tmp_rslt
    End Function 'SecureSqlString

    Public Function GetAppSetting(ByVal ArgSettingName As String) As String
        Dim tmp_rslt As String = ""
        Dim tmp_Section As System.Collections.Specialized.NameValueCollection
        tmp_Section = System.Configuration.ConfigurationManager.GetSection("appSettings")
        If Not tmp_Section Is Nothing Then
            If Not tmp_Section(ArgSettingName) Is Nothing Then
                tmp_rslt = tmp_Section(ArgSettingName)
            End If
        End If
        Return tmp_rslt
    End Function 'GetAppSetting
End Class
