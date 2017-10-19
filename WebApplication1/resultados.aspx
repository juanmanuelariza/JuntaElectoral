<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="resultados.aspx.vb" Inherits="resultados_aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
    <asp:Panel ID="Panel1" runat="server">
                   <asp:Timer ID="Timer1" runat="server" Interval="30000">
                    </asp:Timer> 
        <table style="width:100%;">
            <tr>
                <td style="text-align: left; width: 345px; height: 25px">
                    <asp:Label ID="Label1" runat="server" style="font-size: large"></asp:Label>
                </td>
                <td style="width: 284px; text-align: left; height: 25px"></td>
                <td style="height: 25px"></td>
            </tr>
            <tr>
                <td style="width: 345px; text-align: left">
                    
                    <br />
                    
                    <asp:DropDownList ID="DropDownList1" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSource1" DataTextField="seccion" DataValueField="id_seccion" Height="24px" style="font-size: large" Width="195px" AutoPostBack="True">
                        <asp:ListItem Value="0">Todos</asp:ListItem>
                    </asp:DropDownList>
                    
                    <br />
                    
                </td>
                <td style="width: 284px">&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 345px; text-align: left;">
                    
                    <asp:Label ID="Label2" runat="server" style="font-size: large; color: #000000;"></asp:Label>
                    
                    <br />
                    <asp:Label ID="Label3" runat="server" style="font-size: large; color: #000000;"></asp:Label>
                    <br />
                    <asp:Label ID="Label4" runat="server" style="font-size: large; color: #000000;"></asp:Label>
                    
                    <br />
                    <asp:Label ID="Label5" runat="server" style="font-size: large; color: #000000;"></asp:Label>
                    
                </td>
                <td style="width: 284px">&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
                   <br />
                   <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource4" style="font-size: x-large; color: #000000" Width="1018px">
                       <Columns>
                           <asp:BoundField DataField="Lista" HeaderText="Lista" SortExpression="Lista" />
                           <asp:BoundField DataField="Senadores" HeaderText="Senadores" ReadOnly="True" SortExpression="Senadores" />
                           <asp:BoundField DataField="Diputados" HeaderText="Diputados" ReadOnly="True" SortExpression="Diputados" />
                           <asp:BoundField DataField="% Senadores" DataFormatString="{0:n}" HeaderText="% Senadores" ReadOnly="True" SortExpression="% Senadores" />
                           <asp:BoundField DataField="% Diputados" DataFormatString="{0:n}" HeaderText="% Diputados" ReadOnly="True" SortExpression="% Diputados" />
                       </Columns>
                   </asp:GridView>
                   <br />
    </asp:Panel>
    <asp:Panel ID="Panel2" runat="server">
    </asp:Panel>
    <asp:Panel ID="Panel3" runat="server">
    </asp:Panel>
    <asp:Panel ID="Panel4" runat="server">
    </asp:Panel>
    <asp:Panel ID="Panel5" runat="server">
        <table style="width:100%;">
            <tr>
                <td style="width: 284px">
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT COUNT(id_mesa) AS Expr1 FROM mesas"></asp:SqlDataSource>
                </td>
                <td style="width: 271px">
                    <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource2" DataTextField="Expr1" DataValueField="Expr1">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion HAVING (SUM(detalle_resultados.cant_diputados) &gt; 0) OR (SUM(detalle_resultados.cant_senadores) &gt; 0) ORDER BY Mesa"></asp:SqlDataSource>
                </td>
                <td>
                    <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDataSource3" DataTextField="Mesa" DataValueField="Mesa">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 284px; height: 20px">
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT listas.lista AS Lista, SUM(detalle_resultados_1.cant_senadores) AS Senadores, SUM(detalle_resultados_1.cant_diputados) AS Diputados, CAST(SUM(detalle_resultados_1.cant_senadores) AS float) / CAST((SELECT SUM(cant_votantes) AS total FROM resultados_mesas WHERE (id_resultado IN (SELECT rela_resultado FROM detalle_resultados WHERE (cant_diputados &gt; 0) OR (cant_senadores &gt; 0) GROUP BY rela_resultado))) AS float) * 100 AS [% Senadores], CAST(SUM(detalle_resultados_1.cant_diputados) AS float) / CAST((SELECT SUM(cant_votantes) AS total FROM resultados_mesas AS resultados_mesas_2 WHERE (id_resultado IN (SELECT rela_resultado FROM detalle_resultados AS detalle_resultados_2 WHERE (cant_diputados &gt; 0) OR (cant_senadores &gt; 0) GROUP BY rela_resultado))) AS float) * 100 AS [% Diputados] FROM resultados_mesas AS resultados_mesas_1 INNER JOIN detalle_resultados AS detalle_resultados_1 ON resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas ON detalle_resultados_1.rela_lista = listas.id_lista GROUP BY listas.lista, listas.id_lista ORDER BY listas.id_lista"></asp:SqlDataSource>
                </td>
                <td style="height: 20px; width: 271px">
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT id_seccion, seccion FROM seccion ORDER BY seccion"></asp:SqlDataSource>
                </td>
                <td style="height: 20px">
                    <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT listas.lista AS Lista, SUM(detalle_resultados_1.cant_senadores) AS Senadores, SUM(detalle_resultados_1.cant_diputados) AS Diputados, CAST(SUM(detalle_resultados_1.cant_senadores) AS float) / CAST((SELECT SUM(cant_votantes) AS total FROM resultados_mesas WHERE (id_resultado IN (SELECT detalle_resultados.rela_resultado FROM detalle_resultados INNER JOIN resultados_mesas AS resultados_mesas_3 ON detalle_resultados.rela_resultado = resultados_mesas_3.id_resultado INNER JOIN mesas ON resultados_mesas_3.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito WHERE (detalle_resultados.cant_diputados &gt; 0) OR (detalle_resultados.cant_senadores &gt; 0) GROUP BY detalle_resultados.rela_resultado, circuitos.rela_seccion HAVING (circuitos.rela_seccion = @Param1)))) AS float) * 100 AS [% Senadores], CAST(SUM(detalle_resultados_1.cant_diputados) AS float) / CAST((SELECT SUM(cant_votantes) AS total FROM resultados_mesas AS resultados_mesas_2 WHERE (id_resultado IN (SELECT detalle_resultados_2.rela_resultado FROM detalle_resultados AS detalle_resultados_2 INNER JOIN resultados_mesas AS resultados_mesas_3 ON detalle_resultados_2.rela_resultado = resultados_mesas_3.id_resultado INNER JOIN mesas AS mesas_2 ON resultados_mesas_3.rela_mesa = mesas_2.id_mesa INNER JOIN establecimientos AS establecimientos_2 ON mesas_2.rela_establecimientos = establecimientos_2.id_establecimiento INNER JOIN circuitos AS circuitos_2 ON establecimientos_2.rela_circuito = circuitos_2.id_circuito WHERE (detalle_resultados_2.cant_diputados &gt; 0) OR (detalle_resultados_2.cant_senadores &gt; 0) GROUP BY detalle_resultados_2.rela_resultado, circuitos_2.rela_seccion HAVING (circuitos_2.rela_seccion = @Param1)))) AS float) * 100 AS [% Diputados] FROM resultados_mesas AS resultados_mesas_1 INNER JOIN detalle_resultados AS detalle_resultados_1 ON resultados_mesas_1.id_resultado = detalle_resultados_1.rela_resultado INNER JOIN listas ON detalle_resultados_1.rela_lista = listas.id_lista INNER JOIN mesas AS mesas_1 ON resultados_mesas_1.rela_mesa = mesas_1.id_mesa INNER JOIN establecimientos AS establecimientos_1 ON mesas_1.rela_establecimientos = establecimientos_1.id_establecimiento INNER JOIN circuitos AS circuitos_1 ON establecimientos_1.rela_circuito = circuitos_1.id_circuito INNER JOIN seccion ON circuitos_1.rela_seccion = seccion.id_seccion GROUP BY listas.lista, listas.id_lista, seccion.id_seccion HAVING (seccion.id_seccion = @Param1) ORDER BY listas.id_lista">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropDownList1" Name="Param1" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td style="height: 20px">
                    <asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="SqlDataSource8" DataTextField="rela_seccion" DataValueField="rela_seccion">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 284px; height: 20px">
                    <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT COUNT(mesas.id_mesa) AS Expr1 FROM mesas INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY seccion.id_seccion HAVING (seccion.id_seccion = @Param1)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropDownList1" Name="Param1" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td style="width: 271px; height: 20px">
                    <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion, seccion.id_seccion HAVING (SUM(detalle_resultados.cant_diputados) &gt; 0 OR SUM(detalle_resultados.cant_senadores) &gt; 0) AND (seccion.id_seccion = @Param1) ORDER BY Mesa">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropDownList1" Name="Param1" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td style="height: 20px">
                    <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT rela_seccion FROM usuario_establecimientos WHERE (rela_usuario = @Param1)">
                        <SelectParameters>
                            <asp:SessionParameter Name="Param1" SessionField="id_usuario" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td style="height: 20px">&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 284px">
                    <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT SUM(resultados_mesas.cant_votantes) AS [Cantidad Vot] FROM resultados_mesas "></asp:SqlDataSource>
                </td>
                <td style="width: 271px">
                    <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT SUM(cant_votantes) AS total FROM resultados_mesas WHERE (id_resultado IN (SELECT rela_resultado FROM detalle_resultados WHERE (cant_diputados &gt; 0) OR (cant_senadores &gt; 0) GROUP BY rela_resultado))"></asp:SqlDataSource>
                </td>
                <td>
                    <asp:DropDownList ID="DropDownList5" runat="server" DataSourceID="SqlDataSource14" DataTextField="total" DataValueField="total">
                    </asp:DropDownList>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 284px">
                    <asp:SqlDataSource ID="SqlDataSource15" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT SUM(resultados_mesas.cant_votantes) AS total FROM resultados_mesas INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito WHERE (resultados_mesas.id_resultado IN (SELECT rela_resultado FROM detalle_resultados WHERE (cant_diputados &gt; 0) OR (cant_senadores &gt; 0) GROUP BY rela_resultado)) GROUP BY circuitos.rela_seccion HAVING (circuitos.rela_seccion = @Param1)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropDownList1" Name="Param1" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
                <td style="width: 271px">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 284px">&nbsp;</td>
                <td style="width: 271px">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </asp:Panel>
                                        </ContentTemplate>
        </asp:UpdatePanel>
                    
    
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

