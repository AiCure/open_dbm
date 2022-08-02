import * as d3 from 'd3';
import "../index.css"
import DBMDict from "../DBM_attribute_dict.json"

export default class SpiderChartD3 {
    constructor(chart, derivedData, timelineData, timeframe, levels, axes) {
        if (!d3.select(chart).select('svg').empty()) {
            d3.select(chart).select('svg').remove()
        }

        var width = 140
        var height = 140
        const radius = Math.min((width - 5) / 2, (height - 5) / 2)
        const totalAxes = axes.length
        const radians = 2 * Math.PI
        var vertices = []
        var values = null

        const svg = d3.select(chart)
            .append('svg')
            .attr('width', width)
            .attr('height', height)
        const g = svg.append("g")
            .attr("transform", "translate(0,5)")

        if (Object.keys(derivedData).length === 0) {
            return
        }
        if (parseInt(timeframe) === 0) {
            values = Object.keys(derivedData)
                .reduce((obj, key) => {
                    if (axes.includes(key)) {
                        obj[key] = derivedData[key]
                    }
                    return obj
                }, {})
        }
        else {
            axes = axes.map(a => a.replace("_mean", ""))
            values = Object.keys(timelineData)
                .reduce((obj, key) => {
                    if (axes.includes(key)) {
                        obj[key] = timelineData[key][parseInt(timeframe) - 1]
                    }
                    return obj
                }, {})
        }

        for (var level = 0; level < levels.length - 1; level++) {
            var levelFactor = radius * ((level + 1) / levels.length);
            for (var i = 0; i < axes.length; i++) {
                g.append("line").attr("class", "level_line")
                    .attr("x1", levelFactor * (1 - Math.sin(i * radians / totalAxes)))
                    .attr("y1", levelFactor * (1 - Math.cos(i * radians / totalAxes)))
                    .attr("x2", levelFactor * (1 - Math.sin((i + 1) * radians / totalAxes)))
                    .attr("y2", levelFactor * (1 - Math.cos((i + 1) * radians / totalAxes)))
                    .attr("transform", "translate(" + ((width - 2) / 2 - levelFactor) + ", " + ((height - 2) / 2 - levelFactor) + ")")
                    .attr("stroke", "#dedede")
                    .attr("stroke-width", "0.5px");
                if (i === 1) {
                    g
                        .append("svg:text").classed("level-labels", true)
                        .text(levels[level + 1])
                        .attr("x", levelFactor * (1 - Math.sin(0)))
                        .attr("y", levelFactor * (1 - Math.cos(0)))
                        .attr("transform", "translate(" + ((width - 2) / 2 - levelFactor + 2) + ", " + ((height - 2) / 2 - levelFactor) + ")")
                        .attr("fill", "grey")
                        .attr("font-size", "0.6rem")
                }
            }
        }
        axes.forEach((a, i) => {
            g.append("line").classed("axis-lines", true)
                .attr("x1", (width - 2) / 2)
                .attr("y1", (height - 2) / 2)
                .attr("x2", (width - 2) / 2 * (1 - Math.sin(i * radians / totalAxes)))
                .attr("y2", (height - 2) / 2 * (1 - Math.cos(i * radians / totalAxes)))
                .attr("stroke", "#dedede")
                .attr("stroke-width", "1px");

            g
                .append("text")
                .text(DBMDict[a]['label'].replace("intsoft", "").replace("_mean", "").replace("int", ""))
                .attr("text-anchor", "middle")
                .attr("x", () => {
                    var rez = width / 2 * (1 - Math.sin(i * radians / totalAxes))
                    if (rez < width/2.2) return rez +10
                    else return rez - 10
                    })
                .attr("y", () => {
                    var rez = height / 2 * (1 - Math.cos(i * radians / totalAxes))
                    if (rez < height/2.2) return rez +5
                    else return rez - 5
                    })
                
                    
                .attr("font-size", "0.6rem");
        })

        axes.forEach((a, i) => {
            var x = (width - 2) / 2 * (1 - (parseFloat(Math.max(values[a], 0)) / Math.max(...levels)) * Math.sin(i * radians / totalAxes))
            var y = (height - 2) / 2 * (1 - (parseFloat(Math.max(values[a], 0)) / Math.max(...levels)) * Math.cos(i * radians / totalAxes))
            g.append("circle")
                .attr("r", 1)
                .attr("cx", x)
                .attr("cy", y)
                .attr("fill", "green")
            vertices.push([x, y])
        });

        g.append("polygon")
            .attr("points", vertices)
            .attr("stroke-width", "2px")
            .attr("stroke", "green")
            .attr("fill", "green")
            .attr("fill-opacity", 0.5)
            .attr("stroke-opacity", 0.3)

    }
}
