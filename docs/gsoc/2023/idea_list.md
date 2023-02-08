# Google Summer of Code - Idea List

**The purpose of this idea list is to help contributors answer the question:**
> What are ideas of projects I can work on in Google Summer of Code with OpenDBM

## Brief Overview

### OpenDBM Project Areas
[<img src="https://user-images.githubusercontent.com/34843515/217380475-c50cd215-dfeb-4c74-9f82-0aaa7fc5de4a.png" width=100px>](https://hub.docker.com/r/opendbmteam/dbm-openface)
[<img src="https://user-images.githubusercontent.com/34843515/217385063-56e3d0ba-2877-4d28-8648-2f036ec781c6.png" width=100px>](https://pypi.org/project/opendbm/)
[<img src="https://user-images.githubusercontent.com/34843515/217385086-20c5036d-e169-48fa-ac66-66f533a9d2c9.png" width=100px>](https://aicure.github.io/open_dbm/api/api-doc)
[<img src="https://user-images.githubusercontent.com/34843515/217385095-6056b632-215a-4a97-8202-7a8b429a9003.png" width=97px>](https://github.com/AiCure/open_dbm/tree/master/visualization_interface#opendbm-visual-analytics-interface)

Choosing a project is a personal choice.  You should choose something you want to work on, and you would know that best! Here's a few questions you can ask yourself to help figure that out: 

- What software do you already use? 
- What would you like to learn?
- Who do you like working with? 
- How do you want to chane the world?
- How do you like to communicate? 

The community can benefit from a wide range of contribution to each project area. Because OpenDBM includes a community of open scientists, jupyter notebooks, tutorials, and documentations are equally important to supporting the community

#### 1. [Docker Implementation](https://hub.docker.com/r/opendbmteam/dbm-openface) 

[<img src="https://user-images.githubusercontent.com/34843515/217380475-c50cd215-dfeb-4c74-9f82-0aaa7fc5de4a.png" width=70px>](https://hub.docker.com/r/opendbmteam/dbm-openface)

[What is docker?](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/container-docker-introduction/docker-defined)
> Docker is an open-source project for automating the deployment of applications as portable, self-sufficient containers that can run on the cloud or on-premises. Docker is also a company that promotes and evolves this technology.

OpenDBM is built ‘on top of’ a bunch of existing open source tools. That means it depends on a lot of other software to function and do the things it needs to do. And the user is responsible for scouring the internet for OpenDBM’s ‘dependencies,’ listed in the requirements.txt file that comes with it, and installing each and every one of them. OpenDBM's Docker Implementation packages up all the dependencies that you would otherwise have to install into a container. More information can be found here in our [Github Pages Guides](https://aicure.github.io/open_dbm/docs/beginner-installation)


#### 2. [Pypi library](https://pypi.org/project/opendbm/)

[<img src="https://user-images.githubusercontent.com/34843515/217385063-56e3d0ba-2877-4d28-8648-2f036ec781c6.png" width=75px>](https://pypi.org/project/opendbm/)

[<img src="https://user-images.githubusercontent.com/34843515/217387633-e1b5b3d7-103b-4e1d-bfe4-5237b3f0be14.png" width=500px>]

More information about the OpenDBM Python API can be found here in our [Github Pages Guides](https://aicure.github.io/open_dbm/extras/opendbm-python-api)


#### 3. [RESTful API](https://aicure.github.io/open_dbm/api/api-doc)

[<img src="https://user-images.githubusercontent.com/34843515/217385086-20c5036d-e169-48fa-ac66-66f533a9d2c9.png" width=75px>](https://aicure.github.io/open_dbm/api/api-doc)

<img width="1084" alt="odbm_api_summary" src="https://user-images.githubusercontent.com/34843515/217388200-cf77f6fa-df0e-41ac-aab0-905a3ae98701.png">

More information about the OpenDBM REST API can be found here in our [Github Pages Guides](https://aicure.github.io/open_dbm/extras/odbm-rest-api))



#### 4. [Viz Tool](https://github.com/AiCure/open_dbm/tree/master/visualization_interface#opendbm-visual-analytics-interface)  


[<img src="https://user-images.githubusercontent.com/34843515/217385095-6056b632-215a-4a97-8202-7a8b429a9003.png" width=72px>](https://github.com/AiCure/open_dbm/tree/master/visualization_interface#opendbm-visual-analytics-interface)


<img width="500" alt="191345731-b12004b2-c424-455e-83cc-2bb18aa96d47" src="https://user-images.githubusercontent.com/34843515/217389561-4f96ed01-a36c-4d57-8334-5990d282bfd2.png">

App.js is the container of the entire application (default container component provided by the npm create-react-app command that was used to create a bare-bones React application). Based on the selected panel, the Visuali will output one of the two existing panels: the Cohort Panel of the Individual Panel.

**Cohort Panel:**
This panel contains all the relevant components for visual cohort analysis. The user can make inquiries about derived cohort data outputted by the OpenDBM pipeline (derived_variables/derived_output.csv). This panel will output only the available data (i.e. OpenDBM outputs a subset of DBMs).

**Individual Panel**
This panel contains all the relevant components for individual video analysis. The user can make inquiries about the raw data for one video, as well as some of derived variables outputted by the OpenDBM pipeline (raw_varialbes/{video_id_folder}/.. and derived_variables/derived_output.csv). This view will output only the available raw and derived data (i.e. OpenDBM outputs a subset of DBMs).



More information about the OpenDBM Vis Tool can be found [here](https://github.com/AiCure/open_dbm/tree/master/visualization_interface) 



## Ideas List 

| Project Area | General Description | Required Skills | Difficulty | 
| :--- | --- | --- | ---: |
| Vis Tool | In the summer 2022 the OpenDBM Summer Intern built the Vis tool as a minimum viable product.  Several minor/medium enhancements and bug fixes were left from the project. Explore Vistool to see issues you may be interested in enhancing or fixing| react, python, node.js | Variable difficulty (easy-to-hard)|
| Multiple | Performance can be improved, including simpler installs for all project areas (except RESTful API).  This may include testing, benchmarking, and evaluating performance.  You would create a scoped optimziation plan such as reducing the docker size and eliminating dead code.  Additionaly the virtual env management can be flaky | may include python, docker, react, node.js | Variable difficulty (easy-to-hard) |
| Multiple | Develop a feature to process a selected time range of audio-video data as opposed to the video entirely.  Permit multiple time contents to select. E.g.  Minute 2:35 -5:01 and minute 6:30-7:52  | Docker-build, python | Medium | 
| Docker Implementation | Develop a voice splitting/splicing feature to split separate voices from an aduio file for input into OpenDBM Docker Implementation | Docker, other | Medium |
| Docker Implementation| Integrate an additional open source into the Docker build.  If time allows this may also include updating PyPi library to include separate toolkit.  An example of other toolkits to integrate includes [OpenPose](https://cmu-perceptual-computing-lab.github.io/openpose/web/html/doc/index.html) | Medium-to-Hard
| Docker Implementation | Add a preprocessing set of tools Docker build so that end users can sanity check their audio and video recordings. | up to contributor | variable (easy-to-hard)
| Pypi Library (jupyter notebook, document, and blog tutorials) | Create artifacts to educate users on ways to preprocess, process, and post-process  data | data science, python, statistical analysis | Medium-to-Hard |
 




## Mentors
Mentors will consist of AiCure Engineering and Clinical Data Science Team. Community Members can apply to be mentors, see below for more information.

Mentor and admins will include but are not limited too
- [Aaron Masino, PhD](https://www.linkedin.com/in/aaron-masino-38989415/)
- [Andre Daniel Paredes, PhD](https://www.linkedin.com/in/andre-daniel-paredes/)
- [Jacob Epifano, PhD](https://www.linkedin.com/in/jrepifano/)
- [Rich Christie, MD,PhD](https://www.linkedin.com/in/richchristie/)
- [Sarah Kark, PhD](https://www.linkedin.com/in/sarahkark/)
- [Stephanie Caamano](https://www.linkedin.com/in/scaamano/)
-


Mentors and org admins can be reached in the public opendbm@aicure.com listserve. This includes any questions in both the application process or general questions about the project. If conversations advance we'll pull you into a private email This lets. *If selected we will add you to our private channel on the OpenDBM Community Home on the Discourse Platform*

Interested in volunteering with OpenDBM as a mentor? 
We'd love to . Please consider the following: 

- The easiest way to become a member is to be part of our discourse community and fill out our [OpenDBM Community Survey](https://docs.google.com/forms/d/e/1FAIpQLScKUCdYdK9UTd569IuF3O8Q2A9fXuMJ5z9wXbX4r5yzcwfphQ/viewform?fbzx=-1747756377554914236&pli=1) and let us know you are interested in mentoring
- Mentors you are expected to read and closely abide by [GSoC Mentor Guide](https://google.github.io/gsocguides/mentor/upstream-integration)* 
- We expect around a 0-10 hr/week commitment
- We ideally would like more than two mentors per project, so cooperation is key.
- The most successfuly mentors are those who have subject matter expertise experience or are community members of the open source project. 
- Mentors do have to do multiple evaluations on each GSoC Contributor, two mid-terms and one at the end. 
- This is 100% volunteer role for people who are passionate about helping and giving back. 




