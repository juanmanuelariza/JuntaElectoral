<%@ Page Title="" Language="VB" MasterPageFile="~/reportes/MasterPageReportes.master" AutoEventWireup="false" CodeFile="mapas.aspx.vb" Inherits="mapas_aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="js/jquery/jquery.js"></script>
    <script src="js/highcharts/highcharts.js"></script>
    <script src="js/highcharts/map.js"></script>
    <script src="js/highcharts/exporting.js"></script>
    <script src="js/SanJuanTodos.js"></script>
    <style type="text/css">
        #containerSenadores, #containerDiputados {
            margin: 1em auto;
        }

        .highcharts-container {
            height: 100% !important;
            width: 100% !important;
        }
    </style>
    <asp:ScriptManager runat="server" EnablePartialRendering="true" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:Panel ID="Panel1" runat="server">
                <%--  <asp:Timer ID="Timer1" runat="server" Interval="30000">
                </asp:Timer>--%>
                <%-- <div class="col-md-12">
                    <div class="col-md-6">--%>
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
                <%-- </div>
                    <div class="col-md-6">--%>
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

                <%--    </div>                    
                </div>--%>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        // New map-pie series type that also allows lat/lon as center option.
        // Also adds a sizeFormatter option to the series, to allow dynamic sizing
        // of the pies.
        Highcharts.seriesType('mappie', 'pie', {
            center: null, // Can't be array by default anymore
            clip: true, // For map navigation
            states: {
                hover: {
                    halo: {
                        size: 5
                    }
                }
            },
            dataLabels: {
                enabled: false
            }
        }, {
            getCenter: function () {
                var options = this.options,
                    chart = this.chart,
                    slicingRoom = 2 * (options.slicedOffset || 0);
                if (!options.center) {
                    options.center = [null, null]; // Do the default here instead
                }
                // Handle lat/lon support
                if (options.center.lat !== undefined) {
                    var point = chart.fromLatLonToPoint(options.center);
                    options.center = [
                        chart.xAxis[0].toPixels(point.x, true),
                        chart.yAxis[0].toPixels(point.y, true)
                    ];
                }
                // Handle dynamic size
                if (options.sizeFormatter) {
                    options.size = options.sizeFormatter.call(this);
                }
                // Call parent function
                var result = Highcharts.seriesTypes.pie.prototype.getCenter.call(this);
                // Must correct for slicing room to get exact pixel pos
                result[0] -= slicingRoom;
                result[1] -= slicingRoom;
                return result;
            },
            translate: function (p) {
                this.options.center = this.userOptions.center;
                this.center = this.getCenter();
                return Highcharts.seriesTypes.pie.prototype.translate.call(this, p);
            }
        });


        //var SenadoresData = [
        //        // state, CambiemosVotos, TodosVotos, UnpaisVotos, grnVotes, sumVotes, winner, offset config for pies
        //        ['Sarmiento', 3054536454, 1318255, 44467, 9391, 2101660, 0],
        //        ['25 de Mayo', 729547, 1318255, 44467, 9391, 2101660, 0],
        //        ['Caucete', 116454, 163387, 18725, 5735, 304301, 3],
        //        ['Valle Fertil', 1161167, 1252401, 106327, 34345, 2554240, 0],
        //        ['Jachal', 380494, 684782, 29829, 9473, 1104578, 0],
        //        ['Angaco', 8577206, 4390272, 467370, 271047, 13705895, 1],
        //        ['San Martin', 1338870, 1202484, 144121, 38437, 2723912, 1],
        //        ['Albardon', 897572, 673215, 48676, 22841, 1642304, 2],
        //        ['Ullum', 235603, 185127, 14757, 6103, 441590, 1],
        //        ['Zonda', 282830, 12723, 4906, 4258, 304717, 1],
        //        ['Iglesia', 4504975, 4617886, 207043, 64399, 9394303, 2],
        //        ['Calingasta', 1877963, 2089104, 125306, 0, 4092373, 0],
        //        ['Pocito', 266891, 128847, 15954, 12737, 424429, 0],
        //        ['Rivadavia', 189765, 409055, 28331, 8496, 635647, 0],
        //        ['Rawson', 2977498, 2118179, 208682, 74112, 5378471, 1],
        //        ['9 de Julio', 1039126, 1557286, 133993, 7841, 2738246, 0],
        //        ['Santa Lucia', 653669, 800983, 59186, 11479, 1525317, 0],
        //        ['Capital', 427005, 671018, 55406, 23506, 1176935, 0],
        //        ['Chimbas', 628854, 1202971, 53752, 13913, 1899490, 0],
        //],
        var SenadoresData = [ <%=ObtenerDatosSenadores() %>],
            maxVotes = 0,
            TodosColor = 'rgba(36, 105, 168,0.90)',
            CambiemosColor = 'rgba(240,240,0,0.70)',
            UnpaisColor = 'rgba(120,40,140,0.70)',
            OtrosColor = 'rgba(156,156,156,0.70)';


        // Compute max votes to find relative sizes of bubbles
        Highcharts.each(SenadoresData, function (row) {
            maxVotes = Math.max(maxVotes, row[5]);
        });

        // Build the chart
        var chart = Highcharts.mapChart('containerSenadores', {
            title: {
                text: ''
            },

            chart: {
                animation: true // Disable animation, especially for zooming
            },

            colorAxis: {
                dataClasses: [{
                    from: 0,
                    to: 0,
                    color: TodosColor,
                    name: 'Todos'
                }, {
                    from: 1,
                    to: 1,
                    color: CambiemosColor,
                    name: 'Cambiemos'
                }, {
                    from: 2,
                    to: 3,
                    name: 'Un Pais',
                    color: UnpaisColor
                }, {
                    from: 3,
                    to: 4,
                    name: 'Otros',
                    color: OtrosColor
                }]
            },

            mapNavigation: {
                enabled: true
            },
            // Limit zoom range
            yAxis: {
                minRange: 200
            },

            tooltip: {
                useHTML: true
            },

            // Default options for the pies
            plotOptions: {
                mappie: {
                    borderColor: 'rgba(255,255,255,0.4)',
                    borderWidth: 1,
                    tooltip: {
                        headerFormat: ''
                    }
                }
            },

            series: [{
                mapData: Highcharts.maps['countries/ar/sj-all'],
                data: SenadoresData,
                name: 'States',
                borderColor: '#FFF',
                showInLegend: false,
                joinBy: ['name', 'id'],
                keys: ['id', 'TodosVotos', 'CambiemosVotos', 'UnpaisVotos', 'OtrosVotos',
                    'sumVotes', 'value', 'pieOffset'],
                tooltip: {
                    headerFormat: '',
                    pointFormatter: function () {
                        var hoverVotes = this.hoverVotes; // Used by pie only
                        return '<b>Votos de ' + this.id + '</b><br/>' +
                            Highcharts.map([
                                ['Todos', this.TodosVotos, TodosColor, this.sumVotes],
                                ['Cambiemos', this.CambiemosVotos, CambiemosColor, this.sumVotes],
                                ['Un Pais', this.UnpaisVotos, UnpaisColor, this.sumVotes],
                                ['Otros', this.OtrosVotos, OtrosColor, this.sumVotes]
                            ].sort(function (a, b) {
                                return b[1] - a[1]; // Sort tooltip by most votes
                            }), function (line) {
                                return '<span style="color:' + line[2] +
                                    // Colorized bullet
                                    '">\u25CF</span> ' +
                                    // Party and votes
                                    (line[0] === hoverVotes ? '<b>' : '') +
                                    line[0] + ': ' +
                                    (Math.round((line[1] * 100 / line[3]) * 100) / 100) + '%' +
                                    (line[0] === hoverVotes ? '</b>' : ' (' + Highcharts.numberFormat(line[1], 0) + ')') +
                                    '<br/>';
                            }).join('') +
                            '<hr/>Total de votantes: ' + Highcharts.numberFormat(this.sumVotes, 0);
                    }
                }
            }, {
                name: 'Separators',
                type: 'mapline',
                data: Highcharts.geojson(Highcharts.maps['countries/ar/sj-all'], 'mapline'),
                color: '#707070',
                showInLegend: false,
                enableMouseTracking: false
            }, {
                name: 'Connectors',
                type: 'mapline',
                color: 'rgba(130, 130, 130, 0.5)',
                zIndex: 5,
                showInLegend: false,
                enableMouseTracking: false
            }]
        });




        var DiputadosData = [ <%=ObtenerDatosDiputados() %>],
    maxVotes = 0,
    TodosColor = 'rgba(36, 105, 168,0.90)',
    CambiemosColor = 'rgba(240,240,0,0.70)',
    UnpaisColor = 'rgba(120,40,140,0.70)',
    OtrosColor = 'rgba(156,156,156,0.70)';

// Compute max votes to find relative sizes of bubbles
Highcharts.each(DiputadosData, function (row) {
    maxVotes = Math.max(maxVotes, row[5]);
});

// Build the chart
var chart = Highcharts.mapChart('containerDiputados', {
    title: {
        text: ''
    },

    chart: {
        animation: true // Disable animation, especially for zooming
    },

    colorAxis: {
        dataClasses: [{
            from: 0,
            to: 0,
            color: TodosColor,
            name: 'Todos'
        }, {
            from: 1,
            to: 1,
            color: CambiemosColor,
            name: 'Cambiemos'
        }, {
            from: 2,
            to: 3,
            name: 'Un Pais',
            color: UnpaisColor
        }, {
            from: 3,
            to: 4,
            name: 'Otros',
            color: OtrosColor
        }]
    },

    mapNavigation: {
        enabled: true
    },
    // Limit zoom range
    yAxis: {
        minRange: 200
    },

    tooltip: {
        useHTML: true
    },

    // Default options for the pies
    plotOptions: {
        mappie: {
            borderColor: 'rgba(255,255,255,0.4)',
            borderWidth: 1,
            tooltip: {
                headerFormat: ''
            }
        }
    },

    series: [{
        mapData: Highcharts.maps['countries/ar/sj-all'],
        data: DiputadosData,
        name: 'States',
        borderColor: '#FFF',
        showInLegend: false,
        joinBy: ['name', 'id'],
        keys: ['id', 'TodosVotos', 'CambiemosVotos', 'UnpaisVotos', 'OtrosVotos',
            'sumVotes', 'value', 'pieOffset'],
        tooltip: {
            headerFormat: '',
            pointFormatter: function () {
                var hoverVotes = this.hoverVotes; // Used by pie only
                return '<b>Votos de ' + this.id + '</b><br/>' +
                    Highcharts.map([
                        ['Todos', this.TodosVotos, TodosColor, this.sumVotes],
                        ['Cambiemos', this.CambiemosVotos, CambiemosColor, this.sumVotes],
                        ['Un Pais', this.UnpaisVotos, UnpaisColor, this.sumVotes],
                        ['Otros', this.OtrosVotos, OtrosColor, this.sumVotes]
                    ].sort(function (a, b) {
                        return b[1] - a[1]; // Sort tooltip by most votes
                    }), function (line) {
                        return '<span style="color:' + line[2] +
                            // Colorized bullet
                            '">\u25CF</span> ' +
                            // Party and votes
                            (line[0] === hoverVotes ? '<b>' : '') +
                            line[0] + ': ' +
                            (Math.round((line[1] * 100 / line[3]) * 100) / 100) + '%' +
                            (line[0] === hoverVotes ? '</b>' : ' (' + Highcharts.numberFormat(line[1], 0) + ')') +
                            '<br/>';
                    }).join('') +
                    '<hr/>Total de votantes: ' + Highcharts.numberFormat(this.sumVotes, 0);
            }
        }
    }, {
        name: 'Separators',
        type: 'mapline',
        data: Highcharts.geojson(Highcharts.maps['countries/ar/sj-all'], 'mapline'),
        color: '#707070',
        showInLegend: false,
        enableMouseTracking: false
    }, {
        name: 'Connectors',
        type: 'mapline',
        color: 'rgba(130, 130, 130, 0.5)',
        zIndex: 5,
        showInLegend: false,
        enableMouseTracking: false
    }]
});


    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

