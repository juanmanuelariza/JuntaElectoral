<%@ Page Title="" Language="VB" MasterPageFile="~/reportes/MasterPageReportes.master" AutoEventWireup="false" CodeFile="tablero.aspx.vb" Inherits="tablero_aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="js/highcharts/highcharts.js"></script>
    <script src="js/highcharts/highcharts-more.js"></script>
    <script src="js/highcharts/solid-gauge.js"></script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="Panel1" runat="server">
                <%--<asp:Timer ID="Timer1" runat="server" Interval="30000">
                </asp:Timer>--%>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">FILTROS</h3>
                        </div>
                        <div class="box-body">
                            <div class="col-md-12">
                                <div class="form-group">
                                    DEPARTAMENTO
                                    <asp:DropDownList ID="DDL_Departamento" runat="server" CssClass="form-control" AppendDataBoundItems="True" DataTextField="seccion" AutoPostBack="True">
                                        <asp:ListItem Value="0">Todos</asp:ListItem>
                                        <asp:ListItem Value="1">25 de Mayo</asp:ListItem>
                                        <asp:ListItem Value="2">9 de Julio</asp:ListItem>
                                        <asp:ListItem Value="3">Albardon</asp:ListItem>
                                        <asp:ListItem Value="4">Angaco</asp:ListItem>
                                        <asp:ListItem Value="5">Calingasta</asp:ListItem>
                                        <asp:ListItem Value="6">Capital</asp:ListItem>
                                        <asp:ListItem Value="7">Caucete</asp:ListItem>
                                        <asp:ListItem Value="8">Chimbas</asp:ListItem>
                                        <asp:ListItem Value="9">Iglesia</asp:ListItem>
                                        <asp:ListItem Value="10">Jachal</asp:ListItem>
                                        <asp:ListItem Value="11">Pocito</asp:ListItem>
                                        <asp:ListItem Value="12">Rawson</asp:ListItem>
                                        <asp:ListItem Value="13">Rivadavia</asp:ListItem>
                                        <asp:ListItem Value="14">San Martin</asp:ListItem>
                                        <asp:ListItem Value="15">Santa Lucia</asp:ListItem>
                                        <asp:ListItem Value="16">Sarmiento</asp:ListItem>
                                        <asp:ListItem Value="17">Ullum</asp:ListItem>
                                        <asp:ListItem Value="18">Valle Fertil</asp:ListItem>
                                        <asp:ListItem Value="19">Zonda</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    CIRCUITO
                                    <asp:DropDownList ID="DDL_Circuito" runat="server" CssClass="form-control" AppendDataBoundItems="True" DataTextField="seccion" AutoPostBack="True">
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    ESCUELA
                                    <asp:DropDownList ID="DDL_Escuela" runat="server" CssClass="form-control" AppendDataBoundItems="True" DataTextField="seccion" AutoPostBack="True">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-md-12">
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">PORCENTAJE DE MESAS ESCRUTADAS</h3>
                        </div>
                        <div class="box-body">
                            <div style="margin: 0 auto">
                                <div id="container-mesas" style="width: 100%; height: 200px; float: left"></div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">PORCENTAJE DE VOTANTES DEL PADRON</h3>
                        </div>
                        <div class="box-body">
                            <div style="margin: 0 auto">
                                <div id="container-padron" style="width: 100%; height: 200px; float: left"></div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="clearfix"></div>
                <div class="col-md-6">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">SENADORES</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerSenadores"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">DIPUTADOS</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerDiputados"></div>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="col-md-6">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">COMPARACIÓN SENADORES CON PASO 2017</h3>
                        </div>
                        <div class="box-body">
                            <div id="container-comparacionSenadores" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">COMPARACIÓN DIPUTADOS CON PASO 2017</h3>
                        </div>
                        <div class="box-body">
                            <div id="container-comparacionDiputados" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        initScripts();
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            if (args.get_error() == undefined) {
                initScripts();
            }
        }

        function initScripts() {

            //while(chart.series.length > 0) chart.series[0].remove(true);
            var getColor = {
                'FrenteTodos': '#2469a8',
                'Cambiemos': '#eeff00',
                'UnPais': '#78288c',
                'Otros': '#c3c3c3'
            };

            Highcharts.chart('containerSenadores', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie',
                    height: 300
                },
                title: {
                    text: ''
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.x} <br/>({point.y:.2f} %)</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>:<br/>{point.x} votos <br/>({point.y:.2f} %)',
                            style: {
                                color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                        },
                    }
                },
                series: [{
                    name: 'Votos',
                    colorByPoint: true,
                    data: [<%=ObtenerDatosSenadores()%>]
                }]
            });

            Highcharts.chart('containerDiputados', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie',
                    height: 300
                },
                title: {
                    text: ''
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.x} <br/>({point.y:.2f} %)</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>:<br/>{point.x} votos <br/>({point.y:.2f} %)',
                            style: {
                                color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                        }
                    }
                },
                series: [{
                    name: 'Porcentaje',
                    colorByPoint: true,
                    data: [<%=ObtenerDatosDiputados()%>]
                }]
            });
            var gaugeOptions = {

                chart: {
                    type: 'solidgauge'
                },

                title: null,

                pane: {
                    center: ['50%', '85%'],
                    size: '140%',
                    startAngle: -90,
                    endAngle: 90,
                    background: {
                        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
                        innerRadius: '60%',
                        outerRadius: '100%',
                        shape: 'arc'
                    }
                },

                tooltip: {
                    enabled: false
                },

                // the value axis
                yAxis: {
                    stops: [
                        [0.1, '#DF5353'], // green
                        [0.5, '#DDDF0D'], // yellow
                        [0.9, '#55BF3B'] // red
                    ],
                    lineWidth: 0,
                    minorTickInterval: null,
                    tickAmount: 2,
                    title: {
                        y: -70
                    },
                    labels: {
                        y: 16
                    }
                },

                plotOptions: {
                    solidgauge: {
                        dataLabels: {
                            y: 5,
                            borderWidth: 0,
                            useHTML: true
                        }
                    }
                }
            };

            var chartMesas = Highcharts.chart('container-mesas', Highcharts.merge(gaugeOptions, {
                yAxis: {
                    min: 0,
                    max: 100,
                    title: {
                        text: '<%=tmp_MesasEscrutadas%> / <%=tmp_TotalMesas%>'
                    }
                },

                credits: {
                    enabled: false
                },

                series: [{
                    name: 'mesas',
                    data: [<%=PorcentajeDeMesaEscrutadas()%>],
                dataLabels: {
                    format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                        ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                           '<span style="font-size:12px;color:silver">%</span></div>'
                }
            }]
        }));

        var chartPadron = Highcharts.chart('container-padron', Highcharts.merge(gaugeOptions, {
            yAxis: {
                min: 0,
                max: 100,
                title: {
                    text: '<%=tmp_TotalVotantes%> / <%=tmp_TotalPadron%>'
                }
            },

            credits: {
                enabled: false
            },

            series: [{
                name: 'padron',
                //data: [73],
                data: [<%=PorcentajeVotantesPadron()%>],
                dataLabels: {
                    format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                        ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                           '<span style="font-size:12px;color:silver">%</span></div>'
                }
            }]
        }));

            //COMPARACIÓN CON PASO
            //Senadores
        Highcharts.chart('container-comparacionSenadores', {
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: [
                    'FrenteTodos',
                    'Cambiemos',
                    '1Pais',
                    'Otros'
                ],
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Cantidad de votos'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:20px;">{point.key}</span><table>',
                pointFormat: '<tr><td style="padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y} Votos</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [<%=ComparacionSenadores()%>]
        });
            //Diputados
        Highcharts.chart('container-comparacionDiputados', {
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: [
                    'FrenteTodos',
                    'Cambiemos',
                    '1Pais',
                    'Otros'
                ],
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Cantidad de votos'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:20px;">{point.key}</span><table>',
                pointFormat: '<tr><td style="padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y} Votos</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [<%=ComparacionDiputados()%>]
        });

    }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

