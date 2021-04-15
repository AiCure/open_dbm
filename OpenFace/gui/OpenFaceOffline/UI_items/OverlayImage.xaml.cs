///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2016, Carnegie Mellon University and University of Cambridge,
// all rights reserved.
//
// THIS SOFTWARE IS PROVIDED “AS IS” FOR ACADEMIC USE ONLY AND ANY EXPRESS
// OR IMPLIED WARRANTIES WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY.
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Notwithstanding the license granted herein, Licensee acknowledges that certain components
// of the Software may be covered by so-called “open source” software licenses (“Open Source
// Components”), which means any software licenses approved as open source licenses by the
// Open Source Initiative or any substantially similar licenses, including without limitation any
// license that, as a condition of distribution of the software licensed under such license,
// requires that the distributor make the software available in source code format. Licensor shall
// provide a list of Open Source Components for a particular version of the Software upon
// Licensee’s request. Licensee will comply with the applicable terms of such licenses and to
// the extent required by the licenses covering Open Source Components, the terms of such
// licenses will apply in lieu of the terms of this Agreement. To the extent the terms of the
// licenses applicable to Open Source Components prohibit any of the restrictions in this
// License Agreement with respect to such Open Source Component, such restrictions will not
// apply to such Open Source Component. To the extent the terms of the licenses applicable to
// Open Source Components require Licensor to make an offer to provide source code or
// related information in connection with the Software, such offer is hereby made. Any request
// for source code or related information should be directed to cl-face-tracker-distribution@lists.cam.ac.uk
// Licensee acknowledges receipt of notices for the Open Source Components for the initial
// delivery of the Software.

//     * Any publications arising from the use of this software, including but
//       not limited to academic journal and conference publications, technical
//       reports and manuals, must cite at least one of the following works:
//
//       OpenFace: an open source facial behavior analysis toolkit
//       Tadas Baltrušaitis, Peter Robinson, and Louis-Philippe Morency
//       in IEEE Winter Conference on Applications of Computer Vision, 2016  
//
//       Rendering of Eyes for Eye-Shape Registration and Gaze Estimation
//       Erroll Wood, Tadas Baltrušaitis, Xucong Zhang, Yusuke Sugano, Peter Robinson, and Andreas Bulling 
//       in IEEE International. Conference on Computer Vision (ICCV),  2015 
//
//       Cross-dataset learning and person-speci?c normalisation for automatic Action Unit detection
//       Tadas Baltrušaitis, Marwa Mahmoud, and Peter Robinson 
//       in Facial Expression Recognition and Analysis Challenge, 
//       IEEE International Conference on Automatic Face and Gesture Recognition, 2015 
//
//       Constrained Local Neural Fields for robust facial landmark detection in the wild.
//       Tadas Baltrušaitis, Peter Robinson, and Louis-Philippe Morency. 
//       in IEEE Int. Conference on Computer Vision Workshops, 300 Faces in-the-Wild Challenge, 2013.    
//
///////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace OpenFaceOffline
{
    /// <summary>
    /// Interaction logic for OverlayImage.xaml
    /// </summary>
    public partial class OverlayImage : Image
    {
        public OverlayImage()
        {
            InitializeComponent();
            OverlayLines = new List<List<Tuple<Point, Point>>>();
            OverlayPoints = new List<List<Point>>();
            OverlayPointsVisibility = new List<List<bool>>();
            OverlayEyePoints = new List<List<Point>>();
            GazeLines = new List<List<Tuple<Point, Point>>>();
            Confidence = new List<double>();
            FaceScale = new List<double>();

            Progress = -1;
        }

        public void Clear()
        {
            OverlayLines.Clear();
            OverlayPoints.Clear();
            OverlayPointsVisibility.Clear();
            OverlayEyePoints.Clear();
            GazeLines.Clear();
            Confidence.Clear();
            FaceScale.Clear();
        }

        protected override void OnRender(DrawingContext dc)
        {
            base.OnRender(dc);

            if (OverlayLines == null)
                OverlayLines = new List<List<Tuple<Point, Point>>>();

            if (OverlayPoints == null)
                OverlayPoints = new List<List<Point>>();

            if (OverlayPointsVisibility == null)
                OverlayPointsVisibility = new List<List<bool>>();

            if (OverlayEyePoints == null)
                OverlayEyePoints = new List<List<Point>>();

            if (Source == null || !(Source is WriteableBitmap))
                return;

            var width = ((WriteableBitmap)Source).PixelWidth;
            var height = ((WriteableBitmap)Source).PixelHeight;

            // Go over all faces
            for (int i = 0; i < OverlayPoints.Count; i++)
            { 

                // The point and line size should be proportional to the face size and the image scaling 
                double scaling_p = 0.88 * FaceScale[i] * ActualWidth / width;

                // Low confidence leads to more transparent visualization
                double confidence = Confidence[i];
                if (confidence < 0.4)
                {
                    confidence = 0.4;
                }

                // Don't let it get too small
                if (scaling_p < 0.6)
                    scaling_p = 0.6;

                foreach (var line in OverlayLines[i])
                {

                    var p1 = new Point(ActualWidth * line.Item1.X / width, ActualHeight * line.Item1.Y / height);
                    var p2 = new Point(ActualWidth * line.Item2.X / width, ActualHeight * line.Item2.Y / height);
                    dc.DrawLine(new Pen(new SolidColorBrush(Color.FromArgb(200, (byte)(100 + (155 * (1 - confidence))), (byte)(100 + (155 * confidence)), 100)), 2.0 * scaling_p), p1, p2);
                }

                foreach (var line in GazeLines[i])
                {

                    var p1 = new Point(ActualWidth * line.Item1.X / width, ActualHeight * line.Item1.Y / height);
                    var p2 = new Point(ActualWidth * line.Item2.X / width, ActualHeight * line.Item2.Y / height);

                    var dir = p2 - p1;
                    p2 = p1 + dir * scaling_p * 2;
                    dc.DrawLine(new Pen(new SolidColorBrush(Color.FromArgb(200, (byte)(240), (byte)(30), (byte)100)), 5.0 * scaling_p), p1, p2);

                }

                for (int j = 0; j < OverlayPoints[i].Count; j++)
                {
                    var p = OverlayPoints[i][j];

                    var q = new Point(ActualWidth * p.X / width, ActualHeight * p.Y / height);

                    if(OverlayPointsVisibility[i].Count == 0 || OverlayPointsVisibility[i][j])
                    { 
                        dc.DrawEllipse(new SolidColorBrush(Color.FromArgb((byte)(230 * confidence), 255, 50, 50)), null, q, 2.75 * scaling_p, 3.0 * scaling_p);
                        dc.DrawEllipse(new SolidColorBrush(Color.FromArgb((byte)(230 * confidence), 255, 255, 100)), null, q, 1.75 * scaling_p, 2.0 * scaling_p);
                    }
                    else
                    {
                        // Draw fainter if landmark not visible
                        dc.DrawEllipse(new SolidColorBrush(Color.FromArgb((byte)(125 * confidence), 255, 50, 50)), null, q, 2.75 * scaling_p, 3.0 * scaling_p);
                        dc.DrawEllipse(new SolidColorBrush(Color.FromArgb((byte)(125 * confidence), 255, 255, 100)), null, q, 1.75 * scaling_p, 2.0 * scaling_p);
                    }
                }

                for (int id = 0; id < OverlayEyePoints[i].Count; id++)
                {

                    var q1 = new Point(ActualWidth * OverlayEyePoints[i][id].X / width, ActualHeight * OverlayEyePoints[i][id].Y / height);

                    // The the eye points can be defined for multiple faces, turn id's to be relevant to one face

                    int next_point = id + 1;

                    if (id == 7) next_point = 0;
                    if (id == 19) next_point = 8;
                    if (id == 27) next_point = 20;

                    if (id == 35) next_point = 28;
                    if (id == 47) next_point = 36;
                    if (id == 55) next_point = 48;

                    var q2 = new Point(ActualWidth * OverlayEyePoints[i][next_point].X / width, ActualHeight * OverlayEyePoints[i][next_point].Y / height);

                    if (id < 28 && (id < 8 || id > 19) || (id >= 28 &&(id - 28<8 || id - 28 >19)))
                    { 
                        dc.DrawLine(new Pen(new SolidColorBrush(Color.FromArgb(200, (byte)(240), (byte)(30), (byte)100)), 1.5 * scaling_p), q1, q2);
                    }
                    else
                    {
                        dc.DrawLine(new Pen(new SolidColorBrush(Color.FromArgb(200, (byte)(100), (byte)(30), (byte)240)), 2.5 * scaling_p), q1, q2);
                    }
                }
            }

            // Only display the confidence of the last face
            double scaling = ActualWidth / 400.0;

            int confidence_width = (int)(107.0 * scaling);
            int confidence_height = (int)(18.0 * scaling);

            int final_id = Confidence.Count - 1;

            Brush conf_brush = new SolidColorBrush(Color.FromRgb((byte)((1 - Confidence[final_id]) * 255), (byte)(Confidence[final_id] * 255), (byte)40));
            dc.DrawRoundedRectangle(conf_brush, new Pen(Brushes.Black, 0.5 * scaling), new Rect(ActualWidth - confidence_width - 1, 0, confidence_width, confidence_height), 3.0 * scaling, 3.0 * scaling);

            FormattedText txt = new FormattedText("Confidence: " + (int)(100 * Confidence[final_id]) + "%", System.Globalization.CultureInfo.CurrentCulture, System.Windows.FlowDirection.LeftToRight, new Typeface("Verdana"), 12.0 * scaling, Brushes.Black);
            dc.DrawText(txt, new Point(ActualWidth - confidence_width + 2, 2));

            int fps_width = (int)(52.0 * scaling);
            int fps_height = (int)(18.0 * scaling);

            dc.DrawRoundedRectangle(Brushes.WhiteSmoke, new Pen(Brushes.Black, 0.5 * scaling), new Rect(0, 0, fps_width, fps_height), 3.0 * scaling, 3.0 * scaling);
            FormattedText fps_txt = new FormattedText("FPS: " + (int)FPS, System.Globalization.CultureInfo.CurrentCulture, System.Windows.FlowDirection.LeftToRight, new Typeface("Verdana"), 12.0 * scaling, Brushes.Black);
            dc.DrawText(fps_txt, new Point(2.0 * scaling, 0));

            old_width = width;
            old_height = height;

            // Drawing a progress bar at the bottom of the image
            if (Progress > 0)
            {
                int progress_bar_height = (int)(6.0 * scaling);
                dc.DrawRectangle(Brushes.GreenYellow, new Pen(Brushes.Black, 0.5 * scaling), new Rect(0, ActualHeight - progress_bar_height, Progress * ActualWidth, progress_bar_height));
            }

        }

        // To allow for visualizing multiple faces use a List of Lists
        public List<List<Tuple<Point, Point>>> OverlayLines { get; set; }
        public List<List<Tuple<Point, Point>>> GazeLines { get; set; }
        public List<List<Point>> OverlayPoints { get; set; }
        public List<List<bool>> OverlayPointsVisibility { get; set; }
        public List<List<Point>> OverlayEyePoints { get; set; }
        public List<double> FaceScale { get; set; }
        public List<double> Confidence { get; set; }
        public double FPS { get; set; }

        // 0 to 1 indicates how much video has been processed so far
        public double Progress { get; set; }

        int old_width;
        int old_height;
    }
}
