import React, { useRef, useEffect } from 'react';
import { ComponentToPrint } from './componentToPrint';
import { exportComponentAsJPEG } from 'react-component-export-image';
import SpiderChartD3 from './spiderChart.d3';

const SpiderChart = ({ derivedData, timelineData, timeframe, levels, axes, label }) => {
    const ref = useRef(null)

    useEffect(() => {
        const currElement = ref.current
        if (derivedData) {
            new SpiderChartD3(currElement, derivedData, timelineData, timeframe, levels, axes)
        }
    }, [derivedData, timelineData, timeframe])

    return (
        <React.Fragment>
            <div style={{ display: "flex", justifyContent: "space-between" }}>
                <div style={{fontSize:"0.8rem"}}>{label}</div>
                <button type="button" className='btn btn-outline-secondary btn-sm' onClick={() => exportComponentAsJPEG(ref)} style={{ width: "max-content", }}>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-printer" viewBox="0 0 16 16">
                        <path d="M2.5 8a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1z" />
                        <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v3a2 2 0 0 0 2 2h1v1a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-1h1a2 2
                     0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2H5zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4V3zm1 5a2 2 0 0 0-2
                     2v1H2a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-1v-1a2 2 0 0 0-2-2H5zm7 2v3a1 1 0 0
                      1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1z" />
                    </svg>
                </button>
            </div>
            <ComponentToPrint ref={ref} />
        </React.Fragment>
    )
}

export default SpiderChart;