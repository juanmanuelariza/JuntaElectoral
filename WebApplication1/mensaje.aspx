<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="mensaje.aspx.vb" Inherits="mensaje" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
<br />
    <br />
    <table style="width:100%;">
        <tr>
            <td style="width: 298px">
    <asp:Label ID="Label1" runat="server" style="font-size: large"></asp:Label>
                <br />
    <asp:Label ID="Label2" runat="server" style="font-size: x-large; color: #006600"></asp:Label>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td style="width: 298px">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td style="width: 298px">
                <asp:Button ID="Button1" runat="server" Text="Aceptar"  />
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <br />
</asp:Content>

