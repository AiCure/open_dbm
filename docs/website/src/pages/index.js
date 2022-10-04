import React, {useEffect} from 'react';
import GitHubButton from 'react-github-btn';

import Head from '@docusaurus/Head';
import useBaseUrl from '@docusaurus/useBaseUrl';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

import Layout from '@theme/Layout';
import CodeBlock from '@theme/CodeBlock';

import CrossPlatformSVG from '../../static/img/homepage/cross-platform.svg';
import {setupDissectionAnimation} from './animations/_dissectionAnimation';
import {setupHeaderAnimations} from './animations/_headerAnimation';

const textContent = {
  intro: `
  OpenDBM is a software package that allows for calculation of digital biomarkers from video/audio of a person's
  behavior by combining tools to measure behavioral characteristics like facial activity, voice, and movement into a single package for measurement of overall behavior.
<br/><br/>
<strong>Ease of use</strong>. OpenDBM is designed for ease of use, expanding the availability of such tools to the wider scientific community. 
  `,
  writtenPython: `
It using Python language so you can integrate with other biomaker or ML libraries
<br/><br/>
<strong>Many OS platforms</strong>, one code. You can focus on building researching medical purpose
and the single codebase can share code across platforms. With OpenDBM,
one team can maintain multiple OS platforms and share a common researching application.
  `,
  codeExample: `
  from opendbm.facial import FacialActivity

  model = FacialActivity()
  
  m.fit()
  landmark = model.get_landmark()
  landmark.mean()
  landmark.std()
  `,
  forResearchers: `
  Through OpenDBM, a user can objectively and sensitively measure behavioral characteristics such as facial activity, vocal acoustics, 
  characteristics of speech, patterns of movement, and oculomotion. <br/><br/>
  From those behavioral characteristics, they can measure clinically meaningful symptomatology such as emotional expressivity, prosody 
  of voice, valence of speech, and severity of tremor––among many others.
  `,
  talks: `
  We’ve recorded some instructional videos (listed and linked to within the documentation) that should help the user get through 
  common steps such as installation, usage, etc.
  `,
};

function Heading({text}) {
  return <h2 className="Heading">{text}</h2>;
}

function ActionButton({href, type = 'primary', target, children}) {
  return (
    <a className={`ActionButton ${type}`} href={href} target={target}>
      {children}
    </a>
  );
}

function TextColumn({title, text, moreContent}) {
  return (
    <>
      <Heading text={title} />
      <div dangerouslySetInnerHTML={{__html: text}} />
      {moreContent}
    </>
  );
}

function HomeCallToAction() {
  return (
    <>
      <ActionButton
        type="primary"
        href={useBaseUrl('docs/getting-started')}
        target="_self">
        Get started
      </ActionButton>
      <ActionButton
        type="secondary"
        href={useBaseUrl('docs/tutorial')}
        target="_self">
        Learn basics
      </ActionButton>
    </>
  );
}

function GitHubStarButton() {
  return (
    <div className="github-button">
      <GitHubButton
        href="https://github.com/AiCure/open_dbm"
        data-icon="octicon-star"
        data-size="large"
        aria-label="Star AiCure/open_dbm on GitHub">
        Star
      </GitHubButton>
    </div>
  );
}

function Section({
  element = 'section',
  children,
  className,
  background = 'light',
}) {
  const El = element;
  return <El className={`Section ${className} ${background}`}>{children}</El>;
}

function TwoColumns({columnOne, columnTwo, reverse}) {
  return (
    <div className={`TwoColumns ${reverse ? 'reverse' : ''}`}>
      <div className={`column first ${reverse ? 'right' : 'left'}`}>
        {columnOne}
      </div>
      <div className={`column last ${reverse ? 'left' : 'right'}`}>
        {columnTwo}
      </div>
    </div>
  );
}

function ScreenRect({className, fill, stroke}) {
  return (
    <rect
      className={`screen ${className || ''}`}
      rx="3%"
      width="180"
      height="300"
      x="-90"
      y="-150"
      fill={fill}
      stroke={stroke}
    />
  );
}

function LogoAnimation() {
  return (
    <svg
      className="LogoAnimation init"
      width={350}
      height={350}
      xmlns="http://www.w3.org/2000/svg"
      viewBox="-200 -200 400 400">
      <title>OpenDBM logo</title>
      <clipPath id="screen">
        <ScreenRect fill="none" stroke="gray" />
      </clipPath>
      <rect
        x="-25"
        y="120"
        width="50"
        height="25"
        rx="2"
        fill="white"
        stroke="none"
        className="stand"
      />
      <polygon
        points="-125,90 125,90 160,145 -160,145"
        fill="white"
        stroke="white"
        strokeWidth="5"
        strokeLinejoin="round"
        className="base"
      />
      <ScreenRect className="background" stroke="none" />
      <g clipPath="url(#screen)" className="logo">
        <g className="logoInner">
          <circle cx="0" cy="0" r="30" fill="#61dafb" />
          <g stroke="#61dafb" strokeWidth="15" fill="none" id="logo">
            <ellipse rx="165" ry="64" />
            <ellipse rx="165" ry="64" transform="rotate(60)" />
            <ellipse rx="165" ry="64" transform="rotate(120)" />
          </g>
        </g>
        <line
          x1="-30"
          x2="30"
          y1="130"
          y2="130"
          stroke="white"
          strokeWidth="8"
          strokeLinecap="round"
          className="speaker"
        />
      </g>
      <ScreenRect fill="none" stroke="white" />
    </svg>
  );
}

function HeaderHero() {
  return (
    <Section background="dark" className="HeaderHero">
      <div className="socialLinks">
        <GitHubStarButton />
      </div>
      <TwoColumns
        reverse
        columnOne={
          <img alt="" src={useBaseUrl('img/homepage/biomaker_logo2.gif')} />
        }
        columnTwo={
          <>
            <h1 className="title">OpenDBM</h1>
            <p className="tagline">Digital Biomaker&nbsp;Library.</p>
            <div className="buttons">
              <HomeCallToAction />
            </div>
          </>
        }
      />
    </Section>
  );
}

function AdvancedBioMaker() {
  return (
    <Section className="AdvancedBioMaker" background="light">
      <TwoColumns
        reverse
        columnOne={
          <TextColumn
            title="Advanced Digital Biomaker"
            text={textContent.intro}
          />
        }
        columnTwo={<img alt="" src={useBaseUrl('img/homepage/biomaker.png')} />}
      />
    </Section>
  );
}

function WrittenPython() {
  return (
    <Section className="WrittenPython" background="tint">
      <TwoColumns
        columnOne={
          <TextColumn
            title="Written in Python—support all OS platforms"
            text={textContent.writtenPython}
          />
        }
        columnTwo={
          <CodeBlock language="jsx">{textContent.codeExample}</CodeBlock>
        }
      />
    </Section>
  );
}

function RichFeatures() {
  return (
    <Section className="RichFeatures" background="light">
      <TwoColumns
        reverse
        columnOne={
          <TextColumn
            title="Rich Features for Researchers"
            text={textContent.forResearchers}
          />
        }
        columnTwo={
          <div className="dissection">
            <img alt="" src={useBaseUrl('img/homepage/features.png')} />
          </div>
        }
      />
    </Section>
  );
}

function VideoContent() {
  return (
    <div>
      <Section className="VideoContent" background="tint">
        <br />
        <TwoColumns
          columnOne={
            <TextColumn title="Talks and Videos" text={textContent.talks} />
          }
          columnTwo={
            <div className="vidWrapper">
              <iframe
                src="https://www.youtube.com/embed/PNS-TQX5CFc"
                title="OpenDBM Virtual Training"
                frameBorder="0"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
            </div>
          }
        />
        <br />
        <TwoColumns
          columnOne={
            <>
              <p>
                The{' '}
                <a href="https://github.com/AiCure/open_dbm/graphs/contributors">
                  OpenDBM Contributor Team
                </a>{' '}
                has put together a short video where they explained about the
                installation in some platforms.
              </p>
            </>
          }
          columnTwo={
            <div className="vidWrapper">
              <iframe
                src="https://www.youtube.com/embed/CfNFBcf41u0"
                title="OpenDBM Installation on Mac"
                frameBorder="0"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
              <br></br>
              <iframe
                src="https://www.youtube.com/embed/TKON5UcxrwQ"
                title="OpenDBM How to use on Mac"
                frameBorder="0"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
            </div>
          }
        />
      </Section>
    </div>
  );
}

/* Community */

function AcknowledgementList() {
  const {siteConfig} = useDocusaurusContext();
  const apps = siteConfig.customFields.users.filter(app => app.pinned);

  return (
    <ul className="AcknowledgementList">
      {apps.map((app, i) => {
        const imgSource = !app.icon.startsWith('http')
          ? useBaseUrl('img/showcase/' + app.icon)
          : app.icon;
        return (
          <li key={i} className="item">
            {app.infoLink ? (
              <a href={app.infoLink}>
                <img src={imgSource} alt={app.name} />
              </a>
            ) : (
              <img src={imgSource} alt={app.name} />
            )}
          </li>
        );
      })}
    </ul>
  );
}

function Community() {
  return (
    <Section className="Community" background="light">
      <div className="content">
        <Heading text="Community Driven" />
        <TwoColumns
          columnOne={
            <>
              <p className="firstP">
                <img src={useBaseUrl(`img/header_logo.png`)} alt="" />
                <span>
                  AiCure released OpenDBM in 2020 and has been maintaining it
                  ever since.
                </span>
              </p>
              <p>
                We want to ensure that OpenDBM feels like a community of
                like-minded researchers and clinicians. Hence, there are a few
                ways we encourage users to stay involved––and why we encourage
                you to join DiME, too! Most importantly, if you’re interested in
                OpenDBM, star the repo and sign up for our listserv for all
                updates.
              </p>
              <p>
                If you’re thinking about contributing to OpenDBM––to which we
                say kudos––please{' '}
                <span>
                  <a href="opendbm@aicure.com">reach out to us.</a>
                </span>{' '}
                We’ve written{' '}
                <span>
                  <a href="https://github.com/AiCure/open_dbm/blob/master/CODE_OF_CONDUCT.md">
                    code of conduct
                  </a>
                </span>{' '}
                and{' '}
                <span>
                  <a href="https://github.com/AiCure/open_dbm/blob/master/CONTRIBUTING.md">
                    contribution guidelines
                  </a>
                </span>{' '}
                but also want to do whatever we can to help.
              </p>
            </>
          }
          columnTwo={
            <>
              <p>
                <strong>Acknowledgements</strong> <br></br>A point that was
                mentioned earlier and cannot be emphasized enough is that
                OpenDBM is simply a compilation of existing but disparate
                open-source software tools that we’ve built on top of. All these
                tools are of course listed in the OpenDBM dependencies but we
                want to acknowledge just a few here: OpenFace, built on OpenCV,
                is at the heart of all facial measures and even some of the
                movement ones. Parselmouth and its reliance on the Praat
                software library lies behind most of the vocal acoustic
                measures. DeepSpeech was used for all speech transcription and
                NLTK is utilized for a lot of language metrics. OpenDBM would
                not be possible without these––and several other––open source
                software packages.
              </p>
              <AcknowledgementList />
            </>
          }
        />
      </div>
    </Section>
  );
}

function GetStarted() {
  return (
    <Section className="GetStarted" background="dark">
      <div className="content">
        <Heading text="Give it a try" />
        <ol className="steps">
          <li>
            <p>Run this</p>
            <div className="terminal">
              <code>pip install opendbm</code>
            </div>
          </li>
          <li>
            <p>Read these</p>
            <HomeCallToAction />
          </li>
        </ol>
      </div>
    </Section>
  );
}

const useHomePageAnimations = () => {
  useEffect(() => setupHeaderAnimations(), []);
  useEffect(() => setupDissectionAnimation(), []);
};

const Index = () => {
  useHomePageAnimations();
  return (
    <Layout
      description="A digital biomaker reader based on Python"
      wrapperClassName="homepage">
      <Head>
        <title>OpenDBM · Digital Biomaker Library</title>
        <meta
          property="og:title"
          content="OpenDBM · Digital Biomaker Library"
        />
        <meta
          property="twitter:title"
          content="OpenDBM · Digital Biomaker Library"
        />
      </Head>
      <HeaderHero />
      <AdvancedBioMaker />
      <WrittenPython />
      <RichFeatures />
      <VideoContent />
      <Community />
      <GetStarted />
    </Layout>
  );
};

export default Index;
