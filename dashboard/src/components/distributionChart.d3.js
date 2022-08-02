import * as d3 from 'd3';
import $ from "jquery";
import "../index.css";
import DBMDict from '../DBM_attribute_dict.json'

export default class DistributionChart {

    constructor(chart, data, attr, filteredIds, metadata, hideIds, metadataAttrColor) {
        if (!d3.select(chart).select('svg').empty()) {
            d3.select(chart).select('svg').remove()
        }

        var parentContainer = document.getElementById("distributionChartContainer")
        var width = parentContainer.clientWidth / 2.8
        var height = parentContainer.clientHeight / 3.5

        const svg = d3.select(chart)
            .append('svg')
            .attr('width', width)
            .attr('height', height)
            .append("g")

        var jitterWidth = width / 8

        const values = Object.values(data).map(el => el[attr])
        const keys = Object.keys(data)


        const inputObject = Object.values(data).map(el => [el['id'], el[attr]])


        var metadataDict = {}
        if (metadata.length > 0) {
            var metadataAttr = [...new Set(Object.values(metadata).map(el => el['attr']).filter(e => e != null))]
            var metadataColor = d3.scaleOrdinal().domain(metadataAttr)
                .range(["gold", "blue"])
            var d = Object.values(metadata).map(el => [el['id'], el['attr']])
            d.forEach(el => {
                metadataDict[el[0]] = el[1]
            })
        }

        var yScale = d3.scaleLinear()
            .domain([Math.min(...values), Math.max(...values)])
            .range([height - 30, 20])
        svg.append("g")
            .attr("transform", "translate(40 ,0)")
            .attr("class", "greyAxis")
            .call(d3.axisLeft(yScale))

        var xScale = d3.scaleBand()
            .range([1, width - 20])
            .domain([attr])
            .padding(0.05)
        svg.append("g")
            .attr("transform", "translate(40," + (height - 30) + ")")
            .attr("class", "greyAxis")
            .call(d3.axisBottom(xScale))
            .call(s => s.selectAll("text").attr("dx", "-30").attr("y", "10").text(DBMDict[attr]['label']))

        var histogram = d3.bin()
            .domain(yScale.domain())
            .thresholds(yScale.ticks(20))
            .value(d => d)

        var sumstat = [{ "key": attr, "value": histogram(values) }]

        var binLens = sumstat[0].value.map(l => l.length)

        var xNum = d3.scaleLinear()
            .range([0, xScale.bandwidth()])
            .domain([-Math.max(...binLens), Math.max(...binLens)])

        svg.selectAll("distr")
            .data(sumstat)
            .enter()
            .append("g")
            .attr("transform", d => "translate(" + xScale(d.key) + " ,0)")
            .append("path")
            .datum(d => d.value)
            .style("stroke", "none")
            .style("fill", "#e7d4e8")
            .attr("d", d3.area()
                .x0(xNum(-0.01) + xScale.bandwidth() / 10)
                .x1(d => (xNum(d.length)) + xScale.bandwidth() / 10)
                .y(d => Math.abs(d.x0) !== Infinity ? yScale(d.x0) : yScale(0))
                .curve(d3.curveCatmullRom)
            )
        d3.selectAll(".tick line").attr("opacity", 0)

        svg.selectAll("indPoints")
            .data(inputObject)
            .enter()
            .append("circle")
            .attr("id", d => d[0] + "_distr_" + attr)
            .attr("class", d => "dot dotDistr dot_" + d[0])
            .attr("cx", d => (xScale(attr) + xScale.bandwidth() / 2 - Math.random() * jitterWidth - 5))
            .attr("cy", d => yScale(d[1]))
            .attr("r", 5.5)
            .style("fill", d => filteredIds.includes(d[0]) ? "red" : (metadataDict[d[0]] ? metadataAttrColor[d[0]] : "#69b3a2"))
            .style("opacity", d => filteredIds.includes(d[0]) ? "0.4" : hideIds ? "0" : "0.4")
            .attr("stroke", "grey")
            .attr("stroke-width", '1.5px')
            .on("mouseover", d => {
                var className = "dot_" + d.target.id.replace("_distr_" + attr, "")
                d3.selectAll("." + className).style("fill", "red")
                $("#" + d.target.id.replace("_distr_" + attr, "") + "_id_container").css("color", "#fc6a03")
                keys.forEach(k => {
                    if ($('#' + k + "_id").is(":checked"))
                        $(".dot_" + k).css("fill", "red")
                })
            })
            .on("mouseout", d => {
                keys.forEach(k => {
                    $(".dot_" + k).css("fill", filteredIds.includes(k) ? "red" : (metadataDict[k] ? metadataAttrColor[k] : "#69b3a2"))
                    if ($('#' + k + "_id").is(":checked")) {
                        $(".dot_" + k).css("fill", "red")
                    }
                })
                $(".id_checkbox_container").css("color", "black")
            })
            .append("title")
            .text(d => "ID: " + String(d[0]) + "\n" + "Value: " + d[1])



    }
}