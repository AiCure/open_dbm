///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2017, Carnegie Mellon University and University of Cambridge,
// all rights reserved.
//
// ACADEMIC OR NON-PROFIT ORGANIZATION NONCOMMERCIAL RESEARCH USE ONLY
//
// BY USING OR DOWNLOADING THE SOFTWARE, YOU ARE AGREEING TO THE TERMS OF THIS LICENSE AGREEMENT.  
// IF YOU DO NOT AGREE WITH THESE TERMS, YOU MAY NOT USE OR DOWNLOAD THE SOFTWARE.
//
// License can be found in OpenFace-license.txt

//     * Any publications arising from the use of this software, including but
//       not limited to academic journal and conference publications, technical
//       reports and manuals, must cite at least one of the following works:
//
//       OpenFace 2.0: Facial Behavior Analysis Toolkit
//       Tadas Baltrušaitis, Amir Zadeh, Yao Chong Lim, and Louis-Philippe Morency
//       in IEEE International Conference on Automatic Face and Gesture Recognition, 2018  
//
//       Convolutional experts constrained local model for facial landmark detection.
//       A. Zadeh, T. Baltrušaitis, and Louis-Philippe Morency,
//       in Computer Vision and Pattern Recognition Workshops, 2017.    
//
//       Rendering of Eyes for Eye-Shape Registration and Gaze Estimation
//       Erroll Wood, Tadas Baltrušaitis, Xucong Zhang, Yusuke Sugano, Peter Robinson, and Andreas Bulling 
//       in IEEE International. Conference on Computer Vision (ICCV),  2015 
//
//       Cross-dataset learning and person-specific normalisation for automatic Action Unit detection
//       Tadas Baltrušaitis, Marwa Mahmoud, and Peter Robinson 
//       in Facial Expression Recognition and Analysis Challenge, 
//       IEEE International Conference on Automatic Face and Gesture Recognition, 2015 
//
///////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;

namespace OpenFaceOffline
{
    public class FpsTracker
    {
        public TimeSpan HistoryLength { get; set; }
        public FpsTracker()
        {
            HistoryLength = TimeSpan.FromSeconds(2);
        }

        private Queue<DateTime> frameTimes = new Queue<DateTime>();

        private void DiscardOldFrames()
        {
            while (frameTimes.Count > 0 && (MainWindow.CurrentTime - frameTimes.Peek()) > HistoryLength)
                frameTimes.Dequeue();
        }

        public void AddFrame()
        {
            frameTimes.Enqueue(MainWindow.CurrentTime);
            DiscardOldFrames();
        }

        public double GetFPS()
        {
            DiscardOldFrames();

            if (frameTimes.Count == 0)
                return 0;

            return frameTimes.Count / (MainWindow.CurrentTime - frameTimes.Peek()).TotalSeconds;
        }
    }
}
