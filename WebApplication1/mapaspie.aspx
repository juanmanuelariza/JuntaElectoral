﻿<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="mapas.aspx.vb" Inherits="mapas_aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.3.15/proj4.js"></script>
        <script src="js/jquery/jquery.js"></script>
    <script src="js/highcharts/highcharts.js"></script>
<script src="js/highcharts/map.js"></script>
<script src="js/highcharts/exporting.js"></script>
<script src="js/SJ.js"></script>
    <style type="text/css">
     #container {
    min-width: 320px;
    max-width: 800px;
    height: 500px;
    margin: 1em auto;
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
                        <div id="containerSenadores"></div>
                   <%-- </div>
                    <div class="col-md-6">--%>
                        <div id="containerDiputados"></div>
<div id="container"></div>
                <%--    </div>                    
                </div>--%>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>

<script type="text/javascript">// New map-pie series type that also allows lat/lon as center option.
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


    var data = [
            // state, demVotes, repVotes, libVotes, grnVotes, sumVotes, winner, offset config for pies
            ['Mendoza', 729547, 1318255, 44467, 9391, 2101660, -1]
    ],
        maxVotes = 0,
        demColor = 'rgba(74,131,240,0.80)',
        repColor = 'rgba(220,71,71,0.80)',
        libColor = 'rgba(240,190,50,0.80)',
        grnColor = 'rgba(90,200,90,0.80)';


    // Compute max votes to find relative sizes of bubbles
    Highcharts.each(data, function (row) {
        maxVotes = Math.max(maxVotes, row[5]);
    });

    // Build the chart
    var chart = Highcharts.mapChart('container', {
        title: {
            text: 'USA 2016 Presidential Election Results'
        },

        chart: {
            animation: false // Disable animation, especially for zooming
        },

        colorAxis: {
            dataClasses: [{
                from: -1,
                to: 0,
                color: 'rgba(244,91,91,0.5)',
                name: 'Republican'
            }, {
                from: 0,
                to: 1,
                color: 'rgba(124,181,236,0.5)',
                name: 'Democrat'
            }, {
                from: 2,
                to: 3,
                name: 'Libertarian',
                color: libColor
            }, {
                from: 3,
                to: 4,
                name: 'Green',
                color: grnColor
            }]
        },

        mapNavigation: {
            enabled: true
        },
        // Limit zoom range
        yAxis: {
            minRange: 2300
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
            mapData: Highcharts.maps['countries/ar/ar-all'],
            data: data,
            name: 'States',
            borderColor: '#FFF',
            showInLegend: false,
            joinBy: ['name', 'id'],
            keys: ['id', 'demVotes', 'repVotes', 'libVotes', 'grnVotes',
                'sumVotes', 'value', 'pieOffset'],
            tooltip: {
                headerFormat: '',
                pointFormatter: function () {
                    var hoverVotes = this.hoverVotes; // Used by pie only
                    return '<b>' + this.id + ' votes</b><br/>' +
                        Highcharts.map([
                            ['Democrats', this.demVotes, demColor],
                            ['Republicans', this.repVotes, repColor],
                            ['Libertarians', this.libVotes, libColor],
                            ['Green', this.grnVotes, grnColor]
                        ].sort(function (a, b) {
                            return b[1] - a[1]; // Sort tooltip by most votes
                        }), function (line) {
                            return '<span style="color:' + line[2] +
                                // Colorized bullet
                                '">\u25CF</span> ' +
                                // Party and votes
                                (line[0] === hoverVotes ? '<b>' : '') +
                                line[0] + ': ' +
                                Highcharts.numberFormat(line[1], 0) +
                                (line[0] === hoverVotes ? '</b>' : '') +
                                '<br/>';
                        }).join('') +
                        '<hr/>Total: ' + Highcharts.numberFormat(this.sumVotes, 0);
                }
            }
        }, {
            name: 'Separators',
            type: 'mapline',
            data: Highcharts.geojson(Highcharts.maps['countries/ar/ar-all'], 'mapline'),
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

    // When clicking legend items, also toggle connectors and pies
    Highcharts.each(chart.legend.allItems, function (item) {
        var old = item.setVisible;
        item.setVisible = function () {
            var legendItem = this;
            old.call(legendItem);
            Highcharts.each(chart.series[0].points, function (point) {
                if (chart.colorAxis[0].dataClasses[point.dataClass].name === legendItem.name) {
                    // Find this state's pie and set visibility
                    Highcharts.find(chart.series, function (item) {
                        return item.name === point.id;
                    }).setVisible(legendItem.visible, false);
                    // Do the same for the connector point if it exists
                    var connector = Highcharts.find(chart.series[2].points, function (item) {
                        return item.name === point.id;
                    });
                    if (connector) {
                        connector.setVisible(legendItem.visible, false);
                    }
                }
            });
            chart.redraw();
        };
    });

    // Add the pies after chart load, optionally with offset and connectors
    Highcharts.each(chart.series[0].points, function (state) {
        if (!state.id) {
            return; // Skip points with no data, if any
        }

        var pieOffset = state.pieOffset || {},
            centerLat = parseFloat(state.properties.latitude),
            centerLon = parseFloat(state.properties.longitude);

        // Add the pie for this state
        chart.addSeries({
            type: 'mappie',
            name: state.id,
            zIndex: 6, // Keep pies above connector lines
            sizeFormatter: function () {
                var yAxis = this.chart.yAxis[0],
                    zoomFactor = (yAxis.dataMax - yAxis.dataMin) /
                        (yAxis.max - yAxis.min);
                return Math.max(
                    this.chart.chartWidth / 45 * zoomFactor, // Min size
                    this.chart.chartWidth / 11 * zoomFactor * state.sumVotes / maxVotes
                );
            },
            tooltip: {
                // Use the state tooltip for the pies as well
                pointFormatter: function () {
                    return state.series.tooltipOptions.pointFormatter.call({
                        id: state.id,
                        hoverVotes: this.name,
                        demVotes: state.demVotes,
                        repVotes: state.repVotes,
                        libVotes: state.libVotes,
                        grnVotes: state.grnVotes,
                        sumVotes: state.sumVotes
                    });
                }
            },
            data: [{
                name: 'Democrats',
                y: state.demVotes,
                color: demColor
            }, {
                name: 'Republicans',
                y: state.repVotes,
                color: repColor
            }, {
                name: 'Libertarians',
                y: state.libVotes,
                color: libColor
            }, {
                name: 'Green',
                y: state.grnVotes,
                color: grnColor
            }],
            center: {
                lat: centerLat + (pieOffset.lat || 0),
                lon: centerLon + (pieOffset.lon || 0)
            }
        }, false);

        // Draw connector to state center if the pie has been offset
        if (pieOffset.drawConnector !== false) {
            var centerPoint = chart.fromLatLonToPoint({
                lat: centerLat,
                lon: centerLon
            }),
                offsetPoint = chart.fromLatLonToPoint({
                    lat: centerLat + (pieOffset.lat || 0),
                    lon: centerLon + (pieOffset.lon || 0)
                });
            chart.series[2].addPoint({
                name: state.id,
                path: 'M' + offsetPoint.x + ' ' + offsetPoint.y +
                    'L' + centerPoint.x + ' ' + centerPoint.y
            }, false);
        }
    });
    // Only redraw once all pies and connectors have been added
    chart.redraw();


</script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

