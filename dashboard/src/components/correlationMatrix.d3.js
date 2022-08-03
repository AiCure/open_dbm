import * as d3 from 'd3';
import $ from "jquery";
import "../index.css"

export default class CorrelationMatrixD3 {
    constructor(chart, data, parentId) {
        if (!d3.select(chart).select('svg').empty()) {
            d3.select(chart).select('svg').remove()
        }
        var parentContainer = document.getElementById(parentId)
        var width = parentContainer.clientWidth
        var height = parentContainer.clientHeight
        const svg = d3.select(chart)
            .append('svg')
            .attr('width', width)
            .attr('height', height)

        var values = Object.values(data).map(el => Object.values(el))
        var keys = Object.keys(data).map(e => e.replace("aco_", "").replace("fac_", "").replace("mov_", ""))

        const minRowValue = values.map(el => Math.min(...(el)))
        const maxRowValue = values.map(el => Math.max(...(el)))
        const minValue = Math.min(...(minRowValue))
        const maxValue = Math.max(...(maxRowValue))
        const colorScale = d3.scaleLinear().domain([minValue, 0, maxValue]).range(["#fdae61", "#f7f7f7", "#67a9cf"])

        var xScale = d3.scaleBand()
            .domain(keys).range([80, width - 20])
            .paddingInner(.2)
        var yScale = d3.scaleBand()
            .domain(keys).range([height - 80, 10])
            .paddingInner(.2)

        svg.append("g")
            .attr("transform", "translate(0," + (height - 70) + ")")
            .attr("class", "greyAxis")

            .call(d3.axisBottom(xScale))
            .selectAll("text")
            .style("text-anchor", "end")
            .attr("dx", "-.8em")
            .attr("dy", ".15em")
            .attr("transform", "rotate(-45)")

        svg.append("g")
            .attr("transform", "translate(" + 80 + "," + 10 + " )")
            .attr("class", "greyAxis")
            .call(d3.axisLeft(yScale))

        values.forEach((row, i) => {
            row.forEach((el, j) => {
                if (j >= i)
                    svg.append("rect")
                        .attr("id", "corr_" + keys[j] + "_" + keys[i])
                        .attr("x", xScale(keys[i]) + 2)
                        .attr("y", yScale(keys[j]) + 5)
                        .attr("width", xScale.bandwidth())
                        .attr("height", yScale.bandwidth())
                        .style("fill", d => colorScale(el))
                        .style("opacity", 0.8)
                        .on("mouseover", d => {
                            $("#" + d.target.id).css("stroke", "black")
                                .css("stroke-width", '2px')
                        })
                        .on("mouseout", d => {
                            $("#" + d.target.id).css("stroke-width", '0px')
                        })
                        .append("title")
                        .text(d => keys[j] + " & " + keys[i] + ": " + el)
            })

        });

        var linearGradient = svg.append("linearGradient")
            .attr("id", "gradient");
        linearGradient
            .attr("x1", "0%")
            .attr("y1", "0%")
            .attr("x2", "0%")
            .attr("y2", "100%");
        linearGradient.append("stop")
            .attr("offset", "0%")
            .attr("stop-color", "#fdae61")

        linearGradient.append("stop")
            .attr("offset", "50%")
            .attr("stop-color", "#f7f7f7")

        linearGradient.append("stop")
            .attr("offset", "100%")
            .attr("stop-color", "#67a9cf")


        const colorLegendHeight = height / 3
        svg.append("rect")
            .attr("width", 20)
            .attr("height", height / 3)
            .style("fill", "url(#gradient)")
            .attr("x", width - 50 - 20)
            .attr("y", height - 75 - colorLegendHeight)
        svg.append("text")
            .text("-1")
            .attr("x", width - 50 + 3)
            .attr("y", height - 75 - colorLegendHeight + 6)
        svg.append("text")
            .text(" 1")
            .attr("x", width - 50 + 3)
            .attr("y", height - 75 + 3)
        svg.append("text")
            .text(" 0")
            .attr("x", width - 50 + 3)
            .attr("y", height - 75 - colorLegendHeight / 2 + 3)

    }
}