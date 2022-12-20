"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[5988],{5318:function(e,t,n){n.d(t,{Zo:function(){return c},kt:function(){return h}});var r=n(7378);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var s=r.createContext({}),u=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},c=function(e){var t=u(e.components);return r.createElement(s.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,s=e.parentName,c=i(e,["components","mdxType","originalType","parentName"]),d=u(n),h=a,f=d["".concat(s,".").concat(h)]||d[h]||p[h]||o;return n?r.createElement(f,l(l({ref:t},c),{},{components:n})):r.createElement(f,l({ref:t},c))}));function h(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,l=new Array(o);l[0]=d;var i={};for(var s in t)hasOwnProperty.call(t,s)&&(i[s]=t[s]);i.originalType=e,i.mdxType="string"==typeof e?e:a,l[1]=i;for(var u=2;u<o;u++)l[u]=n[u];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},4681:function(e,t,n){n.r(t),n.d(t,{assets:function(){return g},contentTitle:function(){return h},default:function(){return b},frontMatter:function(){return d},metadata:function(){return f},toc:function(){return m}});var r=n(5318),a=Object.defineProperty,o=Object.defineProperties,l=Object.getOwnPropertyDescriptors,i=Object.getOwnPropertySymbols,s=Object.prototype.hasOwnProperty,u=Object.prototype.propertyIsEnumerable,c=(e,t,n)=>t in e?a(e,t,{enumerable:!0,configurable:!0,writable:!0,value:n}):e[t]=n,p=(e,t)=>{for(var n in t||(t={}))s.call(t,n)&&c(e,n,t[n]);if(i)for(var n of i(t))u.call(t,n)&&c(e,n,t[n]);return e};const d={title:"Changelogs in Pull Requests"},h=void 0,f={unversionedId:"changelogs-in-pull-requests",id:"changelogs-in-pull-requests",title:"Changelogs in Pull Requests",description:'The changelog entry in your pull request serves as a sort of "tl;dr do they affect Android? are these breaking changes? is something new being added?',source:"@site/contributing/changelogs-in-pull-requests.md",sourceDirName:".",slug:"/changelogs-in-pull-requests",permalink:"/open_dbm/contributing/changelogs-in-pull-requests",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/contributing/changelogs-in-pull-requests.md",tags:[],version:"current",lastUpdatedAt:1671547565,formattedLastUpdatedAt:"12/20/2022",frontMatter:{title:"Changelogs in Pull Requests"}},g={},m=[{value:"Format",id:"format",level:3},{value:"Examples",id:"examples",level:3},{value:"FAQ",id:"faq",level:3},{value:"What if my pull request contains changes to both Android and JavaScript?",id:"what-if-my-pull-request-contains-changes-to-both-android-and-javascript",level:4},{value:"What if my pull request contains changes to both Android and iOS?",id:"what-if-my-pull-request-contains-changes-to-both-android-and-ios",level:4},{value:"What if my pull request contains changes to Android, iOS, and JavaScript?",id:"what-if-my-pull-request-contains-changes-to-android-ios-and-javascript",level:4},{value:"What if...?",id:"what-if",level:4}],y={toc:m};function b(e){var t,n=e,{components:a}=n,c=((e,t)=>{var n={};for(var r in e)s.call(e,r)&&t.indexOf(r)<0&&(n[r]=e[r]);if(null!=e&&i)for(var r of i(e))t.indexOf(r)<0&&u.call(e,r)&&(n[r]=e[r]);return n})(n,["components"]);return(0,r.kt)("wrapper",(t=p(p({},y),c),o(t,l({components:a,mdxType:"MDXLayout"}))),(0,r.kt)("p",null,'The changelog entry in your pull request serves as a sort of "tl;dr:" for your changes: do they affect Android? are these breaking changes? is something new being added?'),(0,r.kt)("p",null,"Providing a changelog using a standardized format helps release coordinators write release notes. Please include a changelog as part of your pull request description. Your pull request description will be used as the commit message should the pull request get merged."),(0,r.kt)("h3",p({},{id:"format"}),"Format"),(0,r.kt)("p",null,"A changelog entry has the following format"),(0,r.kt)("pre",null,(0,r.kt)("code",p({parentName:"pre"},{}),"## Changelog:\n\n[Category] [Type] - Message\n")),(0,r.kt)("p",null,'The "Category" field may be one of:'),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Android"),", for changes that affect Android."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"iOS"),", for changes that affect iOS."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"General"),", for changes that do not fit any of the other categories."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Internal"),", for changes that would not be relevant to developers consuming the release notes.")),(0,r.kt)("p",null,'The "Type" field may be one of:'),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Added"),", for new features."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Changed"),", for changes in existing functionality."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Deprecated"),", for soon-to-be removed features."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Removed"),", for now removed features."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Fixed"),", for any bug fixes."),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("strong",{parentName:"li"},"Security"),", in case of vulnerabilities.")),(0,r.kt)("p",null,'Finally, the "Message" field may answer "what and why" on a feature level. Use this to briefly tell OpenDBM users about notable changes.'),(0,r.kt)("p",null,"For more detail, see ",(0,r.kt)("a",p({parentName:"p"},{href:"https://keepachangelog.com/en/1.0.0/#how"}),"How do I make a good changelog?")," and ",(0,r.kt)("a",p({parentName:"p"},{href:"https://keepachangelog.com/en/1.0.0/#why"}),"Why keep a changelog?")),(0,r.kt)("h3",p({},{id:"examples"}),"Examples"),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("inlineCode",{parentName:"li"},"[General] [Added] - Add snapToOffsets prop to ScrollView component")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("inlineCode",{parentName:"li"},"[General] [Fixed] - Fix various issues in snapToInterval on ScrollView component")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("inlineCode",{parentName:"li"},"[iOS] [Fixed] - Fix crash in RCTImagePicker"))),(0,r.kt)("h3",p({},{id:"faq"}),"FAQ"),(0,r.kt)("h4",p({},{id:"what-if-my-pull-request-contains-changes-to-both-android-and-javascript"}),"What if my pull request contains changes to both Android and JavaScript?"),(0,r.kt)("p",null,"Use the Android category."),(0,r.kt)("h4",p({},{id:"what-if-my-pull-request-contains-changes-to-both-android-and-ios"}),"What if my pull request contains changes to both Android and iOS?"),(0,r.kt)("p",null,"Use the General category if the change is made in a single pull request."),(0,r.kt)("h4",p({},{id:"what-if-my-pull-request-contains-changes-to-android-ios-and-javascript"}),"What if my pull request contains changes to Android, iOS, and JavaScript?"),(0,r.kt)("p",null,"Use the General category if the change is made in a single pull request."),(0,r.kt)("h4",p({},{id:"what-if"}),"What if...?"),(0,r.kt)("p",null,'Any changelog entry is better than none. If you are unsure if you have picked the right category, use the "message" field to succinctly describe your change. '),(0,r.kt)("p",null,"These entries are used by the ",(0,r.kt)("a",p({parentName:"p"},{href:"https://github.com/microsoft/rnx-kit/tree/main/incubator/rn-changelog-generator"}),(0,r.kt)("inlineCode",{parentName:"a"},"@rnx-kit/rn-changelog-generator"))," script to build a rough draft, which is then edited by a release coordinator. "),(0,r.kt)("p",null,"Your notes will be used to add your change to the correct location in the final release notes."))}b.isMDXComponent=!0}}]);