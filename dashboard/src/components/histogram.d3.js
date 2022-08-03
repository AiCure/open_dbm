import * as d3 from 'd3';
import { axisLeft, axisBottom } from "https://cdn.skypack.dev/d3-axis@3";
import "../index.css"
import $ from "jquery";
import DBMDict from '../DBM_attribute_dict.json'

export default class HistogramD3 {
    constructor(chart, data, attr, color, timeframe) {
        if (!d3.select(chart).select('svg').empty()) {
            d3.select(chart).select('svg').remove()
        }

        var parentContainer = attr.includes("fac_") ? document.getElementById("facialActivityContainer") :
            attr.includes("mov_") ? document.getElementById("headMovementContainer") :
                document.getElementById("voiceAcousticsContainer")

        var width = parentContainer.clientWidth > 600 ? parentContainer.clientWidth / 3.6 : parentContainer.clientWidth / 2
        var height = 70
        var marginLeft = 35

        const svg = d3.select(chart)
            .append('svg')
            .attr('width', width)
            .attr('height', height)

        var values = data.map(el => el[attr])

        var xScale = d3.scaleLinear()
            .domain([0, values.length - 1])
            .range([marginLeft, width - 5])

        var xAxis = axisBottom(xScale)
        xAxis.ticks(5)
        svg.append("g")
            .attr("transform", "translate(0," + (height - 20) + ")")
            .call(xAxis)

        var minVal = DBMDict[attr]['range'].length > 0 ? DBMDict[attr]['range'][0] : Math.min(...values)
        var maxVal = DBMDict[attr]['range'].length > 0 ? DBMDict[attr]['range'][1] : Math.max(...values)
        var yScale = d3.scaleLinear()
            .range([height - 20, 5])
            .domain([minVal, maxVal])


        var yAxis = axisLeft(yScale)
        yAxis.ticks(3)
        svg.append("g")
            .attr("transform", "translate(" + (marginLeft - 2) + ",0)")
            .call(yAxis)

        svg.append("path")
            .datum(values)
            .attr("fill", color[1])
            .attr("stroke", color[0])
            .attr("stroke-width", 1)
            .attr("d", d3.area()
                .x((d, i) => xScale(i))
                .y0(yScale(0))
                .y1(d => yScale(d))
            )

        // CHECK IF CORRECT
        var segmentLength = parseInt(values.length / 19)
        var valuesAux = values
        for (var t = 0; t < 20; t++) {
            svg.append("path")
                .datum(valuesAux.slice(0, segmentLength))
                .attr("class", "areaSegment areaSegment_" + (t + 1))
                .attr("fill", '#cb181d')
                .attr("stroke", "#fb6a4a")
                .attr("stroke-width", 0.5)
                .attr("opacity", 0)
                .attr("d", d3.area()
                    .x((d, i) => xScale(i + (t * segmentLength)))
                    .y0(yScale(0))
                    .y1(d => yScale(d))
                )
            valuesAux.splice(0, segmentLength)
        }
        if (parseInt(timeframe) !== 0) {
            $(".areaSegment").css("opacity", "0")
            $(`.areaSegment_${parseInt(timeframe)}`).css("opacity", "1")
        }
    }


}