# Google Summer of Code - Contribution Guide 

The Purpose of this document to help contributors answer the question: 
> What do I need to know to participate in Google Summer of Code (GSoC) with OpenDBM?

***Note for mentors:*** *Mentors you are expected to read and closely abide by [GSoC Mentor Guide](https://google.github.io/gsocguides/mentor/upstream-integration)* 

# Table of Contents


- [⭐️ What is it?](what-is-it?)
- [⭐️ Getting Started](getting-started)
- [⭐️ Application Process](application-process)
- [⭐️ Time commitment](time-commitment)
- [⭐️ Tips](tips)
- [⭐️ Google Resources](google-resources)


## ⭐️ What is it? 

| OpenDBM | GSoC |
| :------ | ---: |
|OpenDBM is a software package that allows researchers to calculate digital traits (or digital phenotyping)  from video/audio of a person's behavior by combining tools to measure behavioral characteristics like facial activity, voice, and movement into a single package to measure overall behavior. From those behavioral characteristics, researchers can measure clinically meaningful symptomatology such as emotional expressivity, the prosody of voice, the valence of speech, and severity of tremor––among many others. | Google Summer of Code (GSoC) is a global program that offers new contributors over 18 an opportunity to be paid for contributing to an open source project over a three month period. | 

OpenDBM was started in 2020 as a free and open resource to support the wider scientific community. We are now starting new initiatives to ensure that OpenDBM feels like a community of developers, in addition to researchers and citizen scientists. Don't be afraid to enter this space, ask questions, and learn something. Everyone can be a contributor and help drive this public good!

> We are applying to be apart of GSoC 2023! 
> Contributors please start with this document for Getting Started

## ⭐️ Getting Started 

Any open source experince will help you prepare for GSoC, so don't worry about what project you try. Look over the [project ideas]().

- Start by letting us know you are interested in [OpenDBM's Open Source Community Survey](https://docs.google.com/forms/d/e/1FAIpQLScKUCdYdK9UTd569IuF3O8Q2A9fXuMJ5z9wXbX4r5yzcwfphQ/viewform?fbzx=-1747756377554914236&pli=1)
- Set up your own development environment 
- Start with communicating with the developers.  Join the maing list (and upcoming discourse community home)
- Find bugs and report them 
- Help with documentation
- Help others

### General Recommendations before getting started

**Here's a few things you should consider to be effective and productive** 
- You should have some kind of experience with Python
- You should celebrate this as opportunity to learn something new under guidance of mentorship. Don't be afraid of the unknown!
- You should feel comfortable asking questions

**Here are items to consider before applying** 
1. Be comfortable communicating your work in public. All GSoC Contributos are required to post weekly and minimally communite the following:
>   - What did you do this week?
>   - What is coming up next? 
>   - Did you get stuck anywhere?
2. You should get a basic understanding of version control with git. 
3. You should get a basic understanding of highly used toolkits in the field of digital phenotyping. 
> OpenDBM is a compilation of existing but disparate open-source software tools that we’ve built on top of. All these tools are of course listed in the OpenDBM dependencies but we recommend you check out their github repos. They include the following
> - OpenFace, built on OpenCV, is at the heart of all facial measures and even some of the movement ones.
> - Parselmouth and its reliance on the Praat software library lies behind most of the vocal acoustic measures. 
> - DeepSpeech was used for all speech transcription and NLTK is utilized for a lot of language metrics. OpenDBM would not be possible without these––and several other––open source software packages.



## ⭐️ Application Process 

To apply, can look over the [OpenDBM Repo](https://github.com/AiCure/open_dbm) and propose a new idea  or pull from the [OpenDBM <> GSOC Ideas 2023]() to create a project proposal that's good for both you and the OpenDBM open source community. If you propose something new make especially sure that you work with our mentor(s) to make sure it's a good fit for the community. Unsolicited, undiscussed ideas are less likely to get accepted.

There are three primary project areas to consider for OpenDBM:
1. Docker
2. Pypi library
3. RESTful Api 

Once you've narrowed it down to a project idea or two, use the application checklist to prepare your project proposal. (You can submit up to three proposals, but will only be offered one position if accepted.)
All applications are must be sent through the Google system.

### Short application Checklist

1. Read the links and instructions given on this site 
2. Talk with your prospective mentor(s) about what they expect of GSoC applicants and get help from them to refine your project ideas.
3. Make an attempt at a patch. Usually we expect GSoC contributors to fix a bug and have made a pull request (or equivalent). Your code doesn't have to be accepted and merged, but it does have to be visible to the public and it does have to be your own work (mentor help is ok).
4. Write your application and ask for help mentor(s). We have an [application template]() to help you make sure you include all the information we expect. All applications must go through Google's application system; we can't accept any application unless it is submitted there.
    - Use a descriptive title and include your project area. Good example: "OpenDBM Docker: add feature to select recording timeframe for processing " Bad example: "My gsoc project"
    - Make it easy for your mentors to give you feedback. If you're using Google docs, you can enable comments and submit a "draft" to your mentors. If you're using a format that doesn't accept comments, make sure your email is on the document and don't forget to check for feedback!
6. Submit your application to Google before the deadline. Note that Google does not extend this deadline, so it's best to be prepared early! You can edit your application up until the system closes.


## ⭐️ Tips


### Time Commitment
Contributors are [expected](https://developers.google.com/open-source/gsoc/faq#how_much_time_does_gsoc_participation_take) to work either 350 hours (full-time eqivalent) or 175 hours (part-time equivalent) over the course of the program. The default schedule runs over 3 months and can potentially be spread over a longer period. We do not recommend taking on another full-time internship, job, or schooling during the GSoC period, although a few weeks of overlap is often fine.  

### Selection Tips

#### Communicate with mentors
Ask questions directly on in the public opendbm@aicure.com listserve. If conversations advance we'll pull you into a private email This lets. *If selected we will add you to our private channel on the OpenDBM Community Home on the Discourse Platform*

#### Communicate with Community
Google intends this to be a way for new contributors to join the world of open source. The contributors most likely to be selected are those who are engaged with the community and hoping to continue their involvement for more than just a few months. It's more important to be a good community member than it is to be a good coder.
i

#### Have learning mindset
Listen and use feedback from others. We value communication and will reject contributors who don't listen to mentors. If selected, we will place special oversight to ensure mentors and contributors are listening to eachother and having fruitful discussion. Remember: the mentors are using their interactions with you to figure out if it's worth their volunteer time to work with you. No one wants to have an intern who doesn't listen, and contributors who don't listen also don't produce code that the open source project can use, so contributors who don't listen don't get hired. Nor do contributors who are arrogant jerks, or who violate the Code of Conduct. Be professional and show that you will take the mentoring relationship seriously.

### What should I do if No won answers my question

1. Be a patient. 
2. Make sure you're asking in the best place
3. Try giving more information
4. If you're really having trouble getting in touch with your mentors, talk to the python or admins by emailing gsoc-admins@python.org.

## ⭐️ Google Resources
The [GSoC student Guide](https://google.github.io/gsocguides/student/) -- This is a guide written by mentors and former contributors. It covers many questions that most contributors ask us. (Note that it was written when all GSoC contributors were students.) Please read it before asking any questions on the mailing list or IRC if you can! New contributors in particular might want to read the section [Am I Good Enough?](https://google.github.io/gsocguides/student/am-i-good-enough)
Check this out for [Google's list of resources](https://developers.google.com/open-source/gsoc/resources/  ).


