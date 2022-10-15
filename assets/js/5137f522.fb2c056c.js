"use strict";(self.webpackChunkopendbm_website=self.webpackChunkopendbm_website||[]).push([[8489],{5318:function(e,t,n){n.d(t,{Zo:function(){return c},kt:function(){return m}});var o=n(7378);function i(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,o)}return n}function r(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,o,i=function(e,t){if(null==e)return{};var n,o,i={},a=Object.keys(e);for(o=0;o<a.length;o++)n=a[o],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(o=0;o<a.length;o++)n=a[o],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var l=o.createContext({}),d=function(e){var t=o.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):r(r({},t),e)),n},c=function(e){var t=d(e.components);return o.createElement(l.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},p=o.forwardRef((function(e,t){var n=e.components,i=e.mdxType,a=e.originalType,l=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),p=d(n),m=i,h=p["".concat(l,".").concat(m)]||p[m]||u[m]||a;return n?o.createElement(h,r(r({ref:t},c),{},{components:n})):o.createElement(h,r({ref:t},c))}));function m(e,t){var n=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=n.length,r=new Array(a);r[0]=p;var s={};for(var l in t)hasOwnProperty.call(t,l)&&(s[l]=t[l]);s.originalType=e,s.mdxType="string"==typeof e?e:i,r[1]=s;for(var d=2;d<a;d++)r[d]=n[d];return o.createElement.apply(null,r)}return o.createElement.apply(null,n)}p.displayName="MDXCreateElement"},5179:function(e,t,n){n.r(t),n.d(t,{assets:function(){return b},contentTitle:function(){return m},default:function(){return y},frontMatter:function(){return p},metadata:function(){return h},toc:function(){return f}});var o=n(5318),i=Object.defineProperty,a=Object.defineProperties,r=Object.getOwnPropertyDescriptors,s=Object.getOwnPropertySymbols,l=Object.prototype.hasOwnProperty,d=Object.prototype.propertyIsEnumerable,c=(e,t,n)=>t in e?i(e,t,{enumerable:!0,configurable:!0,writable:!0,value:n}):e[t]=n,u=(e,t)=>{for(var n in t||(t={}))l.call(t,n)&&c(e,n,t[n]);if(s)for(var n of s(t))d.call(t,n)&&c(e,n,t[n]);return e};const p={id:"odbm-doc",title:"OpenDBM Documentation"},m=void 0,h={unversionedId:"odbm-doc",id:"odbm-doc",title:"OpenDBM Documentation",description:"Summary",source:"@site/extras/odbm-doc.md",sourceDirName:".",slug:"/odbm-doc",permalink:"/open_dbm/extras/odbm-doc",draft:!1,editUrl:"https://github.com/AiCure/open_dbm/blob/master/docs/docs/extras/odbm-doc.md",tags:[],version:"current",lastUpdatedAt:1665864734,formattedLastUpdatedAt:"10/16/2022",frontMatter:{id:"odbm-doc",title:"OpenDBM Documentation"},sidebar:"extras",previous:{title:"OpenDBM REST API",permalink:"/open_dbm/extras/odbm-rest-api"},next:{title:"OpenDBM Python API",permalink:"/open_dbm/extras/opendbm-python-api"}},b={},f=[{value:"Summary",id:"summary",level:2},{value:"Github documentation",id:"github-documentation",level:2},{value:"Basic usage and other informations",id:"basic-usage-and-other-informations",level:3},{value:"TOC Table of content",id:"toc-table-of-content",level:3},{value:"Web Documentation",id:"web-documentation",level:2},{value:"Documentation sections",id:"documentation-sections",level:2},{value:"Dashboard",id:"dashboard",level:3},{value:"Getting Started",id:"getting-started",level:3},{value:"Variables",id:"variables",level:3},{value:"API",id:"api",level:3},{value:"Resources",id:"resources",level:3},{value:"Blog",id:"blog",level:3},{value:"OpenDBM Web Technical Documentation",id:"opendbm-web-technical-documentation",level:2},{value:"How to install and run locally",id:"how-to-install-and-run-locally",level:3},{value:"Dashboard",id:"dashboard-1",level:3},{value:"Main config file",id:"main-config-file",level:3},{value:"Versioned pages",id:"versioned-pages",level:3},{value:"Non Versioned pages",id:"non-versioned-pages",level:3},{value:"Navigation (Sidebar and page ID)",id:"navigation-sidebar-and-page-id",level:3}],g={toc:f};function y(e){var t,n=e,{components:i}=n,c=((e,t)=>{var n={};for(var o in e)l.call(e,o)&&t.indexOf(o)<0&&(n[o]=e[o]);if(null!=e&&s)for(var o of s(e))t.indexOf(o)<0&&d.call(e,o)&&(n[o]=e[o]);return n})(n,["components"]);return(0,o.kt)("wrapper",(t=u(u({},g),c),a(t,r({components:i,mdxType:"MDXLayout"}))),(0,o.kt)("h2",u({},{id:"summary"}),"Summary"),(0,o.kt)("p",null,"As book is the gate to knowledge, OpenDBM documentation is the gate to all the great features provided in this library! The OpenDBM team primary focus is how to make this library easily accessible, installable and usable in a very simple and straightforward as much as possible, and good documentation is the key to our objectives. "),(0,o.kt)("h2",u({},{id:"github-documentation"}),"Github documentation"),(0,o.kt)("figure",null,(0,o.kt)("img",{src:"../docs/assets/odbm_github_doc.png",width:"500",alt:"OpenDBM Github documentation"}),(0,o.kt)("figcaption",null,"OpenDBM Github documentation")),"We want our github documentation as concise as possible. In here you can find the important information such as: * The latest OpenDBM version in PyPI * Unit test results which are coming from OpenDBM Code Checking Github Actions pipeline * The code coverage that also produced by above process",(0,o.kt)("p",null,"Along with those informations, you can also see the OS build and test status on our documentation which produced from OpenDBM Build Checking Github Actions pipeline. This way you can check whether the last version of OpenDBM library can support which platforms"),(0,o.kt)("h3",u({},{id:"basic-usage-and-other-informations"}),"Basic usage and other informations"),(0,o.kt)("p",null,"We also provide a section how to install and use OpenDBM library inside our github page. But of course more detailed explanation are provided in OpenDBM Web documentation which you're probably looking right now"),(0,o.kt)("h3",u({},{id:"toc-table-of-content"}),"TOC Table of content"),(0,o.kt)("p",null,"We are using ",(0,o.kt)("a",u({parentName:"p"},{href:"https://github.com/thlorenz/doctoc"}),"DocToc")," in order to generate our table of contents. So dont change the table of content at all. If you want to add anything, just add it like a normal way, and you can use ",(0,o.kt)("inlineCode",{parentName:"p"},"## My Section"),"  if you feel need to add new section for your information. After that, just generate ",(0,o.kt)("inlineCode",{parentName:"p"},"doctoc .")," in the root folder and DocToc will generate the ToC immediately and include your new information seamlessly."),(0,o.kt)("figure",null,(0,o.kt)("img",{src:"../docs/assets/odbm_doctoc.png",width:"500",alt:"OpenDBM Github Table of Content Generator"}),(0,o.kt)("figcaption",null,"OpenDBM Github Table of Content Generator")),(0,o.kt)("h2",u({},{id:"web-documentation"}),"Web Documentation"),(0,o.kt)("p",null,"By good probability when you read this section, you're currently looking at our web documentation. (Unless you read this from our github blob files which is still normal, no worries!)"),(0,o.kt)("blockquote",null,(0,o.kt)("p",{parentName:"blockquote"},"We are using ",(0,o.kt)("a",u({parentName:"p"},{href:"https://docusaurus.io/"}),"Docusaurus")," to generate this documentation as our primary objective is focus on the content and how to deliver the most straightfoward information to the community. So all the neccessary code to build this web documentation are coming from Docusaurus.")),(0,o.kt)("h2",u({},{id:"documentation-sections"}),"Documentation sections"),(0,o.kt)("h3",u({},{id:"dashboard"}),"Dashboard"),(0,o.kt)("p",null,"When you first arrived to the OpenDBM Web documentation, you will see the concise description about what is OpenDBM and Why to use it. We also provide talks and videos that provide informations about this library. We also put the acknowledgements to those libraries that make everything is possible in this OpenDBM library"),(0,o.kt)("h3",u({},{id:"getting-started"}),"Getting Started"),(0,o.kt)("p",null,"This section provide informations on everything you need to know to install and use the OpenDBM. It explains about the prerequisites before you install the OpenDBM. It makes sure to leave no one behind as we provide the informations to all OS platforms. "),(0,o.kt)("figure",null,(0,o.kt)("img",{src:"../docs/assets/odbm_allOs.png",width:"500",alt:"OpenDBM Documentation to all platforms"}),(0,o.kt)("figcaption",null,"OpenDBM Documentation to all platforms")),(0,o.kt)("h3",u({},{id:"variables"}),"Variables"),(0,o.kt)("p",null,"This section provide deeper informations about OpenDBM. There are a lot of variables you can fetch from OpenDBM, and this section provide you how to use those variables and what is the limitation on each modules. We also make sure to make annotation or reference to acknowledge other people contributions to make all this possible"),(0,o.kt)("h3",u({},{id:"api"}),"API"),(0,o.kt)("p",null,"One of all thing about the OpenDBM generation 2 is how easy it is to use OpenDBM. We put another layer on top of the previous OpenDBM library to make it easier to use OpenDBM. All those APIs informations are provided within this section. This section is automatically generated by ",(0,o.kt)("a",u({parentName:"p"},{href:"https://docs.python.org/3/library/pydoc.html"}),"pydoc")," command line that executed in ",(0,o.kt)("inlineCode",{parentName:"p"},".github/workflows/open_dbm-docs-deploy.yml")),(0,o.kt)("figure",null,(0,o.kt)("img",{src:"../docs/assets/pydoc-pic.png",width:"100%",alt:"OpenDBM Pydoc Generated  Document"}),(0,o.kt)("figcaption",null,"OpenDBM Pydoc Generated  Document")),(0,o.kt)("h3",u({},{id:"resources"}),"Resources"),(0,o.kt)("p",null,"This section provide all informations surrounding the OpenDBM environment. It gives you information about the pipeline, REST API, Documentation (Hi, there!) and contributing guideines."),(0,o.kt)("h3",u({},{id:"blog"}),"Blog"),(0,o.kt)("p",null,"Within this section, you can read other people perspectives, stories and bunch of interesting stuff about OpenDBM all around the world!"),(0,o.kt)("h2",u({},{id:"opendbm-web-technical-documentation"}),"OpenDBM Web Technical Documentation"),(0,o.kt)("p",null,"Below section will discuss in more detail about the technical aspect of OpenDBM Web documentation structure. "),(0,o.kt)("h3",u({},{id:"how-to-install-and-run-locally"}),"How to install and run locally"),(0,o.kt)("p",null,"Your node must be set to stable version (as of now version 16) to be able to install and run this documentation\nUnder the docs directory:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},(0,o.kt)("inlineCode",{parentName:"p"},"bash yarn")," to install all the dependencies")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"Then go to the the ",(0,o.kt)("inlineCode",{parentName:"p"},"website")," directory and run the app by typing:"),(0,o.kt)("ul",{parentName:"li"},(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"Command below is for start the website for the ",(0,o.kt)("strong",{parentName:"p"},"first time"),". Run below commands under docs/ folder"),(0,o.kt)("pre",{parentName:"li"},(0,o.kt)("code",u({parentName:"pre"},{className:"language-bash"}),"pip install pydoc-markdown\npydoc-markdown -I ../opendbm/api_lib/facial_activity -m api --render-toc > website/api/facial-activity-api.md\npydoc-markdown -I ../opendbm/api_lib/movement -m api --render-toc > website/api/movement-api.md\npydoc-markdown -I ../opendbm/api_lib/verbal_acoustics -m api --render-toc > website/api/verbal-acoustics-api.md\npydoc-markdown -I ../opendbm/api_lib/speech -m api --render-toc > website/api/speech-api.md\ncd website && yarn start\n"))),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"This command is the one you execute if you have already generated dynamic documentation from pydoc-markdown"),(0,o.kt)("pre",{parentName:"li"},(0,o.kt)("code",u({parentName:"pre"},{className:"language-bash"}),"cd website && yarn start\n")))))),(0,o.kt)("h3",u({},{id:"dashboard-1"}),"Dashboard"),(0,o.kt)("p",null,"The dashboard page is build on top of React framework. You need only a basic React knowledge in order to change stuff in the dashboard. "),(0,o.kt)("h3",u({},{id:"main-config-file"}),"Main config file"),(0,o.kt)("p",null,"The main config file of OpenDBM documentation is docusaurus.config.js. You can change things like:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"You can set the footer content")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"You can set the ",(0,o.kt)("inlineCode",{parentName:"p"},"editUrl"),". This parameter to define the url when you or other community members want to change this file"),(0,o.kt)("figure",null,(0,o.kt)("img",{src:"../docs/assets/odbm_edit_button.png",width:"300",alt:"OpenDBM Edit this page button"}),(0,o.kt)("figcaption",null,"OpenDBM Edit this page button"))),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"You can set the url, baseUrl")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"in ",(0,o.kt)("inlineCode",{parentName:"p"},"presets[0][0]")," you can set the sidebar file to show in the ",(0,o.kt)("inlineCode",{parentName:"p"},"getting-started")," section. We can also set the limit number of versions that will be displayed in the documentation in this line ",(0,o.kt)("inlineCode",{parentName:"p"},"['current', ...versions.slice(0, 2)]")," We will discuss about versioning deeper below"),(0,o.kt)("blockquote",{parentName:"li"},(0,o.kt)("p",{parentName:"blockquote"},"Support too many versions will make the web deployment much slower. "))),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"Still in the same above parameter, we can also sync the google analytic tag in ",(0,o.kt)("inlineCode",{parentName:"p"},"googleAnalytics.trackingID")," parameter.")),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("p",{parentName:"li"},"in ",(0,o.kt)("inlineCode",{parentName:"p"},"plugins")," we also can set the siderbar file to be shown in other section as well "))),(0,o.kt)("h3",u({},{id:"versioned-pages"}),"Versioned pages"),(0,o.kt)("p",null,"This documentation support versioning on the library as it very important that we could provide information and retain it so community can refer to specific version for their usecase. The versions are listed under ",(0,o.kt)("inlineCode",{parentName:"p"},"docs/website/versions.json"),". The latest version must be the first element in that array. "),(0,o.kt)("p",null,"That versions will be referred and used in these two directories ",(0,o.kt)("inlineCode",{parentName:"p"},"versioned_docs")," and ",(0,o.kt)("inlineCode",{parentName:"p"},"versioned_sidebars"),". So you can edit the documentation in specific version within these directories. "),(0,o.kt)("p",null,"Those files and sidebars file also has duplicated contents in ",(0,o.kt)("inlineCode",{parentName:"p"},"sidebars.json")," and files under directories ",(0,o.kt)("inlineCode",{parentName:"p"},"docs/docs"),". These files are meant for future version. So if the community using ",(0,o.kt)("strong",{parentName:"p"},"Edit This Page")," button in the pages, it will create the MR for changes related to this directory. So you can say its a temporary directory for future changes on the documentations. Later, when you create future ",(0,o.kt)("inlineCode",{parentName:"p"},"version-x.x")," version, you can just copy paste all the files under ",(0,o.kt)("inlineCode",{parentName:"p"},"docs/docs")," to the new version directory."),(0,o.kt)("h3",u({},{id:"non-versioned-pages"}),"Non Versioned pages"),(0,o.kt)("p",null,"Right now, the non versioned pages are API, Resources, Blog. It has its own directories under docs/website. If you need new section, you can create the directory and define it in ",(0,o.kt)("inlineCode",{parentName:"p"},"docusaurus.config.js"),"."),(0,o.kt)("h3",u({},{id:"navigation-sidebar-and-page-id"}),"Navigation (Sidebar and page ID)"),(0,o.kt)("p",null,"In the ",(0,o.kt)("inlineCode",{parentName:"p"},"version-xx-sidebars.json"),", you can define the sidebar and the IDs of pages that you want to categorize. You can set the id inside the page i.e."),(0,o.kt)("pre",null,(0,o.kt)("code",u({parentName:"pre"},{}),"id: action-units\ntitle: Actions Units\n")))}y.isMDXComponent=!0}}]);