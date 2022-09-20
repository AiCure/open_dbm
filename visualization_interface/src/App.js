import React, { useState, useEffect } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { Row, Col } from 'react-bootstrap';
import CohortPanel from './components/cohortPanel';
import IndividualPanel from './components/individualPanel';

function App() {

  const [cohortButton, setCohortButton] = useState(true)
  const [individualButton, setIndividualButton] = useState(false)



  const handleView = param => {
    setCohortButton(param === "cohort" ? true : false)
    setIndividualButton(param !== "cohort" ? true : false)
  }

  return (
    <div className='App' style={{ fontFamily: "monospace", width: "max-content", height: "max-content" }}>
      <Row style={{}}>
        <Col className="col-2" style={{ width: "90vh", height: "max-content", marginTop: "10px", marginBottom: "10px", display: "inline-flex", flexDirection: "row", gap: "3px" }}>
          <div style={{ display: "inline-flex", flexDirection: "row", gap: "10px", marginLeft: "10px" }}>
            <button
              type="button"
              className={`btn btn-sm ${cohortButton === true ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => handleView("cohort")}
              id="cohortViewButton"
              style={{ height: "max-content", }}>
              Cohort
            </button>

            <button
              type="button"
              className={`btn btn-sm ${individualButton === true ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => handleView("individual")}
              style={{ height: "max-content", }}
              id="individualViewButton">
              Individual
            </button>
          </div>
        </Col>
      </Row>
      {cohortButton ? <CohortPanel /> : <IndividualPanel />}
    </div>
  );
}

export default App;
