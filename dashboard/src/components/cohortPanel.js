import React, { useState, useEffect } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { Row, Col } from 'react-bootstrap';
import Scatterplot from './scatterplot'
import DistributionChart from './distributionChart';
import CorrelationMatrix from './correlationMatrix';
import QueryPanel from './queryPanel';
import $ from 'jquery';

function CohortPanel() {

  const [distrData, setDistrData] = useState([])
  const [corrMatrixData, setCorrMatrixData] = useState([])
  const [pcaCoords, setPcaCoords] = useState([])

  const distrDefaultArgs = ['fac_asymmaskmouth_mean', 'fac_asymmaskeyebrow_mean', 'fac_asymmaskeye_mean', 'fac_asymmaskcom_mean']
  const [distrArgs, setDistrArgs] = useState(distrDefaultArgs)
  const [corrMatrixArgs, setCorrMatrixArgs] = useState(distrDefaultArgs)

  const [checkedDistrState, setCheckedDistrState] = useState([]);
  const [checkedPCAState, setCheckedPCAState] = useState([]);
  const [checkedCorrMatrixState, setCheckedCorrMatrixState] = useState([]);

  const [idData, setIdData] = useState([])
  const [filteredIdData, setFilteredIdData] = useState([])
  const [checkedHideIdsState, setCheckedHideIdsState] = useState(false)

  const [pcaButton, setPcaButton] = useState(true)
  const [metadataButton, setMetadataButton] = useState(false)
  const [distrButton, setDistrButton] = useState(false)
  const [corrMatrixButton, setCorrMatrixButton] = useState(false)

  const [allFacialArg, setAllFacialArg] = useState([])
  const [allAcousticArg, setAllAcousticArg] = useState([])
  const [allMovementArg, setAllMovementArg] = useState([])
  const [allSpeechArg, setAllSpeechArg] = useState([])
  const [allDBMArg, setAllDBMArg] = useState([])

  const [metadata, setMetadata] = useState([])
  const metadataColorList = ['none', 'gold', 'blue', 'brown', 'purple', 'orange']
  const [metadataAttrColor, setMetadataAttrColor] = useState({})

  useEffect(() => {
    fetch("/getDerivedAttributes").then(
      res => res.json()
    ).then(
      data => {
        setAllFacialArg(data['facial'])
        setAllAcousticArg(data['acoustic'])
        setAllMovementArg(data['movement'])
        setAllSpeechArg(data['speech'])
        setAllDBMArg([...data['facial'], ...data['movement'], ...data['acoustic'], ...data['speech']])
        setIdData(data['ids'].map(el => el.split("/")[1].replace(".mp4", "")))
        setCheckedCorrMatrixState(new Array([...data['facial'], ...data['movement'], ...data['acoustic'], ...data['speech']].length).fill(false))
        setCheckedDistrState(new Array([...data['facial'], ...data['movement'], ...data['acoustic'], ...data['speech']].length).fill(false))
        setCheckedPCAState(new Array([...data['facial'], ...data['movement'], ...data['acoustic'], ...data['speech']].length).fill(false))
      }
    )
  }, [])


  useEffect(() => {
    fetch("/getMetadata").then(
      res => res.json()
    ).then(
      data => {
        setMetadata(data)
        var attr = [...new Set(Object.values(data).map(el => el['attr']).filter(e => e != null))]
        if (attr.length <= metadataColorList.length - 1) {
          var metaColorData = {}
          var attrDict = {}
          attr.forEach((e, i) => {
            attrDict[e] = metadataColorList[i + 1]
          })
          data.forEach(e => {
            if (e['attr']) {
              metaColorData[e['id']] = attrDict[e['attr']]
            }
          })
        }
        setMetadataAttrColor(metaColorData)
      }
    )
  }, [])


  useEffect(() => {
    fetch("/performPCA").then(
      res => res.json()
    ).then(
      data => {
        setPcaCoords(data)
      }
    )
  }, [])


  useEffect(() => {
    fetch("/defaultDistribution", {
      method: "POST",
      headers: {
        'Content-type': "application/json",
      },
      body: JSON.stringify({
        "distributionArgs": distrArgs
      })
    }).then(
      res => res.json()
    ).then(
      data => {
        setDistrData(data['data'])
      }
    )
  }, [])


  useEffect(() => {
    fetch("/defaultCorrMatrix", {
      method: "POST",
      headers: {
        'Content-type': "application/json",
      },
      body: JSON.stringify({
        "corrMatrix_args": distrDefaultArgs,
        "individual": false,
        "id": null
      })
    }).then(
      res => res.json()
    ).then(
      data => {
        setCorrMatrixData(data)
      }
    )
  }, [])


  const handlePCAUpdate = () => {
    var PCA_args = allDBMArg.filter((el, index) => checkedPCAState[index] === true)
    if (PCA_args.length !== 1) {
      fetch("/updatePCA", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "PCA_args": PCA_args
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setPcaCoords(data)
        }
      )
    }
  }

  const handlePCACheckboxChange = position => {
    const updatedCheckedState = checkedPCAState.map((item, index) =>
      index === position ? !item : item)
    setCheckedPCAState(updatedCheckedState)
  }

  const handleDistrUpdate = attr => {
    var args = allDBMArg.filter((el, index) => checkedDistrState[index] === true)
    if (args.length === 0 & attr.length > 0) {
      args = attr
    }
    fetch("/updateDistribution", {
      method: "POST",
      headers: {
        'Content-type': "application/json",
      },
      body: JSON.stringify({
        "distributionArgs": args
      })
    }).then(
      res => res.json()
    ).then(
      data => {
        setDistrData(data)
        setDistrArgs(args)
      }
    )
  }

  const handleDistrCheckboxChange = position => {
    const updatedCheckedState = checkedDistrState.map((item, index) =>
      index === position ? !item : item)
    setCheckedDistrState(updatedCheckedState)
  }


  const handleCorrMatrixUpdate = () => {
    var corrMatrix_args = allDBMArg.filter((el, index) => checkedCorrMatrixState[index] === true)
    fetch("/updateCorrMatrix", {
      method: "POST",
      headers: {
        'Content-type': "application/json",
      },
      body: JSON.stringify({
        "corrMatrix_args": corrMatrix_args,
        "individual": false,
        "id": null
      })
    }).then(
      res => res.json()
    ).then(
      data => {
        setCorrMatrixData(data)
        setCorrMatrixArgs(corrMatrix_args)
      }
    )
  }

  const handleCorrMatrixCheckboxChange = position => {
    const updatedCheckedState = checkedCorrMatrixState.map((item, index) =>
      index === position ? !item : item)
    setCheckedCorrMatrixState(updatedCheckedState)
  }

  const handlePanel = param => {
    setDistrButton(param === "Distr" ? true : false)
    setCorrMatrixButton(param === "Corr" ? true : false)
    setPcaButton(param === "PCA" ? true : false)
  }


  const handleIdCheckboxChange = ev => {
    $('#' + ev.target.id).is(":checked") ?
      $(".dot_" + ev.target.id.replace("_id", "")).css("fill", "red") :
      $(".dot_" + ev.target.id.replace("_id", "")).css("fill", (Object.keys(metadataAttrColor).includes(ev.target.id.replace("_id", "")) & metadataButton) ? metadataAttrColor[ev.target.id.replace("_id", "")] : "#69b3a2")
    var filteredIdData_aux = idData.filter(id =>
      $('#' + id + "_id").is(":checked"))
    setFilteredIdData(filteredIdData_aux)

  }

  const handleMetadata = () => {
    setMetadataButton(!metadataButton)
    handlePCAUpdate()
    handleDistrUpdate(distrDefaultArgs)
  }

  const handleHideIds = () => {
    if (checkedHideIdsState) {
      $('.dot').css("opacity", "0.4")
    }
    else {
      $('.dot').css("opacity", "0")
      filteredIdData.forEach(id => {
        $('.dot_' + id).css("opacity", "0.4")
      })
    }
    setCheckedHideIdsState(!checkedHideIdsState)
  }

  const handleUnselectCheckboxes = () => {
    const updatedCheckboxes = checkedCorrMatrixState.map(e => false)
    if (distrButton) {
      setCheckedDistrState(updatedCheckboxes)
    }
    else if (pcaButton) {
      setCheckedPCAState(updatedCheckboxes)
    }
    else {
      setCheckedCorrMatrixState(updatedCheckboxes)
    }
  }

  return (
    <div>
      {metadata && metadata.length > 0 &&
        <div id="metaDataButton" style={{ height: "5%", position: "absolute", top: "10px", left: "250px", display: "flex", flexDirection: "row" }}>
          <div>
            <button type="button" className={`btn btn-sm ${metadataButton === true ? 'btn-outline-primary' : 'btn-outline-secondary'}`}
              id="metadataButton" onClick={handleMetadata}>Metadata</button>
          </div>
          <div style={{ display: "flex", flexDirection: "row", justifyContent: 'flex-end', margin: "auto", marginLeft: "20px", opacity: "0" }} id="metadataAttributes">
            <div style={{ marginLeft: "5px", fontWeight: "bolder" }}>Attributes:</div>
            {metadataColorList.map((value, index) =>
              <div style={{ display: "flex", flexDirection: "row", opacity: "0", marginLeft: "20px" }} id={value + "AttrContainer"} className="metadataAttr">

                <svg height="14" width="14" transform="translate(3,3)" id="1circle">
                  <circle cx="7" cy="7" r="50%" fill={value === "none" ? "#69b3a2" : value} />
                </svg>
                <div style={{ marginLeft: "10px", fontWeight: "bolder", color: (value === "none" ? "#69b3a2" : value) }}
                  id={(value !== "none" ? value : "none") + "color"}>{value === "none" ? "None" : ""}</div>
              </div>
            )}
          </div>
        </div>
      }

      {allDBMArg.length > 0 &&
        <Row style={{ height: "90vh", width: "95vw", marginLeft: "10px" }}>
          <Col className="col-2" style={{ borderRadius: "15px", paddingTop: "10px", width: "max-content", height: "98%", boxShadow: "rgba(0, 0, 0, 0.16) 0px 1px 4px" }}>
            <div style={{ display: "inline-flex", flexDirection: "row", gap: "3px", marginBottom: "10px" }}>
              <button type="button" className={`btn btn-sm ${pcaButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handlePanel("PCA")}>PCA</button>
              <button type="button" className={`btn btn-sm ${distrButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handlePanel("Distr")}>Distr</button>
              <button type="button" className={`btn btn-sm ${corrMatrixButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handlePanel("Corr")}>Corr</button>
              <button type="button" className="btn-close" aria-label="Close" style={{ marginTop: "5px" }} onClick={handleUnselectCheckboxes}></button>
            </div>
            <div style={{ fontSize: "0.8rem", height: "90%" }}>
              {pcaButton &&
                <div style={{ height: "95%" }}>
                  <div style={{ display: "inline-flex", flexDirection: "row" }}>
                    <button type="button" className='btn btn-sm btn-outline-primary' onClick={handlePCAUpdate}>Update PCA</button>
                  </div>
                  <div style={{ overflowY: "scroll", height: "97%" }}>
                    <QueryPanel allAcousticArg={allAcousticArg} allMovementArg={allMovementArg} allSpeechArg={allSpeechArg} allFacialArg={allFacialArg}
                      checkedState={checkedPCAState} handleCheckboxChange={handlePCACheckboxChange} idVal={"pcaInputArg_"} />
                  </div>
                </div>
              }
              {distrButton &&
                <div style={{ height: "95%" }}>
                  <div style={{ display: "inline-flex", flexDirection: "row" }}>
                    <button type="button" className='btn btn-sm btn-outline-primary' onClick={handleDistrUpdate}>Update Distributions</button>
                  </div>
                  <div style={{ overflowY: "scroll", height: "97%" }}>
                    <QueryPanel allAcousticArg={allAcousticArg} allMovementArg={allMovementArg} allSpeechArg={allSpeechArg} allFacialArg={allFacialArg}
                      checkedState={checkedDistrState} handleCheckboxChange={handleDistrCheckboxChange} idVal={"distributionInputArg_"} />
                  </div>
                </div>
              }
              {corrMatrixButton &&
                <div style={{ height: "95%" }}>
                  <div style={{ display: "inline-flex", flexDirection: "row" }}>
                    <button type="button" className='btn btn-sm btn-outline-primary' onClick={handleCorrMatrixUpdate}>Update Correlations</button>
                  </div>
                  <div style={{ overflowY: "scroll", height: "97%" }}>
                    <QueryPanel allAcousticArg={allAcousticArg} allMovementArg={allMovementArg} allSpeechArg={allSpeechArg} allFacialArg={allFacialArg}
                      checkedState={checkedCorrMatrixState} handleCheckboxChange={handleCorrMatrixCheckboxChange} idVal={"corrmatrixInputArg_"} />
                  </div>
                </div>
              }
            </div>
          </Col>
          <Col className="col-4" style={{ height: "95%", width: "35%" }}>
            <Row id="scatterplotContainer" style={{ height: "35vh" }}>
              {pcaCoords && <Scatterplot data={pcaCoords} filteredIds={filteredIdData}
                metadata={metadataButton === true ? metadata : []} hideIds={checkedHideIdsState} metadataAttrColor={metadataAttrColor} />}
            </Row>
            <Row id="corrMatrixContainer" style={{ height: "50%", marginTop: "10%", fontSize: "0.8rem" }}>
              <CorrelationMatrix data={corrMatrixData} />
            </Row>
          </Col>
          <Col className="col-2" style={{
            display: "flex", flexDirection: "column", borderRadius: "15px", height:
              "98%", paddingTop: "10px", fontSize: "0.7rem", width: "max-content", boxShadow: "rgba(0, 0, 0, 0.16) 0px 1px 4px"
          }}>
            <button type="button" className='btn btn-primary btn-sm'>Filter ID(s)</button>
            <button type="button" className={`btn ${checkedHideIdsState === true ? 'btn-primary' : 'btn-outline-primary'}  btn-sm`} style={{ marginTop: "10px" }} onClick={handleHideIds}>Hide Unselected</button>
            <div style={{ display: "inline-flex", flexDirection: "column", marginTop: "10px", height: "94%", overflowY: "auto", }}>
              {idData.map((value, index) =>
                <label className="id_checkbox_container" id={value + "_id_container"}>
                  <input
                    type="checkbox"
                    id={value + "_id"}
                    onChange={handleIdCheckboxChange}
                  />
                  {" " + value}
                </label>
              )}
            </div>
          </Col>
          <Col id="distributionChartContainer" style={{ height: "93%", overflowY: "auto" }}>
            <h6 style={{ fontWeight: "bolder" }}>Attribute Distribution</h6>
            {distrArgs.map((value) =>
              <div style={{ display: "inline-flex", flexDirection: "row", marginLeft: "10px" }}>
                {<DistributionChart data={distrData} attr={value} id={"distributionChart_" + value}
                  filteredIds={filteredIdData} metadata={metadataButton === true ? metadata : []}
                  hideIds={checkedHideIdsState} metadataAttrColor={metadataAttrColor} />}
              </div>
            )
            }

          </Col>
        </Row>
      }
    </div>

  );
}

export default CohortPanel;
