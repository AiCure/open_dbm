/**
 * Copyright (c) AiCure, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import React from 'react';
import Layout from '@theme/Layout';

import useBaseUrl from '@docusaurus/useBaseUrl';
const versions = require('../../versions.json');

const VersionItem = ({version, currentVersion}) => {
  const versionName = version === 'next' ? 'Master' : version;

  const isCurrentVersion = currentVersion === version;
  const isNext = version === 'next';
  const isRC = version.toUpperCase().indexOf('-RC') !== -1;

  const latestMajorVersion = versions[0].toUpperCase().replace('-RC', '');
  const documentationLink = (
    <a
      href={useBaseUrl(
        'docs/' + (isCurrentVersion ? '' : version + '/') + 'getting-started'
      )}>
      Documentation
    </a>
  );
  let releaseNotesURL = 'https://github.com/AiCure/open_dbm/releases';
  let releaseNotesTitle = 'Changelog';
  if (isNext) {
    releaseNotesURL = `https://github.com/AiCure/open_dbm/compare/${latestMajorVersion}-stable...main`;
    releaseNotesTitle = 'Commits since ' + latestMajorVersion;
  } else if (!isRC) {
    releaseNotesURL = `https://github.com/AiCure/open_dbm/releases/tag/v${version}.0`;
  }

  const releaseNotesLink = <a href={releaseNotesURL}>{releaseNotesTitle}</a>;

  return (
    <tr>
      <th>{versionName}</th>
      <td>{documentationLink}</td>
      <td>{releaseNotesLink}</td>
    </tr>
  );
};

const Versions = () => {
  const currentVersion = versions.length > 0 ? versions[0] : null;
  const latestVersions = ['next'].concat(
    versions.filter(version => version.indexOf('-RC') !== -1)
  );
  const stableVersions = versions.filter(
    version => version.indexOf('-RC') === -1 && version !== currentVersion
  );

  return (
    <Layout title="Versions" wrapperClassName="versions-page">
      <h1>OpenDBM versions</h1>
      <p>
        When we want to plan for a release, a new release candidate is created
        off the <code>master</code> branch of{' '}
        <a href={'https://github.com/AiCure/open_dbm'}>
          <code>AiCure/open_dbm</code>
        </a>
        . The release candidate will be online for some time to allow
        contributors like yourself to{' '}
        <a href={useBaseUrl('docs/upgrading')}>verify the changes</a> and to
        identify any issues by{' '}
        <a href="https://github.com/AiCure/open_dbm/issues">
          writing clear, actionable bug reports
        </a>
        . Eventually, the release candidate will be promoted to{' '}
        <code>master</code> .
      </p>

      <h2>Latest version</h2>
      <p>
        The most recent stable version will be publish automatically whenever a
        new release tag is created using the{' '}
        <code>github git tag [new version]</code> command.
      </p>
      <table className="versions">
        <tbody>
          <VersionItem
            key={'version_' + currentVersion}
            version={currentVersion}
            currentVersion={currentVersion}
          />
        </tbody>
      </table>
      <h2>Previous versions</h2>
      <table className="versions">
        <tbody>
          {stableVersions.map(version => (
            <VersionItem
              key={'version_' + version}
              version={version}
              currentVersion={currentVersion}
            />
          ))}
        </tbody>
      </table>
      <h2>Archived versions</h2>
      <p>
        The documentation for versions below <code>0.2.0</code> can be found on
        the separate docs word{' '}
        <a href="https://docs.google.com/document/d/1O6OUSY9FHFCZfpIWu3Kgg0Q_dyp073xjjQ2K3viEffU/edit#heading=h.ttfc0bhy0aif">
          in here
        </a>
        .
      </p>
    </Layout>
  );
};

export default Versions;
