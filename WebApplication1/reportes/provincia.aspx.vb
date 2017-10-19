
Imports System.Data
Imports System.IO

Partial Class provincia_aspx
    Inherits System.Web.UI.Page

    Dim dtMesasProvincia, dtMesasEscrutadasProvincia, dtMesasFaltantesProvincia, dtTotalesProvincia As DataTable
    Dim dtMesasMunicipios, dtTotalesMunicipios As DataTable
    Dim ListaMesasProvincia As New List(Of String)()
    'Dim ListaMesasMunicipios As New List(Of String)()

    Public tmp_TotalMesas As String
    Public tmp_MesasEscrutadas As String
    Public tmp_TablaMesasFaltantes As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim StrSQL As String = ""

        'Mesas Provincia
        StrSQL = "SELECT * FROM muestras_provincia"
        dtMesasProvincia = GetTableFromSQL(StrSQL)
        For Each drMesa In dtMesasProvincia.Rows
            ListaMesasProvincia.Add(drMesa("numero_mesa"))
        Next

        'Totales Diputados y Senadores
        StrSQL = "Select l.lista as Lista, SUM(rm.cant_votantes) as total, SUM(dr.cant_senadores) as Senadores, SUM(dr.cant_diputados) as Diputados, " &
        "CAST(SUM(dr.cant_senadores)as float)*100/CAST(SUM(rm.cant_votantes) AS float) as PorcentajeSenadores, " &
        "CAST(SUM(dr.cant_diputados)as float)*100/CAST(SUM(rm.cant_votantes) AS float) as PorcentajeDiputados " &
        "From mesas m INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
        "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
        "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito " &
        "INNER JOIN detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
        "INNER JOIN listas l ON dr.rela_lista = l.id_lista " &
        "WHERE m.numero_mesa in (" & String.Join(",", ListaMesasProvincia) & ")"
        StrSQL &= " Group by l.lista, l.id_lista order by l.id_lista"
        dtTotalesProvincia = GetTableFromSQL(StrSQL)

        'Mesas Escrutadas
        StrSQL = "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) " &
            "AND rm.rela_mesa in (" & String.Join(",", ListaMesasProvincia) & ")"
        dtMesasEscrutadasProvincia = GetTableFromSQL(StrSQL)

        'Mesas Faltantes
        StrSQL = "select m.numero_mesa, mp.estrato,e.establecimiento, c.circuito_nombre, s.seccion from muestras_provincia mp " &
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
            " And rm.rela_mesa In (" & String.Join(", ", ListaMesasProvincia) & "))"

        dtMesasFaltantesProvincia = GetTableFromSQL(StrSQL)


        tmp_TotalMesas = dtMesasProvincia.Rows.Count
        tmp_MesasEscrutadas = dtMesasEscrutadasProvincia.Rows.Count

        tmp_TablaMesasFaltantes &= "<tbody>"
        For Each dr In dtMesasFaltantesProvincia.Rows
            tmp_TablaMesasFaltantes &= "<tr>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("numero_mesa")
            tmp_TablaMesasFaltantes &= "</td>"
            tmp_TablaMesasFaltantes &= "<td>"
            tmp_TablaMesasFaltantes &= dr("estrato")
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


    Public Function ObtenerDatosSenadores() As String
        Dim tmp_rslt As String = ""
        Dim tmp_SumSenadores As Double = 0
        Dim tmp_SumVotosSenadores As Double = 0
        'tmp_rslt &= """["
        For Each dr In dtTotalesProvincia.Rows
            tmp_rslt &= "{name: '" & dr("Lista") & "'" &
                        ", x: " & Convert.ToDouble(dr("Senadores")).ToString() &
                        ", y: " & Convert.ToDouble(dr("PorcentajeSenadores")).ToString("F2").Replace(",", ".") &
                        ", color: '" & getColor(dr("Lista")) & "'},"

            '& IIf(dt.Rows.Count > tmp_index, ",", "")
            tmp_SumSenadores = tmp_SumSenadores + Convert.ToDouble(dr("PorcentajeSenadores"))
            tmp_SumVotosSenadores = tmp_SumVotosSenadores + Convert.ToDouble(dr("Senadores"))
        Next
        'tmp_rslt &= "]"""

        tmp_rslt &= "{name: 'Otros', x: " & dtTotalesProvincia.Rows(0)("total") - tmp_SumVotosSenadores & ", y: " & (100 - tmp_SumSenadores).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        Return tmp_rslt
    End Function

    Public Function ObtenerDatosDiputados() As String
        Dim tmp_rslt As String = ""
        Dim tmp_index As Integer = 1
        Dim tmp_SumDiputados As Double = 0
        Dim tmp_SumVotosDiputados As Double = 0
        'tmp_rslt &= """["
        For Each dr In dtTotalesProvincia.Rows

            tmp_rslt &= "{name: '" & dr("Lista") & "'" &
                        ", x: " & Convert.ToDouble(dr("Diputados")).ToString() &
                        ", y: " & Convert.ToDouble(dr("PorcentajeDiputados")).ToString("F2").Replace(",", ".") &
                        ", color: '" & getColor(dr("Lista")) & "'},"
            tmp_SumDiputados = tmp_SumDiputados + Convert.ToDouble(dr("PorcentajeDiputados"))
            tmp_SumVotosDiputados = tmp_SumVotosDiputados + Convert.ToDouble(dr("Diputados"))
            tmp_index = tmp_index + 1
        Next
        'tmp_rslt &= "]"""

        tmp_rslt &= "{name: 'Otros', x: " & dtTotalesProvincia.Rows(0)("total") - tmp_SumVotosDiputados & ", y: " & (100 - tmp_SumDiputados).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        Return tmp_rslt
    End Function

    Function PorcentajeDeMesaEscrutadas() As Integer
        Return tmp_MesasEscrutadas * 100 / tmp_TotalMesas
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
