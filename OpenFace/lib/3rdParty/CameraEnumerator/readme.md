# Device Enumerator for OpenCV 

This project contains a *C++* class that allows the enumeration of devices using DirectShow in Windows, in order to select and obtain the ID that needs to be used with OpenCV when creating, for example, a VideoCapture object to grab frames from a camera. I decided to put this up as "How to get the ID of a device to use inside OpenCV?" is a question that pops up continuously.

## Contents

The project contains the class itself (DeviceEnumerator.h and DeviceEnumerator.cpp) and also an example of how to use the class (OpenCVDeviceEnumerator.cpp)

## License

MIT License

Copyright (c) 2018 David Gil de Gómez Pérez (Studiosi)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

