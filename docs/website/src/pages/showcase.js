/**
 * Copyright (c) AiCure, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import React from 'react';
import Layout from '@theme/Layout';

import useBaseUrl from '@docusaurus/useBaseUrl';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

const renderApp = (app, i) => {
  return (
    <div className="showcase" key={i}>
      <div>
        <a href={app.infoLink}>{renderAppIcon(app)}</a>
        <h3>{app.name}</h3>
        {renderLinks(app)}
        {renderInfo(app.infoTitle, app.infoLink)}
      </div>
    </div>
  );
};

const renderAppIcon = app => {
  let imgSource = app.icon;
  if (!app.icon.startsWith('http')) {
    imgSource = useBaseUrl('img/showcase/' + app.icon);
  }
  return <img src={imgSource} alt={app.name} />;
};

const renderInfo = (title, uri) => {
  return uri ? (
    <p className="info">
      <a href={uri} target="_blank">
        {title}
      </a>
    </p>
  ) : null;
};

const renderLinks = app => {
  if (!app.linkAppStore && !app.linkPlayStore) {
    return;
  }

  const linkAppStore = app.linkAppStore ? (
    <a href={app.linkAppStore} target="_blank">
      iOS
    </a>
  ) : null;
  const linkPlayStore = app.linkPlayStore ? (
    <a href={app.linkPlayStore} target="_blank">
      Android
    </a>
  ) : null;

  return (
    <p>
      {linkPlayStore}
      {linkPlayStore && linkAppStore ? ' • ' : ''}
      {linkAppStore}
    </p>
  );
};

const Showcase = () => {
  const {siteConfig} = useDocusaurusContext();

  const showcaseApps = siteConfig.customFields.users;
  const pinnedApps = showcaseApps.filter(app => app.pinned);
  const featuredApps = showcaseApps
    .filter(app => !app.pinned)
    .sort((a, b) => a.name.localeCompare(b.name));
  const apps = pinnedApps.concat(featuredApps);

  return (
    <Layout
      title="Who's using OpenDBM?"
      description="Some already using openDBM. You can check these below">
      <div className="showcaseSection">
        <div className="prose">
          <h1>Who's using OpenDBM?</h1>
          <p>
            This section attempts to list all peer-reviewed scientific articlces
            that have used OpenDBM for measurement of digital biomarkers.
          </p>
        </div>
        <div>
          <ul>
            <li>
              Galatzer-Levy, I., Abbas, A., Koesmahargyo, V., Yadav, V.,
              Perez-Rodriguez, M. M., Rosenfield, P., ... & Hansen, B. J.
              (2020). Facial and vocal markers of schizophrenia measured using
              remote smartphone assessments. medRxiv.
            </li>
            <li>
              Galatzer-Levy, I. R., Abbas, A., Ries, A., Homan, S.,
              Koesmahargyo, V., Yadav, V., ... & Scholz, U. (2020). Validation
              of Visual and Auditory Digital Markers of Suicidality in Acutely
              Suicidal Psychiatric In-Patients. medRxiv.
            </li>
          </ul>
        </div>
        <a
          className="form-button"
          href="https://forms.gle/Hb6bDL1GJvG1ByUX7"
          target="_blank">
          To add to this list, please simply fill out this form.
        </a>
      </div>
    </Layout>
  );
};

export default Showcase;
