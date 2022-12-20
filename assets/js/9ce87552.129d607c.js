"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[7853],{5318:function(e,t,o){o.d(t,{Zo:function(){return s},kt:function(){return m}});var n=o(7378);function r(e,t,o){return t in e?Object.defineProperty(e,t,{value:o,enumerable:!0,configurable:!0,writable:!0}):e[t]=o,e}function a(e,t){var o=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),o.push.apply(o,n)}return o}function i(e){for(var t=1;t<arguments.length;t++){var o=null!=arguments[t]?arguments[t]:{};t%2?a(Object(o),!0).forEach((function(t){r(e,t,o[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(o)):a(Object(o)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(o,t))}))}return e}function l(e,t){if(null==e)return{};var o,n,r=function(e,t){if(null==e)return{};var o,n,r={},a=Object.keys(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||(r[o]=e[o]);return r}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||Object.prototype.propertyIsEnumerable.call(e,o)&&(r[o]=e[o])}return r}var d=n.createContext({}),p=function(e){var t=n.useContext(d),o=t;return e&&(o="function"==typeof e?e(t):i(i({},t),e)),o},s=function(e){var t=p(e.components);return n.createElement(d.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},u=n.forwardRef((function(e,t){var o=e.components,r=e.mdxType,a=e.originalType,d=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),u=p(o),m=r,h=u["".concat(d,".").concat(m)]||u[m]||c[m]||a;return o?n.createElement(h,i(i({ref:t},s),{},{components:o})):n.createElement(h,i({ref:t},s))}));function m(e,t){var o=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var a=o.length,i=new Array(a);i[0]=u;var l={};for(var d in t)hasOwnProperty.call(t,d)&&(l[d]=t[d]);l.originalType=e,l.mdxType="string"==typeof e?e:r,i[1]=l;for(var p=2;p<a;p++)i[p]=o[p];return n.createElement.apply(null,i)}return n.createElement.apply(null,o)}u.displayName="MDXCreateElement"},3990:function(e,t,o){o.r(t),o.d(t,{assets:function(){return f},contentTitle:function(){return m},default:function(){return v},frontMatter:function(){return u},metadata:function(){return h},toc:function(){return _}});var n=o(5318),r=Object.defineProperty,a=Object.defineProperties,i=Object.getOwnPropertyDescriptors,l=Object.getOwnPropertySymbols,d=Object.prototype.hasOwnProperty,p=Object.prototype.propertyIsEnumerable,s=(e,t,o)=>t in e?r(e,t,{enumerable:!0,configurable:!0,writable:!0,value:o}):e[t]=o,c=(e,t)=>{for(var o in t||(t={}))d.call(t,o)&&s(e,o,t[o]);if(l)for(var o of l(t))p.call(t,o)&&s(e,o,t[o]);return e};const u={id:"opendbm-python-api-add-new-variable",title:"OpenDBM API - Add New Variable"},m=void 0,h={unversionedId:"opendbm-python-api-add-new-variable",id:"opendbm-python-api-add-new-variable",title:"OpenDBM API - Add New Variable",description:"Prerequisites read",source:"@site/extras/opendbm-python-api-add-new-variable.md",sourceDirName:".",slug:"/opendbm-python-api-add-new-variable",permalink:"/open_dbm/extras/opendbm-python-api-add-new-variable",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/extras/opendbm-python-api-add-new-variable.md",tags:[],version:"current",lastUpdatedAt:1671547565,formattedLastUpdatedAt:"12/20/2022",frontMatter:{id:"opendbm-python-api-add-new-variable",title:"OpenDBM API - Add New Variable"},sidebar:"extras",previous:{title:"OpenDBM API - Unit Test",permalink:"/open_dbm/extras/opendbm-python-api-unittest"},next:{title:"Contributing Overview",permalink:"/open_dbm/extras/overview"}},f={},_=[{value:"Prerequisites read",id:"prerequisites-read",level:4},{value:"Scenario",id:"scenario",level:2},{value:"1. Consider the category of pose detector",id:"1-consider-the-category-of-pose-detector",level:3},{value:"2. Create the core module",id:"2-create-the-core-module",level:3},{value:"3. Store the Model File",id:"3-store-the-model-file",level:3},{value:"4. Add pose_detection to Python API",id:"4-add-pose_detection-to-python-api",level:3},{value:"a. Create the private module.",id:"a-create-the-private-module",level:4},{value:"b. Create a class inside the private module",id:"b-create-a-class-inside-the-private-module",level:4},{value:"c. Export the newly created module to api.py",id:"c-export-the-newly-created-module-to-apipy",level:4},{value:"Import the private pose module",id:"import-the-private-pose-module",level:4},{value:"Initiate the model class",id:"initiate-the-model-class",level:4},{value:"Add the new pose variable to models dictionary.",id:"add-the-new-pose-variable-to-models-dictionary",level:4},{value:"Create a new method to get the result of pose_detection.",id:"create-a-new-method-to-get-the-result-of-pose_detection",level:4},{value:"5. Add pose_detection to unit test (pytest).",id:"5-add-pose_detection-to-unit-test-pytest",level:3}],y={toc:_};function v(e){var t,o=e,{components:r}=o,s=((e,t)=>{var o={};for(var n in e)d.call(e,n)&&t.indexOf(n)<0&&(o[n]=e[n]);if(null!=e&&l)for(var n of l(e))t.indexOf(n)<0&&p.call(e,n)&&(o[n]=e[n]);return o})(o,["components"]);return(0,n.kt)("wrapper",(t=c(c({},y),s),a(t,i({components:r,mdxType:"MDXLayout"}))),(0,n.kt)("h4",c({},{id:"prerequisites-read"}),"Prerequisites read"),(0,n.kt)("ul",null,(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",c({parentName:"li"},{href:"opendbm-python-api"}),"OpenDBM Python API")),(0,n.kt)("li",{parentName:"ul"},(0,n.kt)("a",c({parentName:"li"},{href:"opendbm-python-api-unittest"}),"OpenDBM API - Unit Test"))),(0,n.kt)("figure",null,(0,n.kt)("img",{src:"../img/extras/api-add-var-5.png",width:"70%",alt:"OpenDBM Folder"}),(0,n.kt)("figcaption",null,"Simple Architecure Diagram on How to Add New Module")),(0,n.kt)("h2",c({},{id:"scenario"}),"Scenario"),(0,n.kt)("p",null,"We want to add a pose detector in OpenDBM API. The model file that we will use to do the pose detector is 2 GB in size. Here is the steps on how to do it"),(0,n.kt)("h3",c({},{id:"1-consider-the-category-of-pose-detector"}),"1. Consider the category of pose detector"),(0,n.kt)("p",null,"We have existing dbm group folders that consist of Facial, Movement, Speech, and Verbal Acoustics.\nCompared to other categories, it will make sense if the pose detector is added to the Movement group. So with that in mind,\nwe will create the core module in the movement folder, to be precise, in  ",(0,n.kt)("strong",{parentName:"p"},"\u201cdbm_lib/dbm_features/raw_features/movement\u201d"),"."),(0,n.kt)("p",null,"For the module name, there is no convention on how to create the module name. The only important thing is it needs to be explicit.\nIn this case, we will name our module ",(0,n.kt)("strong",{parentName:"p"},"pose_detection.py")),(0,n.kt)("h3",c({},{id:"2-create-the-core-module"}),"2. Create the core module"),(0,n.kt)("p",null,"In general, this module is where we use the model to generate the final output as a pandas dataframe object."),(0,n.kt)("p",null,"Specifically, The final function of the pose_detection module needs to have two capabilities:"),(0,n.kt)("ol",null,(0,n.kt)("li",{parentName:"ol"},"Keyword argument for saving the output.\nThis is essential because you need the module to be used with the Docker command approach. To develop this,\nplease use the save_output function from the util library so you don\u2019t have to create the same function."),(0,n.kt)("li",{parentName:"ol"},"Should return the final output as pandas dataframe.")),(0,n.kt)("p",null,"In code, the end of the final function should look like this."),(0,n.kt)("figure",null,(0,n.kt)("img",{src:"../img/extras/api-add-var-1.png",width:"100%",alt:"OpenDBM Folder"}),(0,n.kt)("figcaption",null,"End Code of eye_blink Module in Movement dbm group")),(0,n.kt)("h3",c({},{id:"3-store-the-model-file"}),"3. Store the Model File"),(0,n.kt)("p",null,"Now store your model file in the pkg/local folder, depending on the file size (see pkg folder explanation here). You\nalso need to create a function where openDBM API can download the model file if the user doesn\u2019t have it yet.\nThe function must be made in the ",(0,n.kt)("strong",{parentName:"p"},"util.py")," module in the api_lib folder. "),(0,n.kt)("h3",c({},{id:"4-add-pose_detection-to-python-api"}),"4. Add pose_detection to Python API"),(0,n.kt)("p",null,"Below are the steps to add your newly created pose_detection module to Python API that lives inside api_lib folder."),(0,n.kt)("h4",c({},{id:"a-create-the-private-module"}),"a. Create the private module."),(0,n.kt)("p",null,"Based on our scenario, we should create \u201c_pose_detection.py\u201d in the movement folder inside api_lib "),(0,n.kt)("h4",c({},{id:"b-create-a-class-inside-the-private-module"}),"b. Create a class inside the private module"),(0,n.kt)("p",null,"If we look at all the private modules, the code has the same pattern as others. So all we need to do is to modify it a little bit."),(0,n.kt)("p",null,"Below is the code inside \u201c_eye_blink.py\u201d inside the movement folder."),(0,n.kt)("figure",null,(0,n.kt)("img",{src:"../img/extras/api-add-var-2.png",width:"100%",alt:"_eye_blink.py"}),(0,n.kt)("figcaption",null,"_eye_blink.py")),(0,n.kt)("p",null,"As a starter, we copy-paste all codes from \u201c_eye_blink.py\u201d to \u201c_pose_detection.py\u201d. Then in;"),(0,n.kt)("ul",null,(0,n.kt)("li",{parentName:"ul"},"Line 1: change DLIB_SHAPE_MODEL to POSE_DETECTION_MODEL. This object is a path to where the Pose detector model lives."),(0,n.kt)("li",{parentName:"ul"},"Line 2: change the import module from eye_blink to pose_detection, and also change run_eye_blink to your final function name (ex: run_pose_detection)"),(0,n.kt)("li",{parentName:"ul"},"Line 5: Change the class name from EyeBlink to PoseDetection"),(0,n.kt)("li",{parentName:"ul"},"Line 8: create a list that contains the name of the numerical field of your processed dataframe."),(0,n.kt)("li",{parentName:"ul"},"Line 11: change the _fit_transform method to return the result of your function, in this case, run_pose_detection(args1,args2, \u2026)")),(0,n.kt)("p",null,"The final codes in ",(0,n.kt)("strong",{parentName:"p"},"_pose_detection.py")," should be look like this, for example;"),(0,n.kt)("pre",null,(0,n.kt)("code",c({parentName:"pre"},{className:"language-python"}),'from opendbm.api_lib.model import POSE_DETECTION_MODEL, VideoModel\nfrom opendbm.dbm_lib.dbm_features.raw_features.movement.pose_detection import run_pose_detection\n\n\nclass PoseDetection(VideoModel):\n    def __init__(self):\n        super().__init__()\n        self._params = ["mov_pose_head", "mov_pose_body", "mov_pose_hand", "mov_pose_foot"]\n\n    def _fit_transform(self, path):\n        return run_pose_detection(path, ".", self.r_config, POSE_DETECTION_MODEL, save=False)\n')),(0,n.kt)("h4",c({},{id:"c-export-the-newly-created-module-to-apipy"}),"c. Export the newly created module to api.py"),(0,n.kt)("p",null,"Now we go and take a look at codes in module api.py. After that, all we have to do is add pose_detection with the following steps:"),(0,n.kt)("h4",c({},{id:"import-the-private-pose-module"}),"Import the private pose module"),(0,n.kt)("p",null,"Following the pattern, we just need to add ",(0,n.kt)("strong",{parentName:"p"},"from ._pose_detection import PoseDetection")),(0,n.kt)("pre",null,(0,n.kt)("code",c({parentName:"pre"},{className:"language-python"}),"from ._eye_blink import EyeBlink\nfrom ._eye_gaze import EyeGaze\nfrom ._facial_tremor import FacialTremor\nfrom ._head_movement import HeadMovement\nfrom ._vocal_tremor import VocalTremor\nfrom ._pose_detection import PoseDetection # <-- new code added for pose_detection\n")),(0,n.kt)("h4",c({},{id:"initiate-the-model-class"}),"Initiate the model class"),(0,n.kt)("p",null,"Following the pattern, create a new variable in a new line ",(0,n.kt)("strong",{parentName:"p"},"self._pose_detection = PoseDetection()")),(0,n.kt)("pre",null,(0,n.kt)("code",c({parentName:"pre"},{className:"language-python"}),"class Movement(VideoModel):\n    def __init__(self):\n        super().__init__()\n        self._eye_blink = EyeBlink()\n        self._eye_gaze = EyeGaze()\n        self._facial_tremor = FacialTremor()\n        self._head_movement = HeadMovement()\n        self._vocal_tremor = VocalTremor()\n        self._pose_detection = PoseDetection() # <-- new code added for pose_detection\n")),(0,n.kt)("h4",c({},{id:"add-the-new-pose-variable-to-models-dictionary"}),"Add the new pose variable to models dictionary."),(0,n.kt)("pre",null,(0,n.kt)("code",c({parentName:"pre"},{className:"language-python"}),'self._models = OrderedDict(\n            {\n                "eye_blink": self._eye_blink,\n                "eye_gaze": self._eye_gaze,\n                "facial_tremor": self._facial_tremor,\n                "head_movement": self._head_movement,\n                "vocal_tremor": self._vocal_tremor,\n                "pose_detection": self._pose_detection # <-- new code added for pose detection\n            }\n        )\n')),(0,n.kt)("h4",c({},{id:"create-a-new-method-to-get-the-result-of-pose_detection"}),"Create a new method to get the result of pose_detection."),(0,n.kt)("p",null,"By following the function pattern in the code below, our function name will be ",(0,n.kt)("strong",{parentName:"p"},"get_pose_detection"),", which will return ",(0,n.kt)("strong",{parentName:"p"},"self._pose_detection")),(0,n.kt)("pre",null,(0,n.kt)("code",c({parentName:"pre"},{className:"language-python"}),'    def get_vocal_tremor(self):\n        """\n        Get the model object of Vocal Tremor\n        Returns:\n        self: object\n            Model Object\n        """\n        return self._vocal_tremor\n\n### Below is the new code to get the result of pose_detection\n    def get_pose_detection(self):\n        """\n        Get the model object of Pose Detection\n        Returns:\n        self: object\n            Model Object\n        """\n        return self.pose_detection\n')),(0,n.kt)("p",null,"That is how to add a new component to OpenDBM API. The only leftover is,"),(0,n.kt)("h3",c({},{id:"5-add-pose_detection-to-unit-test-pytest"}),"5. Add pose_detection to unit test (pytest)."),(0,n.kt)("p",null,"Considering you have already read the Unit test design, you need to create a function to test your newly created API."),(0,n.kt)("p",null,"In our case, in \u201ctest_api_movement.py,\u201d we will create a test function named \u201ctest_get_pose_detection,\u201d and you should configure your unit testing there."))}v.isMDXComponent=!0}}]);