<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mesas.aspx.vb" Inherits="mesas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        .auto-style1 {
            color: #009933;
        }
        .auto-style2 {
            color: #FF0000;
            font-size: large;
        }
        .auto-style3 {
            color: #CC9900;
            font-size: large;
        }
        .auto-style4 {
            color: #009900;
            font-size: large;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <div style="text-align: left">
    <asp:Panel ID="Panel1" runat="server">
        <asp:Button ID="Button1" runat="server" style="color: #FF0000" Width="200px" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button2" runat="server" style="color: #CCCC00" Width="200px" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button3" runat="server"  Width="200px" CssClass="auto-style1" />
    </asp:Panel>
    </div>
    <asp:Panel ID="Panel2" runat="server">
        <br />
        <span class="auto-style2"><strong>Mesas Sin Cargar</strong></span><br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" Width="59px">
            <Columns>
                <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
            </Columns>
        </asp:GridView>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </asp:Panel>
    <asp:Panel ID="Panel3" runat="server">
        <span class="auto-style2"><strong>
        <br />
        </strong></span><span class="auto-style3">Mesas con Carga Parcial</span><span class="auto-style2"><br /> </span></strong><br />
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource3" Width="59px">
            <Columns>
                <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
            </Columns>
        </asp:GridView>
    </asp:Panel>
     <asp:Panel ID="Panel5" runat="server">
         <br />
         <strong><span class="auto-style4">Mesas con Carga Final</span><span class="auto-style2"><br /> </span></strong><br />
        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource4" Width="59px">
            <Columns>
                <asp:BoundField DataField="Mesa" HeaderText="Mesa" SortExpression="Mesa" />
            </Columns>
        </asp:GridView>
    </asp:Panel>
   
    <asp:Panel ID="Panel4" runat="server">
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT id_mesa AS Mesa FROM mesas WHERE (id_mesa NOT IN (SELECT resultados_mesas.rela_mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado GROUP BY resultados_mesas.rela_mesa))"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado GROUP BY resultados_mesas.rela_mesa HAVING (SUM(detalle_resultados.cant_diputados) = 0) AND (SUM(detalle_resultados.cant_senadores) = 0)"></asp:SqlDataSource>
            &nbsp;<asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT resultados_mesas.rela_mesa AS Mesa FROM resultados_mesas INNER JOIN detalle_resultados ON resultados_mesas.id_resultado = detalle_resultados.rela_resultado GROUP BY resultados_mesas.rela_mesa HAVING (SUM(detalle_resultados.cant_diputados) &gt; 0) OR (SUM(detalle_resultados.cant_senadores) &gt; 0)"></asp:SqlDataSource>
    </asp:Panel>
    
    
    </div>
    </form>
</body>
</html>
