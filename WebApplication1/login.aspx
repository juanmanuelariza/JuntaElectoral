<%@ Page Title="" Language="VB" MasterPageFile="~/MasterLogin.master" AutoEventWireup="false" CodeFile="login.aspx.vb" Inherits="login" %>

<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <table style="width:100%; height: 194px;">
    <tr>
        <td>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            <br />
            <br />
            <asp:Label ID="Label2" runat="server" Text="DNI de Fiscal  General Encargado de escuela" style="font-size: large; color: #CCCCCC"></asp:Label>
&nbsp;
            <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" style="color: #333333; font-size: large;" Width="92px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" style="font-size: medium; color: #333333;" Text="Entrar" Width="73px" UseSubmitBehavior="False" />
&nbsp;<asp:Label ID="Label3" runat="server" ForeColor="White" style="font-size: large"></asp:Label>
            <br />
            <br />
            <p style="margin-bottom: 0.35cm; line-height: 115%">
                <span lang=""><font size="2" style="font-size: 11pt">
                <asp:HyperLink ID="HyperLink1" runat="server" CssClass="fa-inverse" NavigateUrl="https://www.appsheet.com/start/be024783-5ae8-4464-8ff8-e0fbe44a40a3">Ver agenda online ()</asp:HyperLink>
                <span class="fa-inverse">&nbsp;&nbsp; </span></font><span class="fa-inverse">-&nbsp;&nbsp; </span><font size="2" style="font-size: 11pt">&nbsp;<asp:HyperLink ID="HyperLink2" runat="server" CssClass="fa-inverse" NavigateUrl="https://www.appsheet.com/newshortcut/be024783-5ae8-4464-8ff8-e0fbe44a40a3">Instalar Agenda (Solo Android)</asp:HyperLink>
                </font></span>
            </p>
            <p style="margin-bottom: 0.35cm; line-height: 115%">
                <span lang=""><font size="2" style="font-size: 11pt">
                <asp:HyperLink ID="HyperLink3" runat="server" CssClass="fa-inverse" NavigateUrl="http://focusky.com/rsqp/lgfp">Ver Capacitaciones en linea</asp:HyperLink>
                <span class="fa-inverse">&nbsp;&nbsp; </span></font><span class="fa-inverse">-&nbsp; </span><font size="2" style="font-size: 11pt">&nbsp;<asp:HyperLink ID="HyperLink4" runat="server" CssClass="fa-inverse" NavigateUrl="https://drive.google.com/file/d/0B30RRfnnS4rRZ0VQSmszSFBBdzA/view">Bajar capacitaciones para PC</asp:HyperLink>
                </font></span>
            </p>
            <p style="margin-bottom: 0.35cm; line-height: 115%">
                <span lang=""><font size="2" style="font-size: 11pt">&nbsp;<asp:HyperLink ID="HyperLink5" runat="server" CssClass="fa-inverse" NavigateUrl="https://www.padron.gob.ar">Consultar Padrón Electoral</asp:HyperLink>
                <span class="fa-inverse">&nbsp;&nbsp; </span></font><span class="fa-inverse">-&nbsp;&nbsp; </span><font size="2" style="font-size: 11pt">&nbsp;<asp:HyperLink ID="HyperLink6" runat="server" CssClass="fa-inverse" NavigateUrl="https://play.google.com/store/apps/details?id=ar.gov.pjn.electoral.padron">Instalar Padrón Electoral (Solo Android)</asp:HyperLink>
                </font></span>
            </p>
            <p style="margin-bottom: 0.35cm; line-height: 115%">
                <font size="2" style="font-size: 11pt"><span lang="">
                <asp:HyperLink ID="HyperLink7" runat="server" CssClass="fa-inverse" NavigateUrl="http://servicios.infoleg.gob.ar/infolegInternet/anexos/15000-19999/19442/texact.htm">Código Nacional Electoral</asp:HyperLink>
                </span></font>
            </p>
            <br />
        </td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>
            <asp:Panel ID="Panel1" runat="server" Visible="False">
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:modod_eleccion %>" SelectCommand="SELECT id_usuario, rela_rol, descripcion_usuario FROM usuarios WHERE (pass = @Param2) AND (habilitado = 1)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="TextBox2" Name="Param2" PropertyName="Text" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1">
                    <Columns>
                        <asp:BoundField DataField="id_usuario" HeaderText="id_usuario" InsertVisible="False" ReadOnly="True" SortExpression="id_usuario" />
                        <asp:BoundField DataField="rela_rol" HeaderText="rela_rol" SortExpression="rela_rol" />
                        <asp:BoundField DataField="descripcion_usuario" HeaderText="descripcion_usuario" SortExpression="descripcion_usuario" />
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
</table>

  </asp:Content>

<%-- Agregue aquí los controles de contenido --%>

