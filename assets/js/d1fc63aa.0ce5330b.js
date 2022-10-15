"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[9700],{5318:function(e,t,a){a.d(t,{Zo:function(){return s},kt:function(){return f}});var n=a(7378);function r(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function i(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function l(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?i(Object(a),!0).forEach((function(t){r(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):i(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function o(e,t){if(null==e)return{};var a,n,r=function(e,t){if(null==e)return{};var a,n,r={},i=Object.keys(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||(r[a]=e[a]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(r[a]=e[a])}return r}var c=n.createContext({}),d=function(e){var t=n.useContext(c),a=t;return e&&(a="function"==typeof e?e(t):l(l({},t),e)),a},s=function(e){var t=d(e.components);return n.createElement(c.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var a=e.components,r=e.mdxType,i=e.originalType,c=e.parentName,s=o(e,["components","mdxType","originalType","parentName"]),m=d(a),f=r,u=m["".concat(c,".").concat(f)]||m[f]||p[f]||i;return a?n.createElement(u,l(l({ref:t},s),{},{components:a})):n.createElement(u,l({ref:t},s))}));function f(e,t){var a=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=a.length,l=new Array(i);l[0]=m;var o={};for(var c in t)hasOwnProperty.call(t,c)&&(o[c]=t[c]);o.originalType=e,o.mdxType="string"==typeof e?e:r,l[1]=o;for(var d=2;d<i;d++)l[d]=a[d];return n.createElement.apply(null,l)}return n.createElement.apply(null,a)}m.displayName="MDXCreateElement"},9166:function(e,t,a){a.r(t),a.d(t,{assets:function(){return b},contentTitle:function(){return f},default:function(){return h},frontMatter:function(){return m},metadata:function(){return u},toc:function(){return k}});var n=a(5318),r=Object.defineProperty,i=Object.defineProperties,l=Object.getOwnPropertyDescriptors,o=Object.getOwnPropertySymbols,c=Object.prototype.hasOwnProperty,d=Object.prototype.propertyIsEnumerable,s=(e,t,a)=>t in e?r(e,t,{enumerable:!0,configurable:!0,writable:!0,value:a}):e[t]=a,p=(e,t)=>{for(var a in t||(t={}))c.call(t,a)&&s(e,a,t[a]);if(o)for(var a of o(t))d.call(t,a)&&s(e,a,t[a]);return e};const m={id:"facial-landmark",title:"Facial Landmark"},f=void 0,u={unversionedId:"facial-landmark",id:"facial-landmark",title:"Facial Landmark",description:"Facial landmarks refer to specific regions of the face, with x, y, and z coordinates for each facial landmark variable indicating where in the image frame that specific region of the face is located.",source:"@site/../docs/facial-landmark.md",sourceDirName:".",slug:"/facial-landmark",permalink:"/open_dbm/docs/next/facial-landmark",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/../docs/facial-landmark.md",tags:[],version:"current",lastUpdatedAt:1664829287,formattedLastUpdatedAt:"10/4/2022",frontMatter:{id:"facial-landmark",title:"Facial Landmark"},sidebar:"variable",previous:{title:"Facial Activity",permalink:"/open_dbm/docs/next/facial-activity"},next:{title:"Action units",permalink:"/open_dbm/docs/next/action-units"}},b={},k=[{value:"Raw Variables",id:"raw-variables",level:2},{value:"Derived Variables",id:"derived-variables",level:2}],v={toc:k};function h(e){var t,a=e,{components:r}=a,s=((e,t)=>{var a={};for(var n in e)c.call(e,n)&&t.indexOf(n)<0&&(a[n]=e[n]);if(null!=e&&o)for(var n of o(e))t.indexOf(n)<0&&d.call(e,n)&&(a[n]=e[n]);return a})(a,["components"]);return(0,n.kt)("wrapper",(t=p(p({},v),s),i(t,l({components:r,mdxType:"MDXLayout"}))),(0,n.kt)("p",null,"Facial landmarks refer to specific regions of the face, with x, y, and z coordinates for each facial landmark variable indicating where in the image frame that specific region of the face is located. "),(0,n.kt)("figure",null,(0,n.kt)("img",{src:"../docs/assets/facial-landmark-1.png",width:"500",alt:"Visual representation of the facial landmarks calculated by OpenDBM, which relies on OpenFace and OpenCV for its measurements."}),(0,n.kt)("figcaption",null,"Visual representation of the facial landmarks calculated by OpenDBM, which relies on OpenFace and OpenCV for its measurements.")),(0,n.kt)("p",null,"OpenDBM calculates overall change in facial landmark positioning and in doing so measures facial musculature movements at the level of individual facial landmarks. Individual movement of a total of 68 facial landmarks is measured using the raw and derived variables listed in the tables below."),(0,n.kt)("h2",p({},{id:"raw-variables"}),"Raw Variables"),(0,n.kt)("table",null,(0,n.kt)("thead",{parentName:"table"},(0,n.kt)("tr",{parentName:"thead"},(0,n.kt)("th",p({parentName:"tr"},{align:null}),"Variable"),(0,n.kt)("th",p({parentName:"tr"},{align:null}),"Description"))),(0,n.kt)("tbody",{parentName:"table"},(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"fac_lmkXXdisp")),(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Landmark displacement.")," Frame-wise change in landmark positioning i.e. the euclidean distance in the xyz plane, where XX can be any number between 01 and 68, referring to all individual facial landmarks.")))),(0,n.kt)("h2",p({},{id:"derived-variables"}),"Derived Variables"),(0,n.kt)("table",null,(0,n.kt)("thead",{parentName:"table"},(0,n.kt)("tr",{parentName:"thead"},(0,n.kt)("th",p({parentName:"tr"},{align:null}),"Variable"),(0,n.kt)("th",p({parentName:"tr"},{align:null}),"Description"))),(0,n.kt)("tbody",{parentName:"table"},(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"fac_lmkXXdisp_mean")),(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Landmark displacement mean.")," The mean value of fac_lmkXXdisp for the inputted video.")),(0,n.kt)("tr",{parentName:"tbody"},(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("inlineCode",{parentName:"td"},"fac_lmkXXdisp_std")),(0,n.kt)("td",p({parentName:"tr"},{align:null}),(0,n.kt)("strong",{parentName:"td"},"Landmark displacement standard deviation.")," The standard deviation value of fac_lmkXXdisp for the inputted video.")))))}h.isMDXComponent=!0}}]);