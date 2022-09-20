import React, { useRef, useEffect } from 'react';
import ColorLegendD3 from './colorLegend.d3';

const ColorLegend = ({ range, colorScale, derivedData, id, timelineData, timeframe }) => {
    const ref = useRef(null)

    useEffect(() => {
        const currElement = ref.current
        if (range) {
            new ColorLegendD3(currElement, range, colorScale, derivedData, id, timelineData, timeframe)
        }
    }, [range, colorScale, derivedData, timelineData, timeframe])

    return (
        <div ref={ref}></div>
    )
}

export default ColorLegend;