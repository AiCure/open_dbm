import React, { useState, useEffect, useRef } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { Row, Col } from 'react-bootstrap';
import $ from 'jquery';
import HeadSVG from './headSVG.js'
import SpiderChart from './spiderChart.js';
import Histogram from './histogram.js';
import QueryPanel from './queryPanel.js';
import ColorLegend from './colorLegend.js';
import CorrelationMatrix from './correlationMatrix.js';
import DBMDict from "../DBM_attribute_dict.json"

function IndividualPanel() {
  const [movementButton, setMovementButton] = useState(false)
  const [asymetryButton, setAsymetryButton] = useState(false)
  const [painButton, setPainButton] = useState(false)
  const [expressivityButton, setExpressivityButton] = useState(false)
  const [AUsButton, setAUsButton] = useState(false)
  const [facialMaskColor, setFacialMaskColor] = useState('white')
  const [facialMaskVals, setFacialMaskVals] = useState(null)
  const emotions = ["ang", "fea", "dig", "sad", "con", "sur", "hap"]
  const [checkedEmotions, setCheckedEmotions] = useState(new Array(emotions.length).fill(false))
  const componentRef = useRef();

  const [rawFacialData, setFacialRawData] = useState(null)
  const [facialTimelineData, setFacialTimelineData] = useState(null)
  const [rawMovementData, setMovementRawData] = useState(null)
  const [rawAcousticData, setAcousticRawData] = useState(null)
  const [derivedData, setDerivedData] = useState({})
  const meanEmotionsSoft = ["fac_feaintsoft_mean", "fac_disintsoft_mean", "fac_sadintsoft_mean", "fac_conintsoft_mean", "fac_surintsoft_mean", "fac_hapintsoft_mean", "fac_angintsoft_mean"]
  const meanAUsSoft = ["fac_AU02int_mean", "fac_AU04int_mean", "fac_AU05int_mean", "fac_AU06int_mean", "fac_AU07int_mean", "fac_AU09int_mean", "fac_AU10int_mean",
    "fac_AU12int_mean", "fac_AU14int_mean", "fac_AU15int_mean", "fac_AU17int_mean", "fac_AU20int_mean", "fac_AU23int_mean", "fac_AU25int_mean", "fac_AU26int_mean", "fac_AU01int_mean",]

  const [timeslotValue, setTimeslotValue] = useState("0")
  const timepoints = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
  const [checkedFacialState, setCheckedFacialState] = useState([]);
  const [checkedAcousticState, setCheckedAcousticState] = useState([]);
  const [checkedMovementState, setCheckedMovementState] = useState([]);

  const [facialAttr, setFacialAttr] = useState([])
  const [movementAttr, setMovementAttr] = useState([])
  const [acousticAttr, setAcousticAttr] = useState([])
  const [allFacialAttr, setAllFacialAttr] = useState([])
  const [allMovementAttr, setAllMovementAttr] = useState([])
  const [allAcousticAttr, setAllAcousticAttr] = useState([])
  const [speechDerivedData, setSpeechDerivedData] = useState([])


  const [corrMatrixData, setCorrMatrixData] = useState([])
  const [checkedCorrMatrixState, setCheckedCorrMatrixState] = useState([]);
  const [allCorrMatrixAttr, setAllCorrMatrixAttr] = useState([])


  const [idData, setIdData] = useState([])
  const [selectedId, setSelectedId] = useState(null)

  const [speechButton, setSpeechButton] = useState(true)
  const [corrButton, setCorrButton] = useState(false)

  useEffect(() => {
    $('#asymetryMaskContainer').css("opacity", "0")
    $('#expressivityMaskContainer').css("opacity", "0")
    $('#facePainExpresivityMask').css("opacity", "0")
    $('#AUContainer').css("opacity", "0")
    $('#headMovementMaskContainer').css("opacity", "0")
    $('.emotion_highlight').css("opacity", "0")
  }, [])

  const handleFaceMask = param => {
    $('#asymetryMaskContainer').css("opacity", param === "asym" & !asymetryButton ? "1" : "0")
    $('#facePainExpresivityMask').css("opacity", param === "pain" & !painButton ? "0.5" : "0")
    $('#expressivityMaskContainer').css("opacity", param === "expr" & !expressivityButton ? "1" : "0")
    $('#AUContainer').css("opacity", param === "aus" & !AUsButton ? "1" : "0")

    setAsymetryButton(param === "asym" ? !asymetryButton : false)
    setPainButton(param === "pain" ? !painButton : false)
    setExpressivityButton(param === "expr" ? !expressivityButton : false)
    setAUsButton(param === "aus" ? !AUsButton : false)
    setFacialMaskColor(param === "asym" ? "pink" : param === "pain" ? "red" : param === "expr" ? "orange" : "#cb181d")
    setFacialMaskVals(param === "asym" ? [0, 10] : param === "pain" ? [0, 1] : param === "expr" ? [0, 1] : [0, 1])
  }

  const handleMovementMask = () => {
    $('#headMovementMaskContainer').css("opacity", !movementButton ? "1" : "0")
    setMovementButton(!movementButton)
    setFacialMaskColor(asymetryButton ? "pink" : painButton ? "red" : expressivityButton ? "orange" : "#cb181d")
    setFacialMaskVals(asymetryButton ? [0, 10] : painButton ? [0, 1] : expressivityButton ? [0, 1] : [0, 1])
  }

  const fetchIndividualData = id => {
    if (id) {
      fetch("/fetchIndividualFacialTimelineData", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "id": id
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setFacialTimelineData(data)
        }
      )

      fetch("/fetchIndividualFacialRawData", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "id": id
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setFacialRawData(data)
        }
      )

      fetch("/fetchIndividualMovementRawData", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "id": id
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setMovementRawData(data)
        }
      )

      fetch("/fetchIndividualAcousticRawData", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "id": id
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setAcousticRawData(data)
        }
      )

      fetch("/fetchIndividualDerivedData", {
        method: "POST",
        headers: {
          'Content-type': "application/json",
        },
        body: JSON.stringify({
          "id": id
        })
      }).then(
        res => res.json()
      ).then(
        data => {
          setDerivedData(data[0])
          setSpeechDerivedData(Object.keys(data[0]).filter(e => e.includes("nlp")))
        }
      )
    }
  }

  useEffect(() => {
    fetch("/getRawAttributesAndIds").then(
      res => res.json()
    ).then(
      data => {
        setAllFacialAttr(data['facial'])
        setAllAcousticAttr(data['acoustic'])
        setAllMovementAttr(data['movement'])
        if (data['facial'].length > 6)
          setFacialAttr(data['facial'].slice(0, 6))
        if (data['movement'].length > 6)
          setMovementAttr(data['movement'].slice(0, 6))
        if (data['acoustic'].length > 6)
          setAcousticAttr(data['acoustic'].slice(0, 6))
        setAllCorrMatrixAttr(data['facial'].concat(data['movement']).concat(data['acoustic']))
        setCheckedAcousticState(new Array(data['acoustic'].length).fill(false))
        setCheckedMovementState(new Array(data['movement'].length).fill(false))
        setCheckedFacialState(new Array(data['facial'].length).fill(false))
        setIdData(data['ids'].map(el => el.split("/")[1].replace(".mp4", "")))
        setCheckedCorrMatrixState(new Array(data['acoustic'].length + data['facial'].length + data['movement'].length).fill(false))
        if (data['ids'].length > 0) {
          var firstId = data['ids'].map(el => el.split("/")[1].replace(".mp4", ""))[0]
          setSelectedId(firstId)
          fetchIndividualData(firstId)
        }

      }
    )
  }, [])

  const setTime = (ev) => {
    setTimeslotValue(ev.target.value)
    $(".areaSegment").css("opacity", "0")
    $(`.areaSegment_${ev.target.value}`).css("opacity", "1")

    var facialSeg = parseInt(rawFacialData.length / 19)
    var movementSeg = parseInt(rawMovementData.length / 19)
    var acousticSeg = parseInt(rawAcousticData.length / 19)


    const facialReminder = rawFacialData.length - facialSeg * 19
    const movementReminder = rawMovementData.length - movementSeg * 19
    const acousticReminder = rawAcousticData.length - acousticSeg * 19

    facialSeg = facialSeg + (parseInt(ev.target.value) <= facialReminder ? 1 : 0)
    movementSeg = movementSeg + (parseInt(ev.target.value) <= movementReminder ? 1 : 0)
    acousticSeg = acousticSeg + (parseInt(ev.target.value) <= acousticReminder ? 1 : 0)

    $("#facialFrameLabel").html("Facial: " + String(parseInt(ev.target.value) !== 0 ? (facialSeg * (parseInt(ev.target.value) - 1) + 1) +
      " - " + (parseInt(ev.target.value) === 20 ? rawFacialData.length : facialSeg * (parseInt(ev.target.value))) : ""))

    $("#movementFrameLabel").html("Movement: " + String(parseInt(ev.target.value) !== 0 ? (movementSeg * (parseInt(ev.target.value) - 1) + 1) +
      " - " + (parseInt(ev.target.value) === 20 ? rawMovementData.length : movementSeg * (parseInt(ev.target.value))) : ""))

    $("#acousticFrameLabel").html("Acoustic: " + String(parseInt(ev.target.value) !== 0 ? (acousticSeg * (parseInt(ev.target.value) - 1) + 1) +
      " - " + (parseInt(ev.target.value) === 20 ? rawAcousticData.length : acousticSeg * (parseInt(ev.target.value))) : ""))
  }

  const handleUpdate = param => {
    if (param === "facial") {
      var facialArg = allFacialAttr.filter((el, index) => checkedFacialState[index] === true)
      setFacialAttr(facialArg)
    }
    else if (param === "movement") {
      var movementArg = allMovementAttr.filter((el, index) => checkedMovementState[index] === true)
      setMovementAttr(movementArg)
    }
    else {
      var acousticArg = allAcousticAttr.filter((el, index) => checkedAcousticState[index] === true)
      setAcousticAttr(acousticArg)
    }
  }

  const handleFacialCheckboxChange = position => {
    var updatedCheckedState = checkedFacialState.map((item, index) =>
      index === position ? !item : item)
    setCheckedFacialState(updatedCheckedState)
  }

  const handleAcousticCheckboxChange = position => {
    var updatedCheckedState = checkedAcousticState.map((item, index) =>
      index === position ? !item : item)
    setCheckedAcousticState(updatedCheckedState)
  }

  const handleMovementCheckboxChange = position => {

    var updatedCheckedState = checkedMovementState.map((item, index) =>
      index === position ? !item : item)
    setCheckedMovementState(updatedCheckedState)
  }


  const handleCorrMatrixCheckboxChange = position => {
    const updatedCheckedState = checkedCorrMatrixState.map((item, index) =>
      index === position ? !item : item)
    setCheckedCorrMatrixState(updatedCheckedState)
  }

  const handleCorrMatrixUpdate = id => {
    var corrMatrix_args = allCorrMatrixAttr.filter((el, index) => checkedCorrMatrixState[index] === true)
    if (corrMatrix_args.length === 0) {
      corrMatrix_args = meanEmotionsSoft.map(e => e.replace("_mean", ""))
    }
    var sendId = typeof id === 'string' ? id : selectedId
    fetch("/updateCorrMatrix", {
      method: "POST",
      headers: {
        'Content-type': "application/json",
      },
      body: JSON.stringify({
        "corrMatrix_args": corrMatrix_args,
        "individual": true,
        "id": sendId
      })
    }).then(
      res => res.json()
    ).then(
      data => {
        setCorrMatrixData(data)
      }
    )

  }

  const handleIdCheckboxChange = ev => {
    $(".individual_checkbox").prop("checked", false)
    $("#" + ev.target.id).prop("checked", true)
    var id = ev.target.id.replace("_id_checkbox", "")
    setSelectedId(id)
    if (corrButton) {
      handleCorrMatrixUpdate(id)
    }
    setTimeslotValue("0")
    fetchIndividualData(id)
  }


  const handleEmotionCheckboxChange = position => {
    const updatededEmotions = checkedEmotions.map((item, index) =>
      index === position ? !item : false)
    setCheckedEmotions(updatededEmotions)
    $(".emotion_highlight").css("opacity", "0")
    if ($('#' + emotions[position] + "_highlight").is(":checked")) {
      $("." + emotions[position] + "_highlight").css("opacity", "1")
    }

  }

  const handleSpeechPanel = panel => {
    if (panel === "speech") {
      setSpeechButton(true)
      setCorrButton(false)
    }
    else {
      setSpeechButton(false)
      setCorrButton(true)
      handleCorrMatrixUpdate()
    }
  }

  const handleUnselectCheckboxes = param => {
    var updatedCheckedState = null
    if (param === "facial") {
      updatedCheckedState = checkedFacialState.map(e => false)
      setCheckedFacialState(updatedCheckedState)
    }
    else if (param === "movement") {
      updatedCheckedState = checkedMovementState.map(e => false)
      setCheckedMovementState(updatedCheckedState)
    }
    else {
      updatedCheckedState = checkedAcousticState.map(e => false)
      setCheckedAcousticState(updatedCheckedState)
    }
  }

  return (
    <div>
      {rawFacialData && rawFacialData.length > 0 &&
        <div id="timelineContainer" style={{ height: "5%", position: "absolute", top: "0px", left: "250px", display: "flex", flexDirection: "row" }}>

          <div className="sliderContainer" style={{ margin: "5px", display: "flex", flexDirection: "row" }}>
            <div>Timeline</div>
            <div>
              <input type="range" min='0' max="20" id="myRange" className="slider" style={{ width: "400px" }}
                step="1" value={timeslotValue} onChange={setTime} list="steplist"></input>
              <datalist id="steplist" style={{ display: "inline-flex", marginTop: "-10px !important" }}>
                {timepoints.map((e, i) =>
                  <option value={e} style={{ marginLeft: "2px", marginRight: "4px", fontSize: "0.7rem" }} key={e+"timepoint"}>{i === 0 ? "*" : e}</option>
                )}
              </datalist>
            </div>
          </div>
          <div style={{ display: "flex", flexDirection: "row", justifyContent: 'flex-end', margin: "auto", width: "70%" }}>
            <div style={{ margin: "auto", fontWeight: "bolder" }}>Frames:</div>
            <div style={{ margin: "auto", fontWeight: "bolder", color: "#41ab5d" }} id="facialFrameLabel">Facial</div>
            <h6 style={{ margin: "auto", fontWeight: "bolder", color: "#4292c6" }} id="movementFrameLabel">Movement</h6>
            <h6 style={{ margin: "auto", fontWeight: "bolder", color: "#807dba" }} id="acousticFrameLabel">Acoustics</h6>
          </div>
        </div>
      }
      <Row style={{ height: "90vh", width: "99vw", marginLeft: "10px" }}>
        {derivedData &&
          <Col className="col-2" style={{ height: "100%", width: "250px" }}>
            <Row style={{ width: "300", }} id='headContainer'>
              <div style={{ display: "inline-flex", flexDirection: "row", gap: "3px", marginBottom: "10px", marginLeft: "-12px" }}>
                <button type="button" id="asymMaskButton" className={`btn btn-sm ${asymetryButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleFaceMask("asym")}>Asym</button>
                <button type="button" id="painMaskButton" className={`btn btn-sm ${painButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleFaceMask("pain")}>Pain</button>
                <button type="button" id="exprMaskButton" className={`btn btn-sm ${expressivityButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleFaceMask("expr")}>Expr</button>
                <button type="button" id="AUsMaskButton" className={`btn btn-sm ${AUsButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleFaceMask("aus")}>AUs</button>
                <button type="button" id="movMaskButton" className={`btn btn-sm ${movementButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={handleMovementMask}>Mov</button>
              </div>
              <div style={{ marginLeft: "10px" }}>
                < HeadSVG width={200} height={300}/>
              </div>
            </Row>
            <Row style={{ marginTop: "300px" }}>
              <div style={{ width: "100%", height: "3vh", fontSize: "0.7rem", paddingLeft: "0px", paddingRight: "0px", marginBottom: "5px" }}>
                {AUsButton && emotions.map((value, index) =>
                  <label className="id_checkbox_container" style={{ marginRight: "3px" }} key={value+"AU"}>
                    <input
                      type="checkbox"
                      id={value + "_highlight"}
                      className="emotion_checkbox"
                      checked={checkedEmotions[index]}
                      onChange={() => handleEmotionCheckboxChange(index)}
                    />
                    {value}
                  </label>
                )}
              </div>
              <div id="colorScaleContainer" style={{ width: "90%", height: "5vh", opacity: ((painButton | expressivityButton | AUsButton | asymetryButton) ? "1" : "0") }}>
                <ColorLegend range={facialMaskVals} colorScale={["white", facialMaskColor]} derivedData={derivedData} id={"faceMaskColorLegend"} timelineData={facialTimelineData} timeframe={timeslotValue} />
              </div>
              <Col className="col-2" style={{ display: "flex", flexDirection: "column", borderRadius: "15px", paddingTop: "10px", fontSize: "0.7rem", width: "230px", boxShadow: "rgba(0, 0, 0, 0.16) 0px 1px 4px", height: 'calc(90vh - 420px)' }}>
                <button type="button" className='btn btn-primary btn-sm'>Filter ID(s)</button>
                <div style={{ fontSize: "0.8rem", width: "210px", display: "inline-flex", flexDirection: "column", marginTop: "10px", overflowY: "auto" }}>
                  {idData.map((value, index) =>
                    <label className="id_checkbox_container" id={value + "_id_"} key={value+"idIndividual"}>
                      <input
                        type="checkbox"
                        id={value + "_id_checkbox"}
                        className="individual_checkbox"
                        onChange={handleIdCheckboxChange}
                      />
                      {" " + value}
                    </label>
                  )}
                </div>
              </Col>
            </Row>
          </Col>
        }
        <Col style={{ height: "100%", marginRight: "10px", width: "40%" }}>
          {rawFacialData && rawFacialData.length > 0 &&
            <Row id="facialActivityContainer" style={{ height: "48%", backgroundColor: "#f7fcf5", padding: "10px", overflowY: "scroll" }}>
              <div style={{ display: "flex", }}>
                <Col className='col-2' style={{ fontSize: "0.8rem", width: "max-content", }}>
                  {allFacialAttr &&
                    <div style={{ marginLeft: "-10px", marginRight: "5px" }}>
                      <div style={{ display: "inline-flex", flexDirection: "row" }}>
                        <button type="button" className='btn btn-sm btn-outline-primary' onClick={() => handleUpdate("facial")}>Update</button>
                        <button type="button" className="btn-close" aria-label="Close" style={{ marginTop: "5px", marginLeft: "5px" }} onClick={() => handleUnselectCheckboxes("facial")}></button>
                      </div>
                      <QueryPanel allAcousticArg={[]} allMovementArg={[]} allSpeechArg={[]} allFacialArg={allFacialAttr}
                        checkedState={checkedFacialState} handleCheckboxChange={handleFacialCheckboxChange} idVal={"rawFacialIndividualAttr_"} />
                    </div>}
                </Col>
                <Col className='col-2' style={{ width: "77%", height: "100%", overflowY: "hidden" }}>
                  {facialAttr.map((value) =>
                    <div style={{ display: "inline-flex", flexDirection: "row", padding: "10px", fontSize: "0.8rem", }} key={value+"facHistogram"}>
                      {<Histogram data={rawFacialData} derivedData={derivedData} attr={value} id={"histogram_" + value} color={["#41ab5d", "#c7e9c0"]} timeframe={timeslotValue} />}
                    </div>
                  )}
                </Col>
              </div>
            </Row>
          }
          <Row style={{ marginTop: "30px", display: "flex", flexDirection: "row", height: "48%", overflowY: "auto" }}>
            <div style={{ display: "inline-flex", flexDirection: "row", gap: "10px", marginTop: "10px" }}>
              <button type="button" className={`btn btn-sm ${speechButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleSpeechPanel("speech")} id="speechPanelButton" style={{ height: "max-content", }}>{'Facial & Speech'}</button>
              <button type="button" className={`btn btn-sm ${corrButton === true ? 'btn-primary' : 'btn-secondary'}`} onClick={() => handleSpeechPanel("corr")} style={{ height: "max-content", }} id="corrMatrixPanelButton">Correlation</button>
            </div>
            {speechButton &&
              <div style={{ display: "flex", flexDirection: "row" }}>
                <Col className='col-8' style={{ display: "flex", flexDirection: "row" }}>
                  <div style={{ width: "max-content", marginRight: "20px" }}>
                    <div >
                      <SpiderChart style={{ padding: "10px" }} label={'Emotion Intensity'} derivedData={derivedData} timelineData={facialTimelineData} timeframe={timeslotValue} levels={[0, 0.25, 0.5, 0.75, 1]}
                        axes={meanEmotionsSoft.reverse()} />
                    </div>
                  </div>
                  <div style={{ width: "max-content" }}>
                    <div >
                      <SpiderChart style={{ padding: "10px" }} label={'AU Intensity'} derivedData={derivedData} timelineData={facialTimelineData} timeframe={timeslotValue} levels={[0, 1, 2, 3, 4, 5]}
                        axes={meanAUsSoft.reverse()} />
                    </div>
                  </div>
                </Col>
                <Col className='col-4'>
                  <h6 style={{ marginBotom: "10px", fontWeight: "bolder" }}>Speech</h6>
                  {speechDerivedData && speechDerivedData.map((value, index) =>
                    <div style={{ fontSize: "0.8rem" }} key={value +"speech"}>{DBMDict[value]['label'] + ": " + derivedData[value]}</div>
                  )}
                </Col>
              </div>}
            {corrButton && ((rawFacialData && rawFacialData.length > 0) || (rawAcousticData && rawAcousticData.length > 0) || (rawMovementData && rawMovementData.length > 0)) &&
              <Row style={{ height: "85%", marginTop: "5px" }}>
                <Col className='col-2' style={{ width: "25%", height: "100%", overflowY: "scroll", fontSize: "0.8rem" }}>

                  <div >
                    <div style={{ display: "inline-flex", flexDirection: "row" }}>
                      <button type="button" className='btn btn-sm btn-outline-primary' style={{ marginBottom: "10px" }} onClick={handleCorrMatrixUpdate}>Update</button>
                    </div>
                    <QueryPanel allAcousticArg={allAcousticAttr} allMovementArg={allMovementAttr} allSpeechArg={[]} allFacialArg={allFacialAttr}
                      checkedState={checkedCorrMatrixState} handleCheckboxChange={handleCorrMatrixCheckboxChange} idVal={"corrMatrixIndividual_"} />
                  </div>
                </Col>
                <Col className='col-2' style={{ width: "75%", height: "90%", }} id="corrMatrixContainer" >
                  <CorrelationMatrix data={corrMatrixData} />
                </Col>
              </Row>}
          </Row>
        </Col>
        <Col style={{ height: "100%", width: "40%" }}>
          {rawMovementData && rawMovementData.length > 0 &&
            <Row id="headMovementContainer" style={{ height: "48%", overflowY: "scroll", backgroundColor: "#f7fbff" }}>
              <div style={{ display: "flex", }}>
                <Col className='col-2' style={{ width: "max-content", fontSize: "0.8rem" }}>
                  {allMovementAttr &&
                    <div style={{ marginLeft: "-10px", marginRight: "5px" }}>
                      <div style={{ display: "inline-flex", flexDirection: "row" }}>
                        <button type="button" className='btn btn-sm btn-outline-primary' style={{ marginBottom: "10px" }} onClick={() => handleUpdate("movement")}>Update</button>
                        <button type="button" className="btn-close" aria-label="Close" style={{ marginTop: "5px", marginLeft: "5px" }} onClick={() => handleUnselectCheckboxes("movement")}></button>
                      </div>
                      <QueryPanel allAcousticArg={[]} allMovementArg={allMovementAttr} allSpeechArg={[]} allFacialArg={[]}
                        checkedState={checkedMovementState} handleCheckboxChange={handleMovementCheckboxChange} idVal={"rawMovementIndividualAttr_"} />
                    </div>}
                </Col>
                <Col className='col-2' style={{ width: "80%", height: "100%", overflowY: "hidden" }}>
                  {movementAttr.map((value) =>
                    <div style={{ display: "inline-flex", flexDirection: "row", padding: "10px", fontSize: "0.8rem", }} key={value+"movHistogram"}>
                      {<Histogram data={rawMovementData} derivedData={derivedData} attr={value} id={"histogram_" + value} color={["#4292c6", "#c6dbef"]} timeframe={timeslotValue} />}
                    </div>
                  )}
                </Col>
              </div>
            </Row>
          }
          {rawAcousticData && rawAcousticData.length > 0 &&
            <Row id="voiceAcousticsContainer" style={{ height: "48%", overflowY: "scroll", backgroundColor: "#f7f4f9", marginTop: "30px" }}>
              <div style={{ display: "flex" }}>
                <Col className='col-2' style={{ fontSize: "0.8rem", width: "max-content" }}>
                  {allAcousticAttr &&
                    <div style={{ marginLeft: "-10px", marginRight: "5px" }}>
                      <div style={{ display: "inline-flex", flexDirection: "row" }}>
                        <button type="button" className='btn btn-sm btn-outline-primary' style={{ marginBottom: "10px" }} onClick={() => handleUpdate("acoustics")}>Update</button>
                        <button type="button" className="btn-close" aria-label="Close" style={{ marginTop: "5px", marginLeft: "5px" }} onClick={() => handleUnselectCheckboxes("acoustics")}></button>

                      </div>
                      <QueryPanel allAcousticArg={allAcousticAttr} allMovementArg={[]} allSpeechArg={[]} allFacialArg={[]}
                        checkedState={checkedAcousticState} handleCheckboxChange={handleAcousticCheckboxChange} idVal={"rawAcousticIndividualAttr_"} />
                    </div>}
                </Col>
                <Col className='col-2' style={{ width: "80%", height: "100%", overflowY: "hidden", fontSize: "0.8rem", }}>
                  {acousticAttr.map((value) =>
                    <div style={{ display: "inline-flex", flexDirection: "row", padding: "10px" }} key={value+"acoHistogram"}>
                      {<Histogram data={rawAcousticData} derivedData={derivedData} attr={value} id={"histogram_" + value} color={["#807dba", "#dadaeb"]} timeframe={timeslotValue} />}
                    </div>
                  )}
                </Col>
              </div>
            </Row>
          }

        </Col>
      </Row>

    </div>
  );
}

export default IndividualPanel;
