
Imports System.Data
Imports System.IO

Partial Class tablero_aspx
    Inherits System.Web.UI.Page

    Dim dtTotales, dtVotantes, dtTotalMesas, dtEscrutadas As DataTable
    Public tmp_TotalMesas As String
    Public tmp_MesasEscrutadas As String
    Public tmp_TotalVotantes As String
    Public tmp_TotalPadron As String
    Dim tmp_testReportes As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ScriptManager.GetCurrent(Page).RegisterPostBackControl(DDL_Departamento)
        ScriptManager.GetCurrent(Page).RegisterPostBackControl(DDL_Circuito)
        ScriptManager.GetCurrent(Page).RegisterPostBackControl(DDL_Escuela)

        tmp_testReportes = Request.QueryString("paso")

        Dim StrSQL As String = ""
        Dim dtCircuitos, dtEscuelas As DataTable
        'FILTROS

        Dim tmp_eventTarget As String = Request.Form("__EVENTTARGET")

        If Not tmp_eventTarget Is Nothing Then
            If InStr(tmp_eventTarget, "DDL_Departamento") > 0 Then
                DDL_Circuito.Items.Clear()
                DDL_Escuela.Items.Clear()
            ElseIf InStr(tmp_eventTarget, "DDL_Circuito") > 0 Then
                DDL_Escuela.Items.Clear()

            End If

        End If

        If DDL_Departamento.SelectedValue = 0 Then
            DDL_Circuito.Enabled = False
            DDL_Escuela.Enabled = False
            'DDL_Circuito.Items.Clear()
            'DDL_Escuela.Items.Clear()
        ElseIf DDL_Circuito.Items.Count = 0 OrElse DDL_Circuito.SelectedValue = 0 Then
            'DDL_Circuito.Items.Clear()
            'DDL_Escuela.Items.Clear()
            StrSQL = "SELECT circuito_nro, circuito_nombre FROM circuitos WHERE rela_seccion = " & DDL_Departamento.SelectedValue
            dtCircuitos = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))
            DDL_Circuito.Items.Add(New ListItem("Todos", 0))
            For Each dr In dtCircuitos.Rows
                DDL_Circuito.Items.Add(New ListItem(dr("circuito_nro") & " - " & dr("circuito_nombre"), dr("circuito_nro")))
            Next
            DDL_Circuito.Enabled = True
            DDL_Escuela.Enabled = False
        ElseIf DDL_Escuela.Items.Count = 0 OrElse DDL_Circuito.SelectedValue = 0 Then
            '    DDL_Escuela.Items.Clear()
            'End If
            StrSQL = "SELECT id_establecimiento, establecimiento FROM establecimientos WHERE rela_circuito = " & DDL_Circuito.SelectedValue
            dtEscuelas = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))
            DDL_Escuela.Items.Add(New ListItem("Todas", 0))
            For Each dr In dtEscuelas.Rows
                DDL_Escuela.Items.Add(New ListItem(dr("id_establecimiento") & " - " & dr("establecimiento"), dr("id_establecimiento")))
            Next
            DDL_Escuela.Enabled = True
        End If



        'Totales Diputados y Senadores
        StrSQL = "Select l.lista as Lista, SUM(rm.cant_votantes) as total, SUM(dr.cant_senadores) as Senadores, SUM(dr.cant_diputados) as Diputados, " &
        "CAST(SUM(dr.cant_senadores)as float)*100/CAST(SUM(rm.cant_votantes) AS float) as PorcentajeSenadores, " &
        "CAST(SUM(dr.cant_diputados)as float)*100/CAST(SUM(rm.cant_votantes) AS float) as PorcentajeDiputados " &
        "From mesas m INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
        "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
        "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito " &
        "INNER JOIN detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
        "INNER JOIN listas l ON dr.rela_lista = l.id_lista "
        If (DDL_Departamento.SelectedValue > 0) Then
            StrSQL &= "where c.rela_seccion = " & DDL_Departamento.SelectedValue
            If (DDL_Circuito.SelectedValue > 0) Then
                StrSQL &= " AND c.id_circuito = " & DDL_Circuito.SelectedValue
                If (DDL_Escuela.SelectedValue > 0) Then
                    StrSQL &= " AND e.id_establecimiento = " & DDL_Escuela.SelectedValue
                End If
            End If
        End If
        StrSQL &= " Group by l.lista, l.id_lista order by l.id_lista"

        dtTotales = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))

        'Votantes del padron
        StrSQL = "Select SUM(m.cant_votantes) As total_votantes, SUM(rm.cant_votantes) As cant_votantes FROM mesas m " &
            "INNER JOIN resultados_mesas rm On m.id_mesa = rm.rela_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER JOIN circuitos c On c.id_circuito = e.rela_circuito "

        If (DDL_Departamento.SelectedValue > 0) Then
            StrSQL &= "where c.rela_seccion = " & DDL_Departamento.SelectedValue
            If (DDL_Circuito.SelectedValue > 0) Then
                StrSQL &= " AND c.id_circuito = " & DDL_Circuito.SelectedValue
                If (DDL_Escuela.SelectedValue > 0) Then
                    StrSQL &= " AND e.id_establecimiento = " & DDL_Escuela.SelectedValue
                End If
            End If
        End If
        dtVotantes = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))

        'Cantidad de mesas
        StrSQL = "Select COUNT(m.id_mesa) As TotalMesas FROM mesas m " &
            "INNER Join establecimientos e On m.rela_establecimientos = e.id_establecimiento " &
            "INNER Join circuitos c On e.rela_circuito = c.id_circuito " &
            "INNER Join seccion s On c.rela_seccion = s.id_seccion "
        If (DDL_Departamento.SelectedValue > 0) Then
            StrSQL &= "where c.rela_seccion = " & DDL_Departamento.SelectedValue
            If (DDL_Circuito.SelectedValue > 0) Then
                StrSQL &= " AND c.id_circuito = " & DDL_Circuito.SelectedValue
                If (DDL_Escuela.SelectedValue > 0) Then
                    StrSQL &= " AND e.id_establecimiento = " & DDL_Escuela.SelectedValue
                End If
            End If
        End If

        dtTotalMesas = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))

        'Mesas Escrutadas
        StrSQL = "Select distinct rm.rela_mesa As Mesa " &
            "From resultados_mesas rm " &
            "left Join detalle_resultados dr On rm.id_resultado = dr.rela_resultado " &
            "Left Join mesas m On rm.rela_mesa = m.id_mesa " &
            "INNER JOIN establecimientos e On e.id_establecimiento = m.rela_establecimientos " &
            "INNER Join circuitos c On c.id_circuito = e.rela_circuito " &
            "where (dr.cant_diputados > 0 Or dr.cant_senadores > 0) "
        If (DDL_Departamento.SelectedValue > 0) Then
            StrSQL &= "AND c.rela_seccion = " & DDL_Departamento.SelectedValue
            If (DDL_Circuito.SelectedValue > 0) Then
                StrSQL &= " AND c.id_circuito = " & DDL_Circuito.SelectedValue
                If (DDL_Escuela.SelectedValue > 0) Then
                    StrSQL &= " AND e.id_establecimiento = " & DDL_Escuela.SelectedValue
                End If
            End If
        End If
        dtEscrutadas = GetTableFromSQL(StrSQL, iif(tmp_testReportes = "1", "testReportes", ""))

        tmp_TotalMesas = dtTotalMesas.Rows(0)("TotalMesas")
        tmp_MesasEscrutadas = dtEscrutadas.Rows.Count
        tmp_TotalVotantes = iif(IsDbNull(dtVotantes.Rows(0)("cant_votantes")), 0, dtVotantes.Rows(0)("cant_votantes"))
        tmp_TotalPadron = iif(IsDbNull(dtVotantes.Rows(0)("total_votantes")), 0, dtVotantes.Rows(0)("total_votantes"))
    End Sub


    Public Function ObtenerDatosSenadores() As String
        Dim tmp_rslt As String = ""
        Dim tmp_SumSenadores As Double = 0
        Dim tmp_SumVotosSenadores As Double = 0
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

        If tmp_testReportes = "1" Then
            tmp_rslt &= "{name: 'Otros', x: " & dtTotales.Rows(0)("total") - tmp_SumVotosSenadores & ", y: " & (100 - tmp_SumSenadores).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        End If

        Return tmp_rslt
    End Function

    Public Function ObtenerDatosDiputados() As String
        Dim tmp_rslt As String = ""
        Dim tmp_index As Integer = 1
        Dim tmp_SumDiputados As Double = 0
        Dim tmp_SumVotosDiputados As Double = 0
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

        If tmp_testReportes = "1" Then
            tmp_rslt &= "{name: 'Otros', x: " & dtTotales.Rows(0)("total") - tmp_SumVotosDiputados & ", y: " & (100 - tmp_SumDiputados).ToString("F2").Replace(",", ".") & ", color: '#c3c3c3'}"
        End If

        Return tmp_rslt
    End Function

    Function PorcentajeDeMesaEscrutadas() As Integer
        If tmp_TotalPadron > 0 Then
            Return dtEscrutadas.Rows.Count * 100 / tmp_TotalMesas
        Else
            Return 0
        End If
    End Function

    Function PorcentajeVotantesPadron() As Integer
        If tmp_TotalPadron > 0 Then
            Return tmp_TotalVotantes * 100 / tmp_TotalPadron
        Else
            Return 0
        End If
    End Function

    Function ComparacionSenadores() As String
        Dim tmp_rslt As String = ""
        Dim dtPaso As DataTable
        Dim StrSQL As String = ""
        Dim StrMesas As String
        Dim ListaMesas As New List(Of String)()

        Dim tmp_SumFrenteTodos As Integer = 0
        Dim tmp_SumCambiemos As Integer = 0
        Dim tmp_Sum1Pais As Integer = 0
        Dim tmp_SumOtros As Integer = 0

        Dim tmp_SumSenadores As Double = 0
        Dim tmp_SumVotosSenadores As Double = 0

        For Each dr In dtTotales.Rows

            Select Case dr("Lista")
                Case "San Juan Primero"
                    tmp_SumFrenteTodos = tmp_SumFrenteTodos + dr("Senadores")
                Case "Frente Todos"
                    tmp_SumFrenteTodos = tmp_SumFrenteTodos + dr("Senadores")
                Case "Cambiemos Juntos"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Senadores")
                Case "Cambiemos"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Senadores")
                Case "Lista Renovación"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Senadores")
                Case "Somos San Juan"
                    tmp_Sum1Pais = tmp_Sum1Pais + dr("Senadores")
                Case "1Pais"
                    tmp_Sum1Pais = tmp_Sum1Pais + dr("Senadores")
                Case "Otros"
                    tmp_SumOtros = tmp_SumOtros + dr("Senadores")
            End Select
            tmp_SumVotosSenadores = tmp_SumVotosSenadores + Convert.ToDouble(dr("Senadores"))
        Next


        For Each drEscrutadas In dtEscrutadas.Rows
            ListaMesas.Add(drEscrutadas("Mesa"))
        Next
        StrMesas = String.Join(",", ListaMesas)
        If StrMesas <> "" Then
            StrSQL = "SELECT SUM(SenadoresTotalAfirmativo) AS SenadoresTotalAfirmativo, SUM(SenadoresFrenteTodos) AS SenadoresFrenteTodos, SUM(SenadoresCambiemos) AS SenadoresCambiemos, SUM(Senadores1Pais) AS Senadores1Pais, SUM(SenadoresOtros) AS SenadoresOtros, " &
                    "SUM(DiputadosTotalAfirmativo) AS DiputadosTotalAfirmativo, SUM(DiputadosFrenteTodos) As DiputadosFrenteTodos, SUM(DiputadosCambiemos) As DiputadosCambiemos, SUM(Diputados1Pais) AS Diputados1Pais, SUM(DiputadosOtros) AS DiputadosOtros " &
                    "FROM MatrizProcesada WHERE NumeroMesa in (" & StrMesas & ")"
            dtPaso = GetTableFromSQL(StrSQL, "PasoCorreo")

            tmp_rslt = "{name: 'Paso 2017', data: [{ y: " & dtPaso.Rows(0)("SenadoresFrenteTodos") & ", color: '#2469a8' }, { y: " & dtPaso.Rows(0)("SenadoresCambiemos") & ", color: '#eeff00' }, { y: " & dtPaso.Rows(0)("Senadores1Pais") & ", color: '#78288c' }, { y: " & dtPaso.Rows(0)("SenadoresOtros") & ", color: '#c3c3c3' }]}, " &
                        "{name: 'Generales 2017',data: [{ y: " & tmp_SumFrenteTodos.ToString() & ", color: '#2469a8' }, { y: " & tmp_SumCambiemos.ToString() & ", color: '#eeff00' }, { y: " & tmp_Sum1Pais.ToString() & ", color: '#78288c' }, { y: " & iif(tmp_SumOtros > 0, tmp_SumOtros, dtTotales.Rows(0)("total") - tmp_SumVotosSenadores) & ", color: '#c3c3c3' }]}"
        End If



        Return tmp_rslt
    End Function

    Function ComparacionDiputados() As String
        Dim tmp_rslt As String = ""
        Dim dtPaso As DataTable
        Dim StrSQL As String = ""
        Dim StrMesas As String
        Dim ListaMesas As New List(Of String)()

        Dim tmp_SumFrenteTodos As Integer = 0
        Dim tmp_SumCambiemos As Integer = 0
        Dim tmp_Sum1Pais As Integer = 0
        Dim tmp_SumOtros As Integer = 0

        Dim tmp_SumDiputados As Double = 0
        Dim tmp_SumVotosDiputados As Double = 0
        'tmp_rslt &= """["
        For Each dr In dtTotales.Rows

            Select Case dr("Lista")
                Case "San Juan Primero"
                    tmp_SumFrenteTodos = tmp_SumFrenteTodos + dr("Diputados")
                Case "Frente Todos"
                    tmp_SumFrenteTodos = tmp_SumFrenteTodos + dr("Diputados")
                Case "Cambiemos Juntos"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Diputados")
                Case "Cambiemos"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Diputados")
                Case "Lista Renovación"
                    tmp_SumCambiemos = tmp_SumCambiemos + dr("Diputados")
                Case "Somos San Juan"
                    tmp_Sum1Pais = tmp_Sum1Pais + dr("Diputados")
                Case "1Pais"
                    tmp_Sum1Pais = tmp_Sum1Pais + dr("Diputados")
                Case "Otros"
                    tmp_SumOtros = tmp_SumOtros + dr("Diputados")
            End Select
            tmp_SumVotosDiputados = tmp_SumVotosDiputados + Convert.ToDouble(dr("Diputados"))
        Next


        For Each drEscrutadas In dtEscrutadas.Rows
            ListaMesas.Add(drEscrutadas("Mesa"))
        Next
        StrMesas = String.Join(",", ListaMesas)

        If StrMesas <> "" Then
            StrSQL = "SELECT SUM(SenadoresTotalAfirmativo) AS SenadoresTotalAfirmativo, SUM(SenadoresFrenteTodos) AS SenadoresFrenteTodos, SUM(SenadoresCambiemos) AS SenadoresCambiemos, SUM(Senadores1Pais) AS Senadores1Pais, SUM(SenadoresOtros) AS SenadoresOtros, " &
                "SUM(DiputadosTotalAfirmativo) AS DiputadosTotalAfirmativo, SUM(DiputadosFrenteTodos) As DiputadosFrenteTodos, SUM(DiputadosCambiemos) As DiputadosCambiemos, SUM(Diputados1Pais) AS Diputados1Pais, SUM(DiputadosOtros) AS DiputadosOtros " &
                "FROM MatrizProcesada WHERE NumeroMesa in (" & StrMesas & ")"
            dtPaso = GetTableFromSQL(StrSQL, "PasoCorreo")

            tmp_rslt = "{name: 'Paso 2017', data: [{ y: " & dtPaso.Rows(0)("DiputadosFrenteTodos") & ", color: '#2469a8' }, { y: " & dtPaso.Rows(0)("DiputadosCambiemos") & ", color: '#eeff00' }, { y: " & dtPaso.Rows(0)("Diputados1Pais") & ", color: '#78288c' }, { y: " & dtPaso.Rows(0)("DiputadosOtros") & ", color: '#c3c3c3' }]}, " &
                    "{name: 'Generales 2017',data: [{ y: " & tmp_SumFrenteTodos.ToString() & ", color: '#2469a8' }, { y: " & tmp_SumCambiemos.ToString() & ", color: '#eeff00' }, { y: " & tmp_Sum1Pais.ToString() & ", color: '#78288c' }, { y: " & iif(tmp_SumOtros > 0, tmp_SumOtros, dtTotales.Rows(0)("total") - tmp_SumVotosDiputados) & ", color: '#c3c3c3' }]}"
        End If

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
