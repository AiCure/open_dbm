"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[1018],{5318:function(e,t,r){r.d(t,{Zo:function(){return u},kt:function(){return f}});var a=r(7378);function n(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,a)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){n(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function s(e,t){if(null==e)return{};var r,a,n=function(e,t){if(null==e)return{};var r,a,n={},o=Object.keys(e);for(a=0;a<o.length;a++)r=o[a],t.indexOf(r)>=0||(n[r]=e[r]);return n}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)r=o[a],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(n[r]=e[r])}return n}var l=a.createContext({}),p=function(e){var t=a.useContext(l),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},u=function(e){var t=p(e.components);return a.createElement(l.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},d=a.forwardRef((function(e,t){var r=e.components,n=e.mdxType,o=e.originalType,l=e.parentName,u=s(e,["components","mdxType","originalType","parentName"]),d=p(r),f=n,h=d["".concat(l,".").concat(f)]||d[f]||c[f]||o;return r?a.createElement(h,i(i({ref:t},u),{},{components:r})):a.createElement(h,i({ref:t},u))}));function f(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var o=r.length,i=new Array(o);i[0]=d;var s={};for(var l in t)hasOwnProperty.call(t,l)&&(s[l]=t[l]);s.originalType=e,s.mdxType="string"==typeof e?e:n,i[1]=s;for(var p=2;p<o;p++)i[p]=r[p];return a.createElement.apply(null,i)}return a.createElement.apply(null,r)}d.displayName="MDXCreateElement"},9691:function(e,t,r){r.r(t),r.d(t,{assets:function(){return m},contentTitle:function(){return f},default:function(){return g},frontMatter:function(){return d},metadata:function(){return h},toc:function(){return v}});var a=r(5318),n=Object.defineProperty,o=Object.defineProperties,i=Object.getOwnPropertyDescriptors,s=Object.getOwnPropertySymbols,l=Object.prototype.hasOwnProperty,p=Object.prototype.propertyIsEnumerable,u=(e,t,r)=>t in e?n(e,t,{enumerable:!0,configurable:!0,writable:!0,value:r}):e[t]=r,c=(e,t)=>{for(var r in t||(t={}))l.call(t,r)&&u(e,r,t[r]);if(s)for(var r of s(t))p.call(t,r)&&u(e,r,t[r]);return e};const d={id:"opendbm-docker-output",title:"Docker Output"},f=void 0,h={unversionedId:"opendbm-docker-output",id:"version-2.1/opendbm-docker-output",title:"Docker Output",description:"OpenDBM Output",source:"@site/versioned_docs/version-2.1/opendbm-docker-output.md",sourceDirName:".",slug:"/opendbm-docker-output",permalink:"/open_dbm/docs/opendbm-docker-output",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/../docs/opendbm-docker-output.md",tags:[],version:"2.1",lastUpdatedAt:1664889437,formattedLastUpdatedAt:"10/4/2022",frontMatter:{id:"opendbm-docker-output",title:"Docker Output"},sidebar:"docs",previous:{title:"Docker Usage",permalink:"/open_dbm/docs/opendbm-docker-usage"},next:{title:"More Resources",permalink:"/open_dbm/docs/more-resources"}},m={},v=[{value:"OpenDBM Output",id:"opendbm-output",level:2},{value:"Derived Variables",id:"derived-variables",level:2},{value:"Raw Variables",id:"raw-variables",level:2},{value:"OpenFace output",id:"openface-output",level:3},{value:"Speech transcription",id:"speech-transcription",level:3}],b={toc:v};function g(e){var t,r=e,{components:n}=r,u=((e,t)=>{var r={};for(var a in e)l.call(e,a)&&t.indexOf(a)<0&&(r[a]=e[a]);if(null!=e&&s)for(var a of s(e))t.indexOf(a)<0&&p.call(e,a)&&(r[a]=e[a]);return r})(r,["components"]);return(0,a.kt)("wrapper",(t=c(c({},b),u),o(t,i({components:n,mdxType:"MDXLayout"}))),(0,a.kt)("h2",c({},{id:"opendbm-output"}),"OpenDBM Output"),(0,a.kt)("p",null,"In the previous chapter, we went over how to process data using OpenDBM and learned that when we do so, we save a folder called ",(0,a.kt)("strong",{parentName:"p"},"output")," in the location we specify. This chapter is all about what\u2019s in that folder and all the wonderful things we can do with it. "),(0,a.kt)("p",null,"The first thing you\u2019ll see is that the ",(0,a.kt)("strong",{parentName:"p"},"output")," folder is divided into ",(0,a.kt)("inlineCode",{parentName:"p"},"raw_variables")," and ",(0,a.kt)("inlineCode",{parentName:"p"},"derived_variables"),". As Chapter 5 explains, for each biomarker, both ",(0,a.kt)("strong",{parentName:"p"},"raw variables")," and ",(0,a.kt)("strong",{parentName:"p"},"derived variables")," are calculated. Raw variables are often frame-wise values containing measurements according to the temporal resolution of the inputted file (e.g. happiness expressivity in each frame of video in an inputted video file or audio intensity for each audio frame in an audio file). Derived variables are abstractions of their respective raw variables (e.g. average happiness expressivity across a video or standard deviation of audio intensity over the course of the audio file). Chapter 5  goes into more detail and lists all raw and derived biomarker variables. The purpose of this chapter is to first just explain the structure of the data output from OpenDBM."),(0,a.kt)("h2",c({},{id:"derived-variables"}),"Derived Variables"),(0,a.kt)("p",null,"For derived variables, a single CSV file is outputted. This CSV file, named derived_output.csv, contains a row for each video/audio file that was inputted. If only a single file was processed, the CSV file will have only one row. If several were inputted, then several rows will be outputted."),(0,a.kt)("p",null,"And, in case you forgot what files and/or excel sheets look like, here are some illustrations:"),(0,a.kt)("figure",null,(0,a.kt)("img",{src:"../docs/assets/derived_var_1.png",width:"1000",alt:"Screenshot of output file"}),(0,a.kt)("figcaption",null,"Screenshot of output file.")),(0,a.kt)("p",null,"Essentially, the derived variables CSV file is the best place to go for most simple analyses. ",(0,a.kt)("a",c({parentName:"p"},{href:"https://www.youtube.com/watch?v=QQY_QA1Y5BM"}),"In this instructional video"),", we conduct a sample data analysis in a made-up experiment and use the derived variable output to test effects of a \u2018treatment\u2019 on emotional expressivity in the face."),(0,a.kt)("h2",c({},{id:"raw-variables"}),"Raw Variables"),(0,a.kt)("p",null,"The raw variable data structure is slightly more complicated. The hierarchy is described below:"),(0,a.kt)("figure",null,(0,a.kt)("img",{src:"../docs/assets/raw_variables1.png",width:"1000",alt:"Variables hierarchy"}),(0,a.kt)("figcaption",null,"Variables hierarchy")),(0,a.kt)("p",null,"Under the ",(0,a.kt)("strong",{parentName:"p"},"raw_variables")," folder, there will be a folder for each ",(0,a.kt)("strong",{parentName:"p"},"filename"),". Under each filename\u2019s folder, there will be a folder for each DBM group as described in Section 3.1.3 and Chapter 5: ",(0,a.kt)("strong",{parentName:"p"},"facial, acoustic, speech, and movement"),". In each of the DBM group folders, there will be sub- folders for biomarkers e.g. the acoustic ",(0,a.kt)("strong",{parentName:"p"},"intensity")," folder has data for audio intensity (Section 5.2.3). WIthin the biomarker folder will be a CSV file that contains frame-by-frame values for variables in it. In the case of audio intensity, the audio intensity raw variable CSV file has the ",(0,a.kt)("inlineCode",{parentName:"p"},"aco_int")," values in decibels for ",(0,a.kt)("em",{parentName:"p"},"each frame of audio")," in the video file, whereas the ",(0,a.kt)("inlineCode",{parentName:"p"},"aco_int_mean")," ",(0,a.kt)("em",{parentName:"p"},"derived")," variable would simply have the mean intensity of all frames in that file."),(0,a.kt)("h3",c({},{id:"openface-output"}),"OpenFace output"),(0,a.kt)("p",null,"As has been mentioned before, OpenDBM relies on OpenFace for a lot of its measurements. In case the user is interested in going upstream to that level of data, the ",(0,a.kt)("strong",{parentName:"p"},"<filename",">","_openface")," folder just contains the OpenFace output, including action units, eye gaze data, and head movement calculations. Some other facial and movement measurements are acquired using facial landmark data, which is also an output from OpenFace, though relies on a different model. That OpenFace data is saved in ",(0,a.kt)("strong",{parentName:"p"},"<filename",">","_openface_lmk"),". Both of the raw OpenFace output folders are there in case a user is interested in building their own raw / derived variables. If the user is simply interested in using OpenDBM\u2019s existing measures, they can ignore these folders."),(0,a.kt)("h3",c({},{id:"speech-transcription"}),"Speech transcription"),(0,a.kt)("p",null,"Assuming the user used the ",(0,a.kt)("inlineCode",{parentName:"p"},"--tr=on")," option when executing the processing command, OpenDBM will save the text for any speech that was transcribed in a folder called ",(0,a.kt)("strong",{parentName:"p"},"deepspeech"),". All transcription is done using an open source software package called ",(0,a.kt)("a",c({parentName:"p"},{href:"https://github.com/mozilla/DeepSpeech"}),"DeepSpeech")," This folder simply contains the output that DeepSpeech provides. Similar to the OpenFace output, the speech transcription is saved in case the user wants to dig deeper and perhaps derive their own measures. We do ask that you read Section 3.1.4 before you save speech transcriptions."))}g.isMDXComponent=!0}}]);