
Imports System.Data
Imports System.IO

Partial Class municipios_aspx
    Inherits System.Web.UI.Page
    Dim dtMesas, dtMesasFaltantes As DataTable
    Dim dtMesasEscrutadasCapital, dtMesasFaltantesCapital, dtTotalesCapital As DataTable
    Dim dtMesasEscrutadasRivadiva, dtMesasFaltantesRivadiva, dtTotalesRivadiva As DataTable
    Dim dtMesasEscrutadasSantaLucia, dtMesasFaltantesSantaLucia, dtTotalesSantaLucia As DataTable

    Dim ListaMesas As New List(Of String)()
    Dim ListaMesasCapital As New List(Of String)()
    Dim ListaMesasRivadiva As New List(Of String)()
    Dim ListaMesasSantaLucia As New List(Of String)()

    Public tmp_TotalMesasCapital As String
    Public tmp_TotalMesasRivadiva As String
    Public tmp_TotalMesasSantaLucia As String
    Public tmp_MesasEscrutadasCapital As String
    Public tmp_MesasEscrutadasRivadiva As String
    Public tmp_MesasEscrutadasSantaLucia As String
    Public tmp_TablaMesasFaltantes As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim StrSQL As String = ""

        'Mesas
        StrSQL = "SELECT m.numero_mesa, mm.color, rela_seccion FROM muestras_municipios mm " &
            "INNER JOIN mesas m On m.numero_mesa = mm.numero_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito"
        dtMesas = GetTableFromSQL(StrSQL)
        For Each drMesa In dtMesas.Rows
            Select Case drMesa("rela_seccion")
                Case 6 'Capital
                    ListaMesasCapital.Add(drMesa("numero_mesa"))
                Case 13 'Rivadavia
                    ListaMesasRivadiva.Add(drMesa("numero_mesa"))
                Case 15 'Santa Lucia
                    ListaMesasSantaLucia.Add(drMesa("numero_mesa"))
            End Select
            ListaMesas.Add(drMesa("numero_mesa"))
        Next

        'Totales Diputados y Senadores
        'Capital
        StrSQL = "Select l.lista As Lista, SUM(rm.cant_votantes) As total, SUM(dr.cant_senadores) As Senadores, SUM(dr.cant_diputados) As Diputados, " &
        "CAST(SUM(dr.cant_senadores)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeSenadores, " &
        "CAST(SUM(dr.cant_diputados)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeDiputados " &
        "From mesas m INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
        "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
        "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito " &
        "INNER JOIN detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
        "INNER JOIN listas l On dr.rela_lista = l.id_lista " &
        "WHERE m.numero_mesa In (" & String.Join(",", ListaMesasCapital) & ")"
        StrSQL &= " Group by l.lista, l.id_lista order by l.id_lista"
        dtTotalesCapital = GetTableFromSQL(StrSQL)

        'Rivadavia
        StrSQL = "Select l.lista As Lista, SUM(rm.cant_votantes) As total, SUM(dr.cant_senadores) As Senadores, SUM(dr.cant_diputados) As Diputados, " &
        "CAST(SUM(dr.cant_senadores)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeSenadores, " &
        "CAST(SUM(dr.cant_diputados)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeDiputados " &
        "From mesas m INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
        "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
        "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito " &
        "INNER JOIN detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
        "INNER JOIN listas l On dr.rela_lista = l.id_lista " &
        "WHERE m.numero_mesa In (" & String.Join(",", ListaMesasRivadiva) & ")"
        StrSQL &= " Group by l.lista, l.id_lista order by l.id_lista"
        dtTotalesRivadiva = GetTableFromSQL(StrSQL)

        'Santa Lucia
        StrSQL = "Select l.lista As Lista, SUM(rm.cant_votantes) As total, SUM(dr.cant_senadores) As Senadores, SUM(dr.cant_diputados) As Diputados, " &
        "CAST(SUM(dr.cant_senadores)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeSenadores, " &
        "CAST(SUM(dr.cant_diputados)As float)*100/CAST(SUM(rm.cant_votantes) As float) As PorcentajeDiputados " &
        "From mesas m INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
        "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
        "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito " &
        "INNER JOIN detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
        "INNER JOIN listas l On dr.rela_lista = l.id_lista " &
        "WHERE m.numero_mesa In (" & String.Join(",", ListaMesasSantaLucia) & ")"
        StrSQL &= " Group by l.lista, l.id_lista order by l.id_lista"
        dtTotalesSantaLucia = GetTableFromSQL(StrSQL)

        'Mesas Escrutadas
        'Capital
        StrSQL = "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) " &
            "And rm.rela_mesa In (" & String.Join(",", ListaMesasCapital) & ")"
        dtMesasEscrutadasCapital = GetTableFromSQL(StrSQL)

        'Rivadavia
        StrSQL = "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) " &
            "And rm.rela_mesa In (" & String.Join(",", ListaMesasRivadiva) & ")"
        dtMesasEscrutadasRivadiva = GetTableFromSQL(StrSQL)

        'Santa Lucia
        StrSQL = "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) " &
            "And rm.rela_mesa In (" & String.Join(",", ListaMesasSantaLucia) & ")"
        dtMesasEscrutadasSantaLucia = GetTableFromSQL(StrSQL)

        'Mesas Faltantes
        StrSQL = "Select m.numero_mesa, mp.color, e.establecimiento, c.circuito_nombre, s.seccion from muestras_municipios mp " &
            "INNER JOIN mesas m On m.numero_mesa = mp.numero_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "INNER JOIN seccion s On s.id_seccion = c.rela_seccion " &
            "where m.numero_mesa Not In ( " &
            "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) " &
            " And rm.rela_mesa In (" & String.Join(", ", ListaMesas) & "))"

        dtMesasFaltantes = GetTableFromSQL(StrSQL)


        tmp_TotalMesasCapital = ListaMesasCapital.Count
        tmp_TotalMesasRivadiva = ListaMesasRivadiva.Count
        tmp_TotalMesasSantaLucia = ListaMesasSantaLucia.Count
        tmp_MesasEscrutadasCapital = dtMesasEscrutadasCapital.Rows.Count
        tmp_MesasEscrutadasRivadiva = dtMesasEscrutadasRivadiva.Rows.Count
        tmp_MesasEscrutadasSantaLucia = dtMesasEscrutadasSantaLucia.Rows.Count

        tmp_TablaMesasFaltantes &= "<tbody>"
        For Each dr In dtMesasFaltantes.Rows
            tmp_TablaMesasFaltantes &= "<tr>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("numero_mesa")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("color")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("seccion")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("circuito_nombre")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("establecimiento")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "</tr>"
        Next
        tmp_TablaMesasFaltantes &= "</tbody>"


    End Sub


    Public Function ObtenerDatosSenadores(ByVal ArgMunicipio As Integer) As String
        Dim tmp_rslt As String = ""
        Dim tmp_SumSenadores As Double = 0
        Dim tmp_SumVotosSenadores As Double = 0
        Dim dtTotales As DataTable

        Select Case ArgMunicipio
            Case 6 'Capital
                dtTotales = dtTotalesCapital
            Case 13 'Rivadavia
                dtTotales = dtTotalesRivadiva
            Case 15 'Santa Lucia
                dtTotales = dtTotalesSantaLucia
        End Select

        'tmp_rslt &= """["
        For Each dr In dtTotales.Rows
            tmp_rslt &= "{name: '" & dr("Lista") & "'" &
                        ", x: " & Convert.ToDouble(dr("Senadores")).ToString() &
                        ", y: " & Convert.ToDouble(dr("PorcentajeSenadores")).ToString("F2").Replace(",", ".") &
                        ", color: '" & getColor(dr("Lista")) & "'},"

            '& IIf(dt.Rows.Count > tmp_index, ",", "")
            tmp_SumSenadores = tmp_SumSenadores + Convert.ToDouble(dr("PorcentajeSenadores"))
            tmp_SumVotosSenadores = tmp_SumVotosSenadores + Convert.ToDouble(dr("Senadores"))
        Next
        'tmp_rslt &= "]"""

        tmp_rslt &= "{name: 'Otros', x: " & dtTotales.Rows(0)("total") - tmp_SumVotosSenadores & ", y: " & (100 - tmp_SumSenadores).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        Return tmp_rslt
    End Function

    Public Function ObtenerDatosDiputados(ByVal ArgMunicipio As Integer) As String
        Dim tmp_rslt As String = ""
        Dim tmp_index As Integer = 1
        Dim tmp_SumDiputados As Double = 0
        Dim tmp_SumVotosDiputados As Double = 0
        Dim dtTotales As DataTable

        Select Case ArgMunicipio
            Case 6 'Capital
                dtTotales = dtTotalesCapital
            Case 13 'Rivadavia
                dtTotales = dtTotalesRivadiva
            Case 15 'Santa Lucia
                dtTotales = dtTotalesSantaLucia
        End Select

        'tmp_rslt &= """["
        For Each dr In dtTotales.Rows
            tmp_rslt &= "{name: '" & dr("Lista") & "'" &
                        ", x: " & Convert.ToDouble(dr("Diputados")).ToString() &
                        ", y: " & Convert.ToDouble(dr("PorcentajeDiputados")).ToString("F2").Replace(",", ".") &
                        ", color: '" & getColor(dr("Lista")) & "'},"
            tmp_SumDiputados = tmp_SumDiputados + Convert.ToDouble(dr("PorcentajeDiputados"))
            tmp_SumVotosDiputados = tmp_SumVotosDiputados + Convert.ToDouble(dr("Diputados"))
            tmp_index = tmp_index + 1
        Next
        'tmp_rslt &= "]"""

        tmp_rslt &= "{name: 'Otros', x: " & dtTotales.Rows(0)("total") - tmp_SumVotosDiputados & ", y: " & (100 - tmp_SumDiputados).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        Return tmp_rslt
    End Function

    Function PorcentajeDeMesaEscrutadas(ByVal ArgMunicipio As Integer) As Integer
        Dim tmp_rslt As Integer
        Select Case ArgMunicipio
            Case 6 'Capital
                tmp_rslt = tmp_MesasEscrutadasCapital * 100 / tmp_TotalMesasCapital
            Case 13 'Rivadavia
                tmp_rslt = tmp_MesasEscrutadasRivadiva * 100 / tmp_TotalMesasRivadiva
            Case 15 'Santa Lucia
                tmp_rslt = tmp_MesasEscrutadasSantaLucia * 100 / tmp_TotalMesasSantaLucia
        End Select

        Return tmp_rslt
    End Function

    Function getColor(ArgLista As String) As String
        Select Case ArgLista
            Case "San Juan Primero"
                Return "#1876cc"
            Case "Frente Todos"
                Return "#1876cc"
            Case "Cambiemos Juntos"
                Return "#eeff00"
            Case "Cambiemos"
                Return "#eeff00"
            Case "Lista Renovación"
                Return "#eeff00"
            Case "Somos San Juan"
                Return "#78288c"
            Case "1Pais"
                Return "#78288c"
            Case Else
                Return "#cecece"
        End Select
    End Function

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
