<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="faltantes.aspx.vb" Inherits="faltantes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <asp:Panel ID="Panel1" runat="server">
        <br />
        <asp:Button ID="Button1" runat="server" style="color: #FF0000" Width="200px" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button2" runat="server" style="color: #CCCC00" Width="200px" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button3" runat="server" style="color: #009900" Width="200px" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Cantidad Votantes"></asp:Label>
        <span class="auto-style2" style="color: #FF0000">
        <asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="SqlDataSource11" DataTextField="Cantidad Vot" DataValueField="Cantidad Vot" Height="16px" Width="121px">
        </asp:DropDownList>
        &nbsp;&nbsp;
        </span>
        <asp:Label ID="Label2" runat="server" style="font-size: large"></asp:Label>
     </asp:Panel>
    <asp:Panel ID="Panel2" runat="server">
        <br />
        <span class="auto-style2" style="color: #FF0000"><strong>Mesas Sin Cargar<br /> </strong>
        </span><br />
        Sección
        <asp:DropDownList ID="DropDownList1" runat="server" Height="21px" Width="168px" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="SqlDataSource5" DataTextField="seccion" DataValueField="id_seccion">
            <asp:ListItem Value="0">Todos</asp:ListItem>
        </asp:DropDownList>
        <div class="nivo-lightbox-image">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" Width="501px">
                <Columns>
                    <asp:BoundField DataField="Seccion" HeaderText="Seccion" SortExpression="Seccion" />
                    <asp:BoundField DataField="Circuito" HeaderText="Circuito" SortExpression="Circuito" />
                    <asp:BoundField DataField="Establecimiento" HeaderText="Establecimiento" SortExpression="Establecimiento" />
                    <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
                </Columns>
            </asp:GridView>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </asp:Panel>
    <asp:Panel ID="Panel3" runat="server">
        <span class="auto-style2"><strong>
        <br />
        </strong></span><span class="auto-style3" style="color: #CCCC00"><strong>Mesas con Carga Parcial</strong></span></strong><br /> Sección &nbsp;<asp:DropDownList ID="DropDownList2" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="SqlDataSource5" DataTextField="seccion" DataValueField="id_seccion" Height="21px" Width="168px">
            <asp:ListItem Value="0">Todos</asp:ListItem>
        </asp:DropDownList>
        &nbsp;<br />
        <div class="nivo-lightbox-image">
            <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT SUM(resultados_mesas.cant_votantes) AS [Cantidad Vot] FROM resultados_mesas "></asp:SqlDataSource>
            <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource3" Width="499px" AllowSorting="True">
                <Columns>
                    <asp:BoundField DataField="Sección" HeaderText="Sección" SortExpression="Sección" />
                    <asp:BoundField DataField="Circuito" HeaderText="Circuito" SortExpression="Circuito" />
                    <asp:BoundField DataField="Establecimiento" HeaderText="Establecimiento" SortExpression="Establecimiento" />
                    <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
                    <asp:BoundField DataField="Cantidad Vot" HeaderText="Cantidad Vot" SortExpression="Cantidad Vot" />
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
     <asp:Panel ID="Panel5" runat="server">
         <br />
         <strong><span class="auto-style4" style="color: #009900">Mesas con Carga Final</span></strong><br />
         Sección&nbsp;<asp:DropDownList ID="DropDownList3" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="SqlDataSource5" DataTextField="seccion" DataValueField="id_seccion" Height="21px" Width="168px">
             <asp:ListItem Value="0">Todos</asp:ListItem>
         </asp:DropDownList>
&nbsp;<div class="nivo-lightbox-image">
             <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource4" Width="501px">
                 <Columns>
                     <asp:BoundField DataField="Sección" HeaderText="Sección" SortExpression="Sección" />
                     <asp:BoundField DataField="Circuito" HeaderText="Circuito" SortExpression="Circuito" />
                     <asp:BoundField DataField="Establecimiento" HeaderText="Establecimiento" SortExpression="Establecimiento" />
                     <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
                 </Columns>
             </asp:GridView>
         </div>
    </asp:Panel>
   
    <asp:Panel ID="Panel4" runat="server">
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Seccion, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, mesas.id_mesa AS Mesa FROM mesas INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion WHERE (mesas.id_mesa NOT IN (SELECT resultados_mesas.rela_mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado GROUP BY resultados_mesas.rela_mesa)) ORDER BY Seccion, Circuito, Establecimiento, Mesa"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Seccion, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, mesas.id_mesa AS Mesa FROM mesas INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion WHERE (mesas.id_mesa NOT IN (SELECT resultados_mesas.rela_mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado GROUP BY resultados_mesas.rela_mesa)) AND (seccion.id_seccion = @Param1) ORDER BY Seccion, Circuito, Establecimiento, Mesa">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DropDownList1" Name="Param1" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Sección, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, resultados_mesas.rela_mesa AS Mesa, resultados_mesas.cant_votantes AS [Cantidad Vot] FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion, resultados_mesas.cant_votantes HAVING (SUM(detalle_resultados.cant_diputados) = 0) AND (SUM(detalle_resultados.cant_senadores) = 0) ORDER BY Sección, Circuito, Establecimiento, Mesa"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Sección, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, resultados_mesas.rela_mesa AS Mesa, resultados_mesas.cant_votantes AS [Cantidad Vot] FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion, seccion.id_seccion, resultados_mesas.cant_votantes HAVING (SUM(detalle_resultados.cant_diputados) = 0) AND (SUM(detalle_resultados.cant_senadores) = 0) AND (seccion.id_seccion = @Param1) ORDER BY Sección, Circuito, Establecimiento, Mesa">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DropDownList2" Name="Param1" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Sección, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion HAVING (SUM(detalle_resultados.cant_diputados) &gt; 0) OR (SUM(detalle_resultados.cant_senadores) &gt; 0) ORDER BY Sección, Circuito, Establecimiento, Mesa"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion.seccion AS Sección, circuitos.circuito_nombre AS Circuito, establecimientos.establecimiento AS Establecimiento, resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado INNER JOIN mesas ON resultados_mesas.rela_mesa = mesas.id_mesa INNER JOIN establecimientos ON mesas.rela_establecimientos = establecimientos.id_establecimiento INNER JOIN circuitos ON establecimientos.rela_circuito = circuitos.id_circuito INNER JOIN seccion ON circuitos.rela_seccion = seccion.id_seccion GROUP BY resultados_mesas.rela_mesa, establecimientos.establecimiento, circuitos.circuito_nombre, seccion.seccion, seccion.id_seccion HAVING (SUM(detalle_resultados.cant_diputados) &gt; 0 OR SUM(detalle_resultados.cant_senadores) &gt; 0) AND (seccion.id_seccion = @Param1) ORDER BY Sección, Circuito, Establecimiento, Mesa">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DropDownList3" Name="Param1" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT seccion, id_seccion FROM seccion ORDER BY seccion"></asp:SqlDataSource>
    </asp:Panel>
    
    
    
    
</asp:Content>

