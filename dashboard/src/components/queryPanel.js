import DBMDict from "../DBM_attribute_dict.json"
import "./cohortPanel.css"

const QueryPanel = ({ allAcousticArg, allMovementArg, allSpeechArg, allFacialArg, checkedState, handleCheckboxChange, idVal }) => {
    return (
        <div className="queryPanel">
            {allFacialArg.length > 0 && <h6>Facial</h6>}
            {allFacialArg.length > 0 && allFacialArg.map((value, index) =>
                <div key={idVal + value + "key"}><label className="">
                    <input
                        type="checkbox"
                        id={idVal + value}

                        checked={checkedState[index]}
                        className={idVal}
                        onChange={() => handleCheckboxChange(index)}
                    />
                    {" " + DBMDict[value]['label']}
                </label></div>
            )
            }
            {allMovementArg.length > 0 && <h6>Movement</h6>}
            {allMovementArg.length > 0 && allMovementArg.map((value, index) =>
                <div key={idVal + value + "key"}><label className="">
                    <input
                        type="checkbox"
                        id={idVal + value}

                        checked={checkedState[index + allFacialArg.length]}
                        className={idVal}
                        onChange={() => handleCheckboxChange(index + allFacialArg.length)}
                    />
                    {" " + DBMDict[value]['label']}
                </label></div>
            )
            }
            {allAcousticArg.length > 0 && <h6>Acoustics</h6>}
            {allAcousticArg.length > 0 && allAcousticArg.map((value, index) =>
                <div key={idVal + value + "key"}><label className="">
                    <input
                        type="checkbox"
                        id={idVal + value}

                        checked={checkedState[index + allFacialArg.length + allMovementArg.length]}
                        className={idVal}
                        onChange={() => handleCheckboxChange(index + allFacialArg.length + allMovementArg.length)}
                    />
                    {" " + DBMDict[value]['label']}
                </label></div>
            )
            }
            {allSpeechArg.length > 0 && <h6>Speech</h6>}
            {allSpeechArg.map((value, index) =>
                <div key={idVal + value + "key"}><label className="">
                    <input
                        type="checkbox"
                        id={idVal + value}

                        checked={checkedState[index + allFacialArg.length + allAcousticArg.length + allMovementArg.length]}
                        className={idVal}
                        onChange={() => handleCheckboxChange(index + allFacialArg.length + allAcousticArg.length + allMovementArg.length)}
                    />
                    {" " + DBMDict[value]['label']}
                </label></div>
            )
            }
        </div>

    )
}

export default QueryPanel;