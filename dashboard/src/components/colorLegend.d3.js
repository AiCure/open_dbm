import * as d3 from 'd3';
import $ from "jquery";
import "../index.css"

export default class ColorLegendD3 {
    constructor(chart, range, colorScale, derivedData, id, timelineData, timeframe) {
        if (!d3.select(chart).select('svg').empty()) {
            d3.select(chart).select('svg').remove()
        }

        var parentContainer = document.getElementById("colorScaleContainer")
        var width = parentContainer.clientWidth
        var height = parentContainer.clientHeight
        const svg = d3.select(chart)
            .append('svg')
            .attr('width', width)
            .attr('height', height)
            .attr("id", id)

        if (!derivedData) {
            return
        }

        const asymetryColorScale = d3.scaleLinear().domain([0, 40]).range(["white", '#de77ae'])
        const painColorScale = d3.scaleLinear().domain([0, 1]).range(["white", 'red'])
        const expressivityColorScale = d3.scaleLinear().domain([0, 1]).range(["white", 'orange'])
        const AUsColorScale = d3.scaleLinear().domain([0, 5]).range(["white", '#cb181d'])
        const negMovementColorScale = d3.scaleLinear().domain([-3.14, 0]).range(['#cb181d', "#fff5f0"])
        const posMovementColorScale = d3.scaleLinear().domain([0, 3.14]).range(["#fff5f0", '#cb181d'])
        const vissibleAUs = ['AU01', 'AU02', 'AU04', 'AU05', 'AU06', 'AU07', 'AU09', 'AU10', 'AU12', 'AU14', 'AU15', 'AU17', 'AU20', 'AU23', 'AU25', 'AU26']

        if (parseInt(timeframe) === 0) {
            vissibleAUs.forEach(a => {
                var el = "fac_" + a + "int"
                $('.' + a).css("stroke", AUsColorScale(derivedData[el + "_mean"]))
            })
            $('#faceAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskcom_mean']))
            $('#leftEyeAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskeye_mean']))
            $('#rightEyeAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskeye_mean']))
            $('#leftEyebrowAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskeyebrow_mean']))
            $('#rightEyebrowAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskeyebrow_mean']))
            $('#mouthAsymetryMask').css("fill", asymetryColorScale(derivedData['fac_asymmaskmouth_mean']))
            $('#faceExpresivityMask').css("fill", expressivityColorScale(derivedData["fac_comintsoft_mean"]))
            $('#upperFaceExpresivityMask').css("fill", expressivityColorScale(derivedData["fac_comuppintsoft_mean"]))
            $('#lowerFaceExpresivityMask').css("fill", expressivityColorScale(derivedData["fac_comlowintsoft_mean"]))
            $('#facePainExpresivityMask').css("fill", painColorScale(derivedData["fac_paiintsoft_mean"]))
            $('#pitchUp').css("stroke", posMovementColorScale(derivedData["mov_hposepitch_mean"]))
            $('#pitchDown').css("stroke", negMovementColorScale(derivedData["mov_hposepitch_mean"]))
            $('#rollRight').css("stroke", negMovementColorScale(derivedData["mov_hposeroll_mean"]))
            $('#rollLeft').css("stroke", posMovementColorScale(derivedData["mov_hposeroll_mean"]))
            $('#yawLeft').css("stroke", posMovementColorScale(derivedData["mov_hposeyaw_mean"]))
            $('#yawRight').css("stroke", negMovementColorScale(derivedData["mov_hposeyaw_mean"]))
        }
        else {
            vissibleAUs.forEach(a => {
                var el = "fac_" + a + "int"
                $('.' + a).css("stroke", AUsColorScale(timelineData[el][parseInt(timeframe) - 1]))
            })

            if (timelineData["mov_hposeyaw"]) {
                $('#pitchUp').css("stroke", posMovementColorScale(timelineData["mov_hposepitch"][parseInt(timeframe) - 1]))
                $('#pitchDown').css("stroke", negMovementColorScale(timelineData["mov_hposepitch"][parseInt(timeframe) - 1]))
                $('#rollRight').css("stroke", negMovementColorScale(timelineData["mov_hposeroll"][parseInt(timeframe) - 1]))
                $('#rollLeft').css("stroke", posMovementColorScale(timelineData["mov_hposeroll"][parseInt(timeframe) - 1]))
                $('#yawLeft').css("stroke", posMovementColorScale(timelineData["mov_hposeyaw"][parseInt(timeframe) - 1]))
                $('#yawRight').css("stroke", negMovementColorScale(timelineData["mov_hposeyaw"][parseInt(timeframe) - 1]))
            }

            $('#faceAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskcom'][parseInt(timeframe) - 1]))
            $('#leftEyeAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskeye'][parseInt(timeframe) - 1]))
            $('#rightEyeAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskeye'][parseInt(timeframe) - 1]))
            $('#leftEyebrowAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskeyebrow'][parseInt(timeframe) - 1]))
            $('#rightEyebrowAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskeyebrow'][parseInt(timeframe) - 1]))
            $('#mouthAsymetryMask').css("fill", asymetryColorScale(timelineData['fac_asymmaskmouth'][parseInt(timeframe) - 1]))
            $('#faceExpresivityMask').css("fill", expressivityColorScale(timelineData["fac_comintsoft"][parseInt(timeframe) - 1]))
            $('#upperFaceExpresivityMask').css("fill", expressivityColorScale(timelineData["fac_comuppintsoft"][parseInt(timeframe) - 1]))
            $('#lowerFaceExpresivityMask').css("fill", expressivityColorScale(timelineData["fac_comlowintsoft"][parseInt(timeframe) - 1]))
            $('#facePainExpresivityMask').css("fill", painColorScale(timelineData["fac_paiintsoft"][parseInt(timeframe) - 1]))
        }


        var linearGradient = svg.append("linearGradient")
            .attr("id", "linear-gradient")
        linearGradient
            .attr("x1", "0%")
            .attr("y1", "0%")
            .attr("x2", "100%")
            .attr("y2", "0%");
        linearGradient.append("stop")
            .attr("offset", "0%")
            .attr("stop-color", colorScale[0])
        linearGradient.append("stop")
            .attr("offset", "100%")
            .attr("stop-color", colorScale[1])

        const colorLegendHeight = height - 10

        svg.append("rect")
            .attr("width", width - 30)
            .attr("height", colorLegendHeight)
            .style("fill", "url(#linear-gradient)")
            .attr("x", 10)
            .attr("y", colorLegendHeight - 20)
        svg.append("text")
            .text(range[0])
            .attr("x", 1)
            .attr("y", height - 10)
        svg.append("text")
            .text(range[1])
            .attr("x", width - 17)
            .attr("y", height - 10)

    }
}