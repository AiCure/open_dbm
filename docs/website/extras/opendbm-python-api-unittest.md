---
id: opendbm-python-api-unittest
title: OpenDBM API - Unit Test
---

#### Prerequisites read
* [OpenDBM Python API](opendbm-python-api)

The framework we use to do unit testing is pytest. We use pytest because we want our test design to be very similar to our API design and make the unit test easier to understand. Below is the general architecture of the tests folder.


<figure>
  <img src="../img/extras/api-test-docs-1.png" width="100%" alt="Unit Tests Folder" />
  <figcaption>Unit Tests Folder</figcaption>
</figure>


The picture above contains the test folder containing the test_data folder that will store many test files. 
All the files here will be used as test data during our unit testing.

Next to the test_data folder is conftest.py, the pytest configuration that will be applied to all the test scripts. This file's purpose is to initiate all the API, so we don't have to import it into our test script. 


Lastly, we have dbm group folders (facial, movement, speech, verbal acoustics). 
Each of these folders consistently has the same structure, which consists of the following:

### 1. Test Script
All test scripts file that has the prefix “test_” is where we create all our unit tests, respective to the folder.
(ex: test script inside the facial folder should only have unit test related to the facial API)

### 2. Configuration Test
This file named conftest.py in each folder will configure how many test data files you want to add to the test script. 
If you're going to add another test data, you should create a new function inside this file to feed it into the test script.

