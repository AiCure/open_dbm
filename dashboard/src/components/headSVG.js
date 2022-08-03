import React, { useRef } from 'react';
import $ from 'jquery';
import { exportComponentAsJPEG } from 'react-component-export-image';

const HeadSVG = ({ width, height }, ref) => {
    const componentRef = useRef()
    const showTooltip = () => {
        if ($('#AUsMaskButton').hasClass("btn-primary") | $('#movMaskButton').hasClass("btn-primary")) {
            $('.AUtooltip').css("opacity", "1")
        }
    }
    const hideTooltip = () => {
        $('.AUtooltip').css("opacity", "0")
    }



    return (
        <React.Fragment>
            <div ref={componentRef} style={{ position: "relative", overflow: "none", display: "inline-block", }} onMouseOver={showTooltip} onMouseLeave={hideTooltip}>
                <svg style={{ position: "absolute" }}
                    width={width}
                    height={height}
                    viewBox={`0 0 ${width} ${parseInt(height) + 100}`}>
                    <g transform="translate(-36,0) scale(0.9,0.9)"
                        fill="#000000" stroke="none">
                        <path fill="#3a3b3c" id="headSketch"
                            d="M1275 3785c-49-8-119-16-155-20-80-8-186-35-276-71-281-112-521-412-595-744-41-182-59-495-39-660 13-97 14-129 7-136-2-2-24 3-49 13-38 14-51 14-75 4-101-42-79-192 82-566 7-16 19-50 25-75 12-46 35-99 120-275 27-55 67-143 89-195 23-52 55-117 71-145 16-27 41-70 54-95 14-25 42-68 63-97 21-28 59-81 86-118l47-66V270c0-233 2-270 15-270s15 35 15 253v252l27-35c67-89 283-276 403-349 89-55 150-70 275-71 137 0 322 18 355 36 44 23 193 147 251 209 122 131 141 152 177 198l37 48 3-270c2-232 4-271 17-271s15 40 15 291v292l33 51c19 28 64 98 102 155 61 93 165 304 165 336 0 14 55 122 75 145 13 16 105 239 105 255 0 9 6 23 79 177 74 159 76 164 76 279 0 116-5 128-61 155-31 15-38 15-80 0l-46-15 6 37c24 159 27 237 17 405-5 98-13 182-16 187s-11 51-16 102c-16 148-24 171-142 407-47 95-61 113-157 204-144 137-232 201-310 227-36 12-74 25-85 30-173 71-539 101-790 65zm398-26c29-6 59-11 67-10 38 1 189-22 225-34 22-7 48-13 58-12 17 0 79-25 165-67 73-36 168-113 254-208 46-50 82-94 81-98s9-18 22-30c14-13 25-27 25-32s15-30 33-56c18-27 41-70 51-98 10-27 21-58 26-69 14-33 40-161 61-300 21-141 26-427 9-501-5-22-12-67-15-100-3-32-8-72-12-88l-5-30-13 30-13 29-1-33c-1-18 4-43 10-54 14-27-3-141-37-240-13-39-21-74-18-77 11-11 42 39 49 79 4 22 11 40 17 40 7 0 8-12 4-32-4-18-11-78-15-133-19-221-74-443-153-620-94-207-299-498-504-712-62-65-226-193-254-199-14-2-44-9-68-14-57-13-412-13-412 0 0 6-8 10-17 10-25 0-110 51-163 97-25 21-75 60-111 85-88 63-197 180-320 347-93 127-197 294-235 381-9 19-37 82-64 140-60 131-79 219-121 545-17 142-20 173-9 140 5-16 15-50 21-75 9-36 13-41 19-25 4 11-3 55-16 104-23 83-25 130-11 241 4 25 4 37 1 28-12-38-22-14-34 80-25 198-16 534 19 702 60 285 199 514 408 672 43 33 105 72 138 88 66 31 221 71 300 77 28 2 71 8 97 13s98 13 160 16 114 7 116 9c8 7 141 3 185-6zM177 2129c44-18 50-25 60-62 6-23 8-58 4-77l-7-34-17 45c-20 51-70 105-107 114-22 5-28 1-42-27s-17-30-17-11c-1 22 44 73 65 73 6 0 34-9 61-21zm2723-24c10-12 9-15-6-15-32 0-81-37-120-89-21-28-40-49-42-46-3 2 3 33 13 69l17 64 52 15c66 20 71 20 86 2zm-2748-42c14-16 39-55 57-87 26-50 31-71 31-127 0-37 4-89 9-116 6-26 15-96 21-154 6-59 17-131 24-160 8-30 13-56 10-58-6-6-71 139-79 177-4 18-27 81-52 140-59 140-92 244-99 313-11 94 26 127 78 72zm2750-10c27-31 38-129 20-182-8-25-20-53-27-61-21-27-103-223-138-332-35-107-96-228-82-163 46 228 56 307 56 460 0 121 2 133 24 167 24 36 114 128 126 128 3 0 13-8 21-17z"
                            transform="matrix(.1 0 0 -.1 0 386)"
                        ></path>
                        <path
                            d="M550 2601c-106-44-180-88-180-108 0-17 4-17 48 5 20 10 80 29 133 42 95 23 95 23 185 6 49-10 127-24 174-31 112-17 228-49 286-80 26-14 48-25 50-25 6 0 24 103 18 111-13 21-73 42-217 75-116 27-181 37-277 40l-125 5-95-40zm355-21c90-14 246-49 278-61 15-6 27-18 27-25 0-18-14-18-48 0-41 21-167 53-262 67-101 14-143 28-90 28 19 0 62-4 95-9zM2110 2604c-36-8-85-18-110-23-259-55-269-59-254-113 16-56 25-56 231-5 110 28 231 51 293 57 99 8 112 7 229-21 142-33 141-33 141-16 0 30-55 58-234 117-70 24-198 25-296 4zm65-49c-38-8-133-30-210-49-77-20-148-36-159-36-30 0-2 26 37 33 17 4 95 20 172 36s160 30 185 29c42 0 40-1-25-13zM696 2313c-49-13-186-116-186-139 0-21 9-17 64 29 88 75 118 88 206 94 45 3 80 2 80-3s-27-10-60-11c-49-1-71-7-113-33-46-28-97-85-97-108 0-12 46-51 103-89 49-31 134-53 211-53 41 0 206 74 206 92 0 43-105 139-192 175-29 12-44 22-34 23 11 0 57-18 103-40 86-42 168-112 197-169 9-17 23-31 31-31 23 0 18 14-24 67-72 89-114 122-206 160-79 33-102 38-180 40-49 1-99-1-109-4zm74-51c0-4-9-13-20-20-23-14-28-88-7-114 37-46 100-60 166-37 39 14 65 60 57 100s8 36 55-13c64-69 65-74 22-101-71-45-105-52-196-41-67 9-93 17-138 46-30 19-62 43-72 52-16 17-16 19 3 44 21 26 108 92 123 92 4 0 7-3 7-8zm118-34c18-18 15-42-7-62-26-24-72-17-82 12-16 43 56 83 89 50zM2099 2305c-83-17-155-41-195-66-45-27-123-114-140-154-17-42-17-45-1-45 7 0 21 17 30 38 22 51 91 119 152 150 71 36 178 62 258 62s140-24 238-96c33-25 64-43 67-40 10 11-67 81-120 110-104 56-167 65-289 41z"
                            transform="matrix(.1 0 0 -.1 0 386)"
                        ></path>
                        <path
                            d="M2045 2245c-38-14-71-25-73-25-14 0-112-107-112-122 0-13 23-29 87-59 80-37 95-41 168-41 101-1 169 26 251 99l58 52-45 40c-65 59-103 75-189 78-59 2-90-2-145-22zm130-60c0-40 0-40-39-40-51 0-67 22-42 60 14 21 24 26 49 23 30-3 32-5 32-43zm148 9c26-20 47-40 47-43 0-16-69-72-120-97-84-43-155-44-257-5-108 42-113 49-68 99 20 22 49 45 65 50 28 10 28 10 23-22-12-74 97-132 173-93 48 25 65 50 66 101 0 29 5 46 13 46 6 0 33-16 58-36zM1295 2240c-4-7-4-15 1-19 5-3 22-21 39-39l29-32 2-298 2-297-34-85c-18-46-31-86-29-88 14-14 34 16 58 84 27 79 27 80 27 360 0 155-3 294-6 310-8 39-78 122-89 104zM1640 2198l-34-42-7-160c-4-89-8-232-8-319l-1-157 36-71c24-48 39-68 46-61 6 6 1 26-15 58-44 89-50 134-38 335 6 100 11 224 11 274 0 90 1 92 35 132 38 45 42 53 23 53-7 0-29-19-48-42z"
                            transform="matrix(.1 0 0 -.1 0 386)"
                        ></path>
                        <path
                            d="M1227 1481c-17-31-27-64-27-90 0-36 6-47 38-77 54-52 75-57 139-39 45 13 60 14 89 3 31-11 40-10 65 5 27 15 32 15 45 2 25-25 110-19 161 10 44 26 47 34 44 95-2 40-49 142-62 134-5-2 1-28 13-57 37-94 36-123-7-151-22-14-28-15-47-2-39 24-88 28-135 10-36-14-49-15-85-4-56 16-104 14-138-7-27-15-29-15-58 8-26 20-31 31-31 69 0 31 7 58 24 85 28 46 30 55 12 55-8 0-26-22-40-49zM1310 949c-110-32-163-52-209-76-24-13-57-23-73-23-19 0-28-4-25-12 2-7 10-13 18-13s46-26 84-58c39-32 96-76 129-98 58-39 59-39 160-40 248-2 341 2 363 16 12 8 59 51 105 96 55 55 91 82 107 83 29 1 41 26 13 26-12 0-58 14-104 30-46 17-112 39-148 50s-78 24-93 29c-22 8-42 5-83-10l-54-20-58 20c-32 12-60 21-63 20-2 0-33-9-69-20zm143-34c38-19 51-19 89 1 17 9 45 16 62 16 33 0 205-49 219-62s-94-34-163-32c-40 1-83-5-112-15-44-16-48-16-106 5-38 14-84 22-128 23-38 0-87 6-109 13l-40 13 45 13c25 7 70 20 100 30 61 19 98 17 143-5zm-15-117c28-11 62-18 75-15 12 3 40 11 62 17 34 9 304 14 313 6 1-2-34-37-79-77l-82-74-213 2-214 1-68 49c-118 83-151 108-152 115 0 3 69 4 153 1 120-4 163-9 205-25z"
                            transform="matrix(.1 0 0 -.1 0 386)">
                        </path>
                    </g>
                </svg>
                <div id="expressivityMaskContainer">
                    <svg height="300" width="100" style={{ position: "absolute" }} id="faceExpresivityMask" transform="translate(-4, 0)" opacity="0.5">
                        <circle cx="205" cy="150" r="49%" transform="translate(-70, -20)" />
                    </svg>
                    <svg height="140" width="100" style={{ position: "absolute" }} transform="translate(107, -2)" id="upperFaceExpresivityMask" opacity="0.5">
                        <circle cx="0" cy="150" r="91%" transform="translate(-43, -20)" />
                    </svg>

                    <svg height="140" width="100" style={{ position: "absolute" }} transform="translate(107, 148)" id="lowerFaceExpresivityMask" opacity="0.5">
                        <circle cx="0" cy="150" r="91%" transform="translate(-43, -165)" />
                    </svg>
                </div>

                <svg height="300" width="200" style={{ position: "absolute" }} id="facePainExpresivityMask" >
                    <ellipse cx="0" cy="150" rx="38%" ry="35%" transform="translate(99, -20)" />
                </svg>

                <div id="asymetryMaskContainer">
                    <svg height="300" width="200" style={{ position: "absolute" }} id="faceAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" rx="38%" ry="35%" transform="translate(99, -20)" />
                    </svg>
                    <svg height="300" width="200" style={{ position: "absolute" }} id="leftEyeAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" ry="5%" rx="14%" transform="translate(58, -31)" />
                    </svg>
                    <svg height="300" width="200" style={{ position: "absolute" }} id="rightEyeAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" ry="5%" rx="14%" transform="translate(144, -31)" />
                    </svg>
                    <svg height="300" width="200" style={{ position: "absolute" }} id="leftEyebrowAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" ry="3%" rx="15%" transform="translate(60, -60)" />
                    </svg>
                    <svg height="300" width="200" style={{ position: "absolute" }} id="rightEyebrowAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" ry="3%" rx="15%" transform="translate(144, -60)" />
                    </svg>
                    <svg height="300" width="200" style={{ position: "absolute" }} id="mouthAsymetryMask" opacity="0.5">
                        <ellipse cx="0" cy="150" rx="20%" ry="7%" transform="translate(100, 55)" />
                    </svg>
                </div>

                <div id="AUHighlightsContainer">
                    <svg height="20" width="20" style={{ position: "absolute" }} id="au12RightHighlight" transform="translate(125, 180)" className="hap_highlight con_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />

                    </svg>
                    <svg height="20" width="20" style={{ position: "absolute" }} id="au12LeftHighlight" transform="translate(56, 180)" className="hap_highlight con_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>

                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(91, 226)" id="au26Highlight" className="sur_highlight fea_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(58, 145)" id="au9RightHighlight" className='dig_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(123, 145)" id="au9LeftHighlight" className='dig_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(43, 90)" id="au4LeftHighlight" className="sad_highlight fea_highlight ang_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(141, 90)" id="au4RightHighlight" className="sad_highlight fea_highlight ang_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(148, 65)" id="au1RightHighlight" className="sad_highlight sur_highlight fea_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(35, 65)" id="au1LeftHighlight" className="sad_highlight sur_highlight fea_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(118, 68)" id="au2RightHighlight" className="sur_highlight fea_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(68, 68)" id="au2LeftHighlight" className="sur_highlight fea_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(162, 104)" id="au5RightHighlight" className="sur_highlight fea_highlight ang_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(16, 104)" id="au5LeftHighlight" className="sur_highlight fea_highlight ang_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(158, 158), rotate(-90)" id="au6RightHighlight" className="hap_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(23, 158),rotate(90)" id="au6LeftHighlight" className="hap_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(135, 188)" id="au20LeftHighlight" className='fea_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(48, 188)" id="au20RightHighlight" className='fea_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(134, 200), rotate(-90)" id="au15RightHighlight" className="sad_highlight dig_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(47, 201), rotate(90)" id="au15LeftHighlight" className="sad_highlight dig_highlight emotion_highlight">
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(65, 212), rotate(45)" id="au16LeftHighlight" className='dig_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(115, 212), rotate(-45)" id="au16RightHighlight" className='dig_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(108, 180), rotate(45)" id="au23RightUpHighlight" className='ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(72, 180), rotate(-45)" id="au23leftUpHighlight" className='ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(78, 215), rotate(-45)" id="au23LeftDownHighlight" className='ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(102, 215),  rotate(45)" id="au23RightDownHighlight" className='ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>

                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(28, 125), rotate(-45)" id="au7LeftHighlight" className='fea_highlight ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} transform="translate(150, 125),  rotate(45)" id="au7RightHighlight" className='fea_highlight ang_highlight emotion_highlight'>
                        <circle cx="10" cy="10" r="50%" fill="purple" opacity="0.4" />
                    </svg>

                </div>

                <div id="AUContainer" style={{ position: "absolute" }}>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU12" viewBox="0 0 20 20" transform="translate(127, 180), rotate(-45)" id="au12Left">
                        <path id="au12Left_path" strokeWidth="12%" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z" />
                        <text className='AUtooltip' opacity='0' x="90%" y="1%" transform="rotate(45)" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >12</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU12" viewBox="0 0 20 20" transform="translate(54, 182),  rotate(45)" id="au12Right">
                        <path id="au12Right_path" strokeWidth="12%" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z" />
                        <text className='AUtooltip' opacity='0' x="0%" y="50%" transform="rotate(-45)" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >12</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-down AU26" viewBox="0 0 16 16" transform="translate(93, 226)" id="au26">
                        <path id="au26_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >26</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU09" viewBox="0 0 20 20" transform="translate(60, 146)" id="au9Right">
                        <path id="au9Right_path" strokeWidth="12%" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >9</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU09" viewBox="0 0 20 20" transform="translate(125, 147)" id="au9Left">
                        <path id="au9Left_path" strokeWidth="12%" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">9</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU04" viewBox="0 0 20 20" transform="translate(45, 89)" id="au4Left">
                        <path id="au4Left_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >4</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU04" viewBox="0 0 20 20" transform="translate(143, 89)" id="au4Right">
                        <path id="au4Right_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >4</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU01" viewBox="0 0 16 16" transform="translate(150, 68)" id="au1Right">
                        <path id="au1Right_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >1</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU01" viewBox="0 0 16 16" transform="translate(37, 67)" id="au1Left">
                        <path id="au1Left_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >1</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU02" viewBox="0 0 16 16" transform="translate(120, 70)" id="au2Right">
                        <path id="au2Right_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >2</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU02" viewBox="0 0 16 16" transform="translate(70, 70)" id="au2Left">
                        <path id="au2Left_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >2</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU05" viewBox="0 0 16 16" transform="translate(165, 105)" id="au5Right">
                        <path id="au5Right_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >5</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU05" viewBox="0 0 16 16" transform="translate(18, 105)" id="au5Left">
                        <path id="au5Left_path" strokeWidth="12%" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >5</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU06" viewBox="0 0 16 16" transform="translate(160, 160), rotate(-90)" id="au6Right">
                        <path id="au6Right_path" strokeWidth="12%" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z" />
                        <text className='AUtooltip' opacity='0' x="30%" y="-50%" transform='rotate(90)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">6</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-up AU06" viewBox="0 0 16 16" transform="translate(25, 160),rotate(90)" id="au6Left">
                        <path id="au6Left_path" strokeWidth="12%" d="M14.5 1.5a.5.5 0 0 1 .5.5v4.8a2.5 2.5 0 0 1-2.5 2.5H2.707l3.347 3.346a.5.5 0 0 1-.708.708l-4.2-4.2a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 8.3H12.5A1.5 1.5 0 0 0 14 6.8V2a.5.5 0 0 1 .5-.5z" />
                        <text className='AUtooltip' opacity='0' x="-30%" y="50%" transform='rotate(-90)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >6</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU20" viewBox="0 0 20 20" transform="translate(135, 190)" id="au20Left">
                        <path id="au20left_path" strokeWidth="12%" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >20</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU20" viewBox="0 0 20 20" transform="translate(50, 190)" id="au20Right">
                        <path id="au20Right_path" strokeWidth="12%" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z" />
                        <text className='AUtooltip' opacity='0' x="40%" y="50%" textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >20</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU15" viewBox="0 0 20 20" transform="translate(136, 200), rotate(-90)" id="au15Right">
                        <path id="au15Right_path" strokeWidth="12%" d="M14.5 1.5a.5.5 0 0 1 .5.5v4.8a2.5 2.5 0 0 1-2.5 2.5H2.707l3.347 3.346a.5.5 0 0 1-.708.708l-4.2-4.2a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 8.3H12.5A1.5 1.5 0 0 0 14 6.8V2a.5.5 0 0 1 .5-.5z" />
                        <text className='AUtooltip' opacity='0' x="30%" y="-50%" transform='rotate(90)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >15</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU15" viewBox="0 0 20 20" transform="translate(43, 204), rotate(90)" id="au15Left">
                        <path id="au15Left_path" strokeWidth="12%" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z" />
                        <text className='AUtooltip' opacity='0' x="-30%" y="50%" transform='rotate(-90)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >15</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-down AU17" viewBox="0 0 16 16" transform="translate(67, 215), rotate(45)" id="au16Left">
                        <path id="au16Left_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="0%" y="80%" transform='rotate(-45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >16</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-down AU17" viewBox="0 0 16 16" transform="translate(117, 215), rotate(-45)" id="au16Right">
                        <path id="au16Right_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="80%" y="10%" transform='rotate(45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >16</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-down AU23" viewBox="0 0 16 16" transform="translate(112, 180), rotate(45)" id="au23RightUp">
                        <path id="au23RightUp_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="0%" y="80%" transform='rotate(-45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">23</text>
                    </svg>
                    <svg width="16" height="16" style={{ position: "absolute" }} className="bi bi-arrow-down AU23" viewBox="0 0 16 16" transform="translate(72, 180), rotate(-45)" id="au23leftUp">
                        <path id="au23LeftUp_path" strokeWidth="12%" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z" />
                        <text className='AUtooltip' opacity='0' x="80%" y="10%" transform='rotate(45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">23</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU23" viewBox="0 0 20 20" transform="translate(80, 217), rotate(-45)" id="au23LeftDown">
                        <path id="au23LeftDown_path" strokeWidth="12%" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z" />
                        <text className='AUtooltip' opacity='0' x="80%" y="10%" transform='rotate(45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">23</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU23" viewBox="0 0 20 20" transform="translate(103, 220),  rotate(45)" id="au23RightDown">
                        <path id="au23RightDown_path" strokeWidth="12%" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z" />
                        <text className='AUtooltip' opacity='0' x="0%" y="80%" transform='rotate(-45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >23</text>
                    </svg>

                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-right AU07" viewBox="0 0 20 20" transform="translate(30, 125), rotate(-45)" id="au7Left">
                        <path id="au7Left_path" strokeWidth="12%" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z" />
                        <text className='AUtooltip' opacity='0' x="80%" y="20%" transform='rotate(45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2">23</text>
                    </svg>
                    <svg width="20" height="20" style={{ position: "absolute" }} className="bi bi-arrow-left AU07" viewBox="0 0 20 20" transform="translate(150, 127),  rotate(45)" id="au7Right">
                        <path id="au7Right_path" strokeWidth="12%" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z" />
                        <text className='AUtooltip' opacity='0' x="0%" y="80%" transform='rotate(-45)' textAnchor="middle" fontSize="10px" stroke="black" strokeWidth="0.2" >23</text>
                    </svg>
                </div>


                <div id="headMovementMaskContainer">
                    <svg width="32" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(85, -25)" id="pitchUp"
                    >
                        <path id="pitchUp_path" strokeWidth="4px" d="M17.504 26.025l.001-14.287 6.366 6.367L26 15.979 15.997 5.975 6 15.971 8.129 18.1l6.366-6.368v14.291z" />
                    </svg>

                    <svg width="302" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(-50, 260)" id="pitchDown">
                        <path id="pitchDown_path" strokeWidth="4px" d="m14.496 5.975l-.001 14.287-6.366-6.367L6 16.021l10.003 10.004L26 16.029 23.871 13.9l-6.366 6.368V5.977z" />
                    </svg>

                    <svg width="32" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(170, 0), rotate(-45)" id="rollRight">
                        <path id="rollRight_path" strokeWidth="4px" d="M5.975 17.504l14.287.001-6.367 6.366L16.021 26l10.004-10.003L16.029 6l-2.128 2.129 6.367 6.366H5.977z" />
                    </svg>

                    <svg width="32" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(5, 0), rotate(45)" id="rollLeft">
                        <path id="rollLeft_path" strokeWidth="4px" d="M26.025 14.496l-14.286-.001 6.366-6.366L15.979 6 5.975 16.003 15.971 26l2.129-2.129-6.367-6.366h14.29z" />
                    </svg>
                    <svg width="32" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(-30, 120)" id="yawLeft">
                        <path id="yawLeft_path" strokeWidth="4px" d="M26.025 14.496l-14.286-.001 6.366-6.366L15.979 6 5.975 16.003 15.971 26l2.129-2.129-6.367-6.366h14.29z" />
                    </svg>
                    <svg width="32" height="32" style={{ position: "absolute" }} className="bi bi-arrow-down" viewBox="0 0 32 32" transform="translate(200, 120)" id="yawRight">
                        <path id="yawRight_path" strokeWidth="4px" d="M5.975 17.504l14.287.001-6.367 6.366L16.021 26l10.004-10.003L16.029 6l-2.128 2.129 6.367 6.366H5.977z" />
                    </svg>
                </div>
                <div id="tooltip" display="none"
                    style={{ position: "absolute", display: "none", fontSize: "0.6rem", background: "white", border: "1px solid black", padding: "2px" }}></div>
            </div>
            <button type="button" className='btn btn-outline-secondary btn-sm' style={{ width: "max-content", position: "absolute", left: "0", }} onClick={() => exportComponentAsJPEG(componentRef)}>
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-printer" viewBox="0 0 16 16">
                    <path d="M2.5 8a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1z" />
                    <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v3a2 2 0 0 0 2 2h1v1a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-1h1a2 2
         0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2H5zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4V3zm1 5a2 2 0 0 0-2
         2v1H2a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-1v-1a2 2 0 0 0-2-2H5zm7 2v3a1 1 0 0
          1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1z" />
                </svg>
            </button>
        </React.Fragment>
    );

}

export default HeadSVG;
