"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[7264],{5318:function(e,t,a){a.d(t,{Zo:function(){return p},kt:function(){return u}});var n=a(7378);function r(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function o(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function i(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?o(Object(a),!0).forEach((function(t){r(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):o(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function l(e,t){if(null==e)return{};var a,n,r=function(e,t){if(null==e)return{};var a,n,r={},o=Object.keys(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||(r[a]=e[a]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(r[a]=e[a])}return r}var d=n.createContext({}),m=function(e){var t=n.useContext(d),a=t;return e&&(a="function"==typeof e?e(t):i(i({},t),e)),a},p=function(e){var t=m(e.components);return n.createElement(d.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},c=n.forwardRef((function(e,t){var a=e.components,r=e.mdxType,o=e.originalType,d=e.parentName,p=l(e,["components","mdxType","originalType","parentName"]),c=m(a),u=r,h=c["".concat(d,".").concat(u)]||c[u]||s[u]||o;return a?n.createElement(h,i(i({ref:t},p),{},{components:a})):n.createElement(h,i({ref:t},p))}));function u(e,t){var a=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=a.length,i=new Array(o);i[0]=c;var l={};for(var d in t)hasOwnProperty.call(t,d)&&(l[d]=t[d]);l.originalType=e,l.mdxType="string"==typeof e?e:r,i[1]=l;for(var m=2;m<o;m++)i[m]=a[m];return n.createElement.apply(null,i)}return n.createElement.apply(null,a)}c.displayName="MDXCreateElement"},714:function(e,t,a){a.r(t),a.d(t,{assets:function(){return v},contentTitle:function(){return u},default:function(){return g},frontMatter:function(){return c},metadata:function(){return h},toc:function(){return f}});var n=a(5318),r=Object.defineProperty,o=Object.defineProperties,i=Object.getOwnPropertyDescriptors,l=Object.getOwnPropertySymbols,d=Object.prototype.hasOwnProperty,m=Object.prototype.propertyIsEnumerable,p=(e,t,a)=>t in e?r(e,t,{enumerable:!0,configurable:!0,writable:!0,value:a}):e[t]=a,s=(e,t)=>{for(var a in t||(t={}))d.call(t,a)&&p(e,a,t[a]);if(l)for(var a of l(t))m.call(t,a)&&p(e,a,t[a]);return e};const c={id:"head-movement",title:"Head Movement"},u=void 0,h={unversionedId:"head-movement",id:"version-2.0/head-movement",title:"Head Movement",description:"Movement",source:"@site/versioned_docs/version-2.0/head-movement.md",sourceDirName:".",slug:"/head-movement",permalink:"/open_dbm/docs/2.0/head-movement",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/../docs/head-movement.md",tags:[],version:"2.0",lastUpdatedAt:1671547565,formattedLastUpdatedAt:"12/20/2022",frontMatter:{id:"head-movement",title:"Head Movement"},sidebar:"variable",previous:{title:"Rate of Speech",permalink:"/open_dbm/docs/2.0/rate-of-speech"},next:{title:"Eye Blink Behavior",permalink:"/open_dbm/docs/2.0/eye-blink-behavior"}},v={},f=[{value:"Movement",id:"movement",level:2},{value:"Head Movement",id:"head-movement",level:2},{value:"Raw Variables",id:"raw-variables",level:3},{value:"Derived Variables",id:"derived-variables",level:3}],k={toc:f};function g(e){var t,a=e,{components:r}=a,p=((e,t)=>{var a={};for(var n in e)d.call(e,n)&&t.indexOf(n)<0&&(a[n]=e[n]);if(null!=e&&l)for(var n of l(e))t.indexOf(n)<0&&m.call(e,n)&&(a[n]=e[n]);return a})(a,["components"]);return(0,n.kt)("wrapper",(t=s(s({},k),p),o(t,i({components:r,mdxType:"MDXLayout"}))),(0,n.kt)("h2",s({},{id:"movement"}),"Movement"),(0,n.kt)("p",null,"OpenDBM focuses on computer vision-based measurements of movement. This refers to movement that can be detected in videos of individuals, focusing primarily on their head and face. Future versions of OpenDBM will hopefully include additional measurements as well."),(0,n.kt)("h2",s({},{id:"head-movement"}),"Head Movement"),(0,n.kt)("p",null,"Head movement is measured in two ways. The first is a Euclidean measurement i.e. in the *   ",(0,n.kt)("em",{parentName:"p"}," plane. The position of the head in x, y, and z coordinates is calculated as a raw variable in each frame. These raw variables are then used to measure overall head movement in the "),"xyz* plane."),(0,n.kt)("p",null,"The second method to measure head movement is by measuring angular changes in radians. The position of the head\u2019s pitch, roll, and yaw is calculated as a raw variable in each frame. These variables are then used to measure overall change in head pitch, yaw, and roll as derived variables."),(0,n.kt)("p",null,"Only image frames where the OpenFace confidence score is greater than 20% are used for all downstream calculations (OpenFace confidence scores were explained in Section 5.1)"),(0,n.kt)("h3",s({},{id:"raw-variables"}),"Raw Variables"),(0,n.kt)("table",null,(0,n.kt)("thead",{parentName:"table"},(0,n.kt)("tr",{parentName:"thead"},(0,n.kt)("th",s({parentName:"tr"},{align:null}),"Variable"),(0,n.kt)("th",s({parentName:"tr"},{align:null}),"Description"))),(0,n.kt)("tbody",{parentName:"table"},(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_headvel")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Euclidean head movement.")," Frame-wise Euclidean displacement of the head in the xyz plane.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposepitch")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head pitch angle.")," Frame-wise pitch angle of the head.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeyaw")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head yaw angle.")," Frame-wise yaw angle of the head.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeroll")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head roll angle."),"  Frame-wise roll angle of the head.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposedist")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Angular head movement."),"  Frame-wise change in head angle, combining pitch, yaw, and roll movements.")))),(0,n.kt)("h3",s({},{id:"derived-variables"}),"Derived Variables"),(0,n.kt)("table",null,(0,n.kt)("thead",{parentName:"table"},(0,n.kt)("tr",{parentName:"thead"},(0,n.kt)("th",s({parentName:"tr"},{align:null}),"Variable"),(0,n.kt)("th",s({parentName:"tr"},{align:null}),"Description"))),(0,n.kt)("tbody",{parentName:"table"},(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_headvel_mean")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Euclidean head movement mean."),"  Mean of ",(0,n.kt)("inlineCode",{parentName:"td"},"mov_headvel")," across the video in mm/frame.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_headvel_std")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Euclidean head movement standard deviation."),"  Standard deviation of ",(0,n.kt)("inlineCode",{parentName:"td"},"mov_headvel")," across the video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposepitch_mean")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head pitch movement mean."),"  Mean of the pitch angle of the head across the video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposepitch_std")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head pitch movement standard deviation.")," Standard deviation of the pitch angle of the head across the video i.e. amount of head movement in the pitch direction.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeyaw_mean")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head yaw movement mean."),"  Mean of the yaw angle of the head across the video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeyaw_std")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head yaw movement standard deviation."),"  Standard deviation of the yaw angle of the head across the video i.e. amount of head movement in the yaw direction.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeroll_mean")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head roll movement mean.")," Mean of the roll angle of the head across the video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposeroll_std")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Head roll movement standard deviation."),"  Standard deviation of the roll angle of the head across the video i.e. amount of head movement in the roll direction.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposedist_mean")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Angular head movement mean."),"  Mean of ",(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposedist")," across the video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"mov_hposedist_std")),(0,n.kt)("td",s({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Angular head movement standard deviation.")," Standard deviation of mov_hposedist across the video.")))))}g.isMDXComponent=!0}}]);