import * as d3 from 'd3';
import $ from "jquery";
import "../index.css"

export default class ScatterplotD3 {
    constructor(chart, data, filteredIds, metadata, hideIds, metadataAttrColor) {

        if (data) {
            if (!d3.select(chart).select('svg').empty()) {
                d3.select(chart).select('svg').remove()
            }
            var parentContainer = document.getElementById("scatterplotContainer")
            var width = parentContainer.clientWidth
            var height = parentContainer.clientHeight
            const svg = d3.select(chart)
                .append('svg')
                .attr('width', width)
                .attr('height', height)
            var pca1 = Object.values(data).map(el => el[0])
            var pca2 = Object.values(data).map(el => el[1])
            var keys = Object.keys(data)
            var scatterplotObj = keys.map((el, i) => {
                return { "id": el, "pca1": pca1[i], "pca2": pca2[i] }
            })

            var metadataDict = {}
            if (metadata.length > 0) {
                $('#metadataAttributes').css("opacity", 1)
                var medataAttr = [...new Set(Object.values(metadata).map(el => el['attr']).filter(e => e != null))]
                var metadataColor = d3.scaleOrdinal().domain(medataAttr)
                    .range(['gold', 'blue', 'deeppink', 'darkviolet', 'cyan', 'black', 'brown', 'greenyellow', 'orchid','mediumpurple'])
                var d = Object.values(metadata).map(el => [el['id'], el['attr']])

                d.forEach(el => {
                    metadataDict[el[0]] = el[1]
                })
                medataAttr.forEach(a => {
                    $(`#${metadataColor(a)}AttrContainer`).css("opacity", 0.5)
                    $(`#${metadataColor(a)}color`).text(a)
                })
                $('#noneAttrContainer').css("opacity", 0.5)
            }
            else {
                $('#metadataAttributes').css("opacity", 0)
            }

            var xScale = d3.scaleLinear()
                .domain([Math.min(...pca1), Math.max(...pca1)]).range([10, width - 20])
            var yScale = d3.scaleLinear()
                .domain([Math.min(...pca2), Math.max(...pca2)]).range([height - 10, 10])

            svg.append("g")
                .attr("transform", "translate(-10," + (height - 3) + ")")
                .attr("class", "greyAxis")
                .call(d3.axisBottom(xScale));
            svg.append("g")
                .attr("transform", "translate(" + 2 + "," + 5 + " )")
                .attr("class", "greyAxis")
                .call(d3.axisLeft(yScale));

            svg.append('g')
                .selectAll("dot")
                .data(scatterplotObj)
                .enter()
                .append("circle")
                .attr("id", d => d['id'] + "_pca")
                .attr("cx", d => xScale(d['pca1']))
                .attr("cy", d => yScale(d['pca2']))
                .attr("class", d => "dot dotScatterplot dot_" + d['id'])
                .attr("r", 5.5)
                .style("fill", d => filteredIds.includes(d['id']) ? "darkorange" : (metadataDict[d['id']] ? metadataAttrColor[d['id']] : "#41ab5d"))
                .style("opacity", d => filteredIds.includes(d['id']) ? "0.4" : hideIds ? "0" : "0.4")
                .attr("stroke", "grey")
                .attr("stroke-width", '1.5px')


            svg.append("g")
                .call(d3.brush()
                    .extent([[0, 0], [width, height]])
                    .on("start brush end", e => brushed(e)));

            function brushed(e) {
                let value = [];
                if (e.selection) {
                    const [[x0, y0], [x1, y1]] = e.selection;
                    // default color for scatterplot points
                    d3.selectAll(".dotScatterplot").style("fill", d => filteredIds.includes(d['id']) ? "darkorange" : (metadataDict[d['id']] ? metadataAttrColor[d['id']] : "#41ab5d"))
                    // default color for distribution chart points
                    d3.selectAll(".dotDistr").style("fill", d => filteredIds.includes(d[0]) ? "darkorange" : (metadataDict[d[0]] ? metadataAttrColor[d[0]] : "#41ab5d"))
                    value = scatterplotObj.filter(d => (x0 <= xScale(d['pca1']) && xScale(d['pca1']) < x1 && y0 <= yScale(d['pca2']) && yScale(d['pca2']) < y1))
                        .map(e => e.id)
                    $(".id_checkbox_container").css("color", "black")
                    value.forEach(e => {
                        d3.selectAll(".dot_" + e).style("fill", "darkorange")
                        $("#" + e + "_id_container").css("color", "#fc6a03")
                    })
                }
                keys.forEach(k => {
                    if ($('#' + k + "_id").is(":checked"))
                        $(".dot_" + k).css("fill", "darkorange")
                })
                if ($('#metadataButton').hasClass("btn-outline-primary")) {
                }
                svg.property("value", value).dispatch("input");
            }
            d3.selectAll(".dotDistr").style("fill", d => filteredIds.includes(d[0]) ? "darkorange" : (metadataDict[d[0]] ? metadataAttrColor[d[0]] : "#41ab5d"))

        }
    }
}