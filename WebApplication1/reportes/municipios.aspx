<%@ Page Title="" Language="VB" MasterPageFile="~/reportes/MasterPageReportes.master" AutoEventWireup="false" CodeFile="municipios.aspx.vb" Inherits="municipios_aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="js/highcharts/highcharts.js"></script>
    <script src="js/highcharts/highcharts-more.js"></script>
    <script src="js/highcharts/solid-gauge.js"></script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="Panel1" runat="server">
                <%--<asp:Timer ID="Timer1" runat="server" Interval="30000"></asp:Timer>--%>
                
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">PORCENTAJE DE MESAS ESCRUTADAS CAPITAL</h3>
                        </div>
                        <div class="box-body">
                            <div style="margin: 0 auto">
                                <div id="container-mesasCapital" style="width: 100%; height: 200px; float: left"></div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">SENADORES CAPITAL</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerSenadoresCapital"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">DIPUTADOS CAPITAL</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerDiputadosCapital"></div>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">PORCENTAJE DE MESAS ESCRUTADAS RIVADAVIA</h3>
                        </div>
                        <div class="box-body">
                            <div style="margin: 0 auto">
                                <div id="container-mesasRivadavia" style="width: 100%; height: 200px; float: left"></div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">SENADORES RIVADAVIA</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerSenadoresRivadavia"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">DIPUTADOS RIVADAVIA</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerDiputadosRivadavia"></div>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">PORCENTAJE DE MESAS ESCRUTADAS SANTA LUCIA</h3>
                        </div>
                        <div class="box-body">
                            <div style="margin: 0 auto">
                                <div id="container-mesasSantaLucia" style="width: 100%; height: 200px; float: left"></div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">SENADORES SANTA LUCIA </h3>
                        </div>
                        <div class="box-body">
                            <div id="containerSenadoresSantaLucia"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">DIPUTADOS SANTA LUCIA</h3>
                        </div>
                        <div class="box-body">
                            <div id="containerDiputadosSantaLucia"></div>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">MESAS FALTANTES</h3>
                        </div>
                        <div class="box-body">
                            <table id="dtFaltantes" class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>Mesa</th>
                                        <th>Estrato</th>
                                        <th>Departamento</th>
                                        <th>Circuito</th>
                                        <th>Escuela</th>
                                    </tr>
                                </thead>
                                <%=tmp_TablaMesasFaltantes %>
                            </table>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
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
            $(function () {
                $('#dtFaltantes').DataTable({
                    "responsive": true,
                    "paging": true,
                    "lengthChange": true,
                    "searching": true,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false,
                    "language": DataTableEsp(),
                    responsive: true
                });
            });
            //while(chart.series.length > 0) chart.series[0].remove(true);
            var getColor = {
                'FrenteTodos': '#2469a8',
                'Cambiemos': '#eeff00',
                'UnPais': '#78288c',
                'Otros': '#c3c3c3'
            };

            Highcharts.chart('containerSenadoresCapital', {
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
                    data: [<%=ObtenerDatosSenadores(6)%>]
                }]
            });

            Highcharts.chart('containerDiputadosCapital', {
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
                    data: [<%=ObtenerDatosDiputados(6)%>]
                }]
            });

            Highcharts.chart('containerSenadoresRivadavia', {
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
                    data: [<%=ObtenerDatosSenadores(13)%>]
                }]
            });

            Highcharts.chart('containerDiputadosRivadavia', {
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
                    data: [<%=ObtenerDatosDiputados(13)%>]
                }]
            });

            Highcharts.chart('containerSenadoresSantaLucia', {
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
                    data: [<%=ObtenerDatosSenadores(15)%>]
                }]
            });

            Highcharts.chart('containerDiputadosSantaLucia', {
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
                    data: [<%=ObtenerDatosDiputados(15)%>]
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

            Highcharts.chart('container-mesasCapital', Highcharts.merge(gaugeOptions, {
                yAxis: {
                    min: 0,
                    max: 100,
                    title: {
                        text: '<%=tmp_MesasEscrutadasCapital%> / <%=tmp_TotalMesasCapital%>'
                    }
                },

                credits: {
                    enabled: false
                },

                series: [{
                    name: 'mesas',
                    data: [<%=PorcentajeDeMesaEscrutadas(6)%>],
                    dataLabels: {
                        format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                            ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                               '<span style="font-size:12px;color:silver">%</span></div>'
                    }
                }]
            }));

            Highcharts.chart('container-mesasRivadavia', Highcharts.merge(gaugeOptions, {
                yAxis: {
                    min: 0,
                    max: 100,
                    title: {
                        text: '<%=tmp_MesasEscrutadasRivadiva%> / <%=tmp_TotalMesasRivadiva%>'
                    }
                },

                credits: {
                    enabled: false
                },

                series: [{
                    name: 'mesas',
                    data: [<%=PorcentajeDeMesaEscrutadas(13)%>],
                    dataLabels: {
                        format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                            ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                               '<span style="font-size:12px;color:silver">%</span></div>'
                    }
                }]
            }));

            Highcharts.chart('container-mesasSantaLucia', Highcharts.merge(gaugeOptions, {
                yAxis: {
                    min: 0,
                    max: 100,
                    title: {
                        text: '<%=tmp_MesasEscrutadasSantaLucia%> / <%=tmp_TotalMesasSantaLucia%>'
                    }
                },

                credits: {
                    enabled: false
                },

                series: [{
                    name: 'mesas',
                    data: [<%=PorcentajeDeMesaEscrutadas(15)%>],
                    dataLabels: {
                        format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                            ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                               '<span style="font-size:12px;color:silver">%</span></div>'
                    }
                }]
            }));
            function DataTableEsp() {
                var lenguaje = {
                    "sProcessing": "Procesando...",
                    "sLengthMenu": "Mostrar _MENU_ registros",
                    "sZeroRecords": "No se encontraron resultados",
                    "sEmptyTable": "Ningun dato disponible en esta tabla",
                    "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                    "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                    "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
                    "sInfoPostFix": "",
                    "sSearch": "Buscar:",
                    "sUrl": "",
                    "sInfoThousands": ",",
                    "sLoadingRecords": "Cargando...",
                    "oPaginate": {
                        "sFirst": "Primero",
                        "sLast": "Último",
                        "sNext": "Siguiente",
                        "sPrevious": "Anterior"
                    },
                    "oAria": {
                        "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                    }
                };

                return lenguaje;
            }
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

