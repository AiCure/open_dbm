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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Threading;
using System.Windows.Threading;
using System.Diagnostics;

// Internal libraries
using OpenFaceOffline;
using OpenCVWrappers;
using CppInterop.LandmarkDetector;
using FaceAnalyser_Interop;
using FaceDetectorInterop;
using GazeAnalyser_Interop;
using UtilitiesOF;


namespace OpenFaceDemo
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        // -----------------------------------------------------------------
        // Members
        // -----------------------------------------------------------------
        // Timing for measuring FPS
        #region High-Resolution Timing
        static DateTime startTime;
        static Stopwatch sw = new Stopwatch();

        static MainWindow()
        {
            startTime = DateTime.Now;
            sw.Start();
        }

        public static DateTime CurrentTime
        {
            get { return startTime + sw.Elapsed; }
        }
        #endregion

        Thread processing_thread;

        // Some members for displaying the results
        private WriteableBitmap latest_img;

        private volatile bool thread_running;
        
        FpsTracker processing_fps = new FpsTracker();

        // Controlling the model reset
        volatile bool reset = false;
        Point? resetPoint = null;

        // For selecting webcams
        CameraSelection cam_sec;

        // For tracking
        FaceModelParameters face_model_params;

        FaceAnalyserManaged face_analyser;
        CLNF landmark_detector;
        GazeAnalyserManaged gaze_analyser;

        public MainWindow()
        {
            InitializeComponent();

            // Set the icon
            Uri iconUri = new Uri("logo1.ico", UriKind.RelativeOrAbsolute);
            this.Icon = BitmapFrame.Create(iconUri);

            String root = AppDomain.CurrentDomain.BaseDirectory;

            // TODO, create a demo version of parameters
            face_model_params = new FaceModelParameters(root, true, false, false);
            face_model_params.optimiseForVideo();

            // Initialize the face detector
            FaceDetector face_detector = new FaceDetector(face_model_params.GetHaarLocation(), face_model_params.GetMTCNNLocation());

            // If MTCNN model not available, use HOG
            if (!face_detector.IsMTCNNLoaded())
            {
                face_model_params.SetFaceDetector(false, true, false);
            }

            landmark_detector = new CLNF(face_model_params);
            face_analyser = new FaceAnalyserManaged(root, true, 112, true);
            gaze_analyser = new GazeAnalyserManaged();

            Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
            {

                headPosePlot.AssocColor(0, Colors.Blue);
                headPosePlot.AssocColor(1, Colors.Red);
                headPosePlot.AssocColor(2, Colors.Green);

                headPosePlot.AssocName(1, "Turn");
                headPosePlot.AssocName(2, "Tilt");
                headPosePlot.AssocName(0, "Up/Down");

                headPosePlot.AssocThickness(0, 2);
                headPosePlot.AssocThickness(1, 2);
                headPosePlot.AssocThickness(2, 2);

                gazePlot.AssocColor(0, Colors.Red);
                gazePlot.AssocColor(1, Colors.Blue);

                gazePlot.AssocName(0, "Left-right");
                gazePlot.AssocName(1, "Up-down");
                gazePlot.AssocThickness(0, 2);
                gazePlot.AssocThickness(1, 2);

                smilePlot.AssocColor(0, Colors.Green);
                smilePlot.AssocColor(1, Colors.Red);
                smilePlot.AssocName(0, "Smile");
                smilePlot.AssocName(1, "Frown");
                smilePlot.AssocThickness(0, 2);
                smilePlot.AssocThickness(1, 2);
                
                browPlot.AssocColor(0, Colors.Green);
                browPlot.AssocColor(1, Colors.Red);
                browPlot.AssocName(0, "Raise");
                browPlot.AssocName(1, "Furrow");
                browPlot.AssocThickness(0, 2);
                browPlot.AssocThickness(1, 2);

                eyePlot.AssocColor(0, Colors.Green);
                eyePlot.AssocColor(1, Colors.Red);
                eyePlot.AssocName(0, "Eye widen");
                eyePlot.AssocName(1, "Nose wrinkle");
                eyePlot.AssocThickness(0, 2);
                eyePlot.AssocThickness(1, 2);

            }));

        }


        private void StopTracking()
        {
            // First complete the running of the thread
            if (processing_thread != null)
            {
                // Tell the other thread to finish
                thread_running = false;
                processing_thread.Join();
            }
        }

        // The main function call for processing the webcam feed
        private void ProcessingLoop(SequenceReader reader)
        {

            thread_running = true;

            Thread.CurrentThread.IsBackground = true;

            DateTime? startTime = CurrentTime;

            var lastFrameTime = CurrentTime;

            landmark_detector.Reset();
            face_analyser.Reset();

            int frame_id = 0;

            double old_gaze_x = 0;
            double old_gaze_y = 0;

            double smile_cumm = 0;
            double frown_cumm = 0;
            double brow_up_cumm = 0;
            double brow_down_cumm = 0;
            double widen_cumm = 0;
            double wrinkle_cumm = 0;

            while (thread_running)
            {

                // Loading an image file
                RawImage frame = reader.GetNextImage();
                RawImage gray_frame = reader.GetCurrentFrameGray();
                
                lastFrameTime = CurrentTime;
                processing_fps.AddFrame();

                // The face analysis step
                bool detection_succeeding = landmark_detector.DetectLandmarksInVideo(frame, face_model_params, gray_frame);
                face_analyser.AddNextFrame(frame, landmark_detector.CalculateAllLandmarks(), detection_succeeding, true);
                gaze_analyser.AddNextFrame(landmark_detector, detection_succeeding, reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());

                double confidence = landmark_detector.GetConfidence();

                if (confidence < 0)
                    confidence = 0;
                else if (confidence > 1)
                    confidence = 1;

                List<float> pose = new List<float>();

                landmark_detector.GetPose(pose, reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());

                List<float> non_rigid_params = landmark_detector.GetNonRigidParams();
                float scale = landmark_detector.GetRigidParams()[0];

                double time_stamp = (DateTime.Now - (DateTime)startTime).TotalMilliseconds;

                
                List<Tuple<Point, Point>> lines = null;
                List<Tuple<float, float>> landmarks = null;
                List<Tuple<float, float>> eye_landmarks = null;
                List<Tuple<Point, Point>> gaze_lines = null;
                List<bool> visibilities = null;
 
                Tuple<float, float> gaze_angle = gaze_analyser.GetGazeAngle();

                if (detection_succeeding)
                {
                    landmarks = landmark_detector.CalculateVisibleLandmarks();
                    eye_landmarks = landmark_detector.CalculateVisibleEyeLandmarks();
                    lines = landmark_detector.CalculateBox(reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());
                    gaze_lines = gaze_analyser.CalculateGazeLines(reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());
                    visibilities = landmark_detector.GetVisibilities();
                }

                // Visualisation
                Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
                {

                    var au_regs = face_analyser.GetCurrentAUsReg();
                    if (au_regs.Count > 0)
                    {
                        double smile = (au_regs["AU12"] + au_regs["AU06"] + au_regs["AU25"]) / 13.0;
                        double frown = (au_regs["AU15"] + au_regs["AU17"]) / 12.0;

                        double brow_up = (au_regs["AU01"] + au_regs["AU02"]) / 10.0;
                        double brow_down = au_regs["AU04"] / 5.0;

                        double eye_widen = au_regs["AU05"] / 3.0;
                        double nose_wrinkle = au_regs["AU09"] / 4.0;

                        Dictionary<int, double> smileDict = new Dictionary<int, double>();
                        smileDict[0] = 0.7 * smile_cumm + 0.3 * smile;
                        smileDict[1] = 0.7 * frown_cumm + 0.3 * frown;
                        smilePlot.AddDataPoint(new DataPointGraph() { Time = CurrentTime, values = smileDict, Confidence = confidence });

                        Dictionary<int, double> browDict = new Dictionary<int, double>();
                        browDict[0] = 0.7 * brow_up_cumm + 0.3 * brow_up;
                        browDict[1] = 0.7 * brow_down_cumm + 0.3 * brow_down;
                        browPlot.AddDataPoint(new DataPointGraph() { Time = CurrentTime, values = browDict, Confidence = confidence });

                        Dictionary<int, double> eyeDict = new Dictionary<int, double>();
                        eyeDict[0] = 0.7 * widen_cumm + 0.3 * eye_widen;
                        eyeDict[1] = 0.7 * wrinkle_cumm + 0.3 * nose_wrinkle;
                        eyePlot.AddDataPoint(new DataPointGraph() { Time = CurrentTime, values = eyeDict, Confidence = confidence });

                        smile_cumm = smileDict[0];
                        frown_cumm = smileDict[1];
                        brow_up_cumm = browDict[0];
                        brow_down_cumm = browDict[1];
                        widen_cumm = eyeDict[0];
                        wrinkle_cumm = eyeDict[1];
                    }
                    else
                    {
                        // If no AUs present disable the AU visualization
                        MainGrid.ColumnDefinitions[2].Width = new GridLength(0);
                        eyePlot.Visibility = Visibility.Collapsed;
                        browPlot.Visibility = Visibility.Collapsed;
                        smilePlot.Visibility = Visibility.Collapsed;
                    }

                    Dictionary<int, double> poseDict = new Dictionary<int, double>();
                    poseDict[0] = -pose[3];
                    poseDict[1] = pose[4];
                    poseDict[2] = pose[5];
                    headPosePlot.AddDataPoint(new DataPointGraph() { Time = CurrentTime, values = poseDict, Confidence = confidence });

                    Dictionary<int, double> gazeDict = new Dictionary<int, double>();
                    gazeDict[0] = gaze_angle.Item1 * (180.0 / Math.PI);
                    gazeDict[0] = 0.5 * old_gaze_x + 0.5 * gazeDict[0];
                    gazeDict[1] = -gaze_angle.Item2 * (180.0 / Math.PI);
                    gazeDict[1] = 0.5 * old_gaze_y + 0.5 * gazeDict[1];
                    gazePlot.AddDataPoint(new DataPointGraph() { Time = CurrentTime, values = gazeDict, Confidence = confidence });

                    old_gaze_x = gazeDict[0];
                    old_gaze_y = gazeDict[1];

                    if (latest_img == null)
                    {
                        latest_img = frame.CreateWriteableBitmap();
                    }

                    frame.UpdateWriteableBitmap(latest_img);

                    video.Source = latest_img;
                    
                    video.FPS = processing_fps.GetFPS();

                    // First clear the old results
                    video.Clear();

                    video.Confidence.Add(confidence);

                    if(detection_succeeding)
                    {
                        video.FaceScale.Add(scale);

                        video.OverlayLines.Add(lines);

                        List<Point> landmark_points = new List<Point>();
                        foreach (var p in landmarks)
                        {
                            landmark_points.Add(new Point(p.Item1, p.Item2));
                        }

                        List<Point> eye_landmark_points = new List<Point>();
                        foreach (var p in eye_landmarks)
                        {
                            eye_landmark_points.Add(new Point(p.Item1, p.Item2));
                        }

                        video.OverlayPoints.Add(landmark_points);
                        video.OverlayEyePoints.Add(eye_landmark_points);
                        video.OverlayPointsVisibility.Add(visibilities);
                        video.OverlayEyePoints.Add(eye_landmark_points);

                        video.GazeLines.Add(gaze_lines);
                    }

                }));

                if (reset)
                {
                    // TODO add
                    if (resetPoint.HasValue)
                    {
                        //landmark_detector.Reset(resetPoint.Value.X, resetPoint.Value.Y);
                        resetPoint = null;
                    }
                    else
                    {
                        // TODO add
                        //landmark_detector.Reset();
                    }

                    // TODO add
                    //face_analyser.Reset();
                    reset = false;

                    Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
                    {
                        headPosePlot.ClearDataPoints();
                        headPosePlot.ClearDataPoints();
                        gazePlot.ClearDataPoints();
                        smilePlot.ClearDataPoints();
                        browPlot.ClearDataPoints();
                        eyePlot.ClearDataPoints();
                    }));
                }

                frame_id++;


            }
            reader.Close();
            latest_img = null;

        }
        
        // --------------------------------------------------------
        // Button handling
        // --------------------------------------------------------

        private void openWebcamClick(object sender, RoutedEventArgs e)
        {
            StopTracking();
            
            if (cam_sec == null)
            {
                cam_sec = new CameraSelection();
            }
            else
            {
                cam_sec = new CameraSelection(cam_sec.cams);
                cam_sec.Visibility = System.Windows.Visibility.Visible;
            }

            // Set the icon
            Uri iconUri = new Uri("logo1.ico", UriKind.RelativeOrAbsolute);
            cam_sec.Icon = BitmapFrame.Create(iconUri);

            if (!cam_sec.no_cameras_found)
                cam_sec.ShowDialog();

            if (cam_sec.camera_selected)
            {

                int cam_id = cam_sec.selected_camera.Item1;
                int width = cam_sec.selected_camera.Item2;
                int height = cam_sec.selected_camera.Item3;

                SequenceReader reader = new SequenceReader(cam_id, width, height);

                processing_thread = new Thread(() => ProcessingLoop(reader));
                processing_thread.Name = "Webcam processing";
                processing_thread.Start();

            }

        }
        
        // Cleanup stuff when closing the window
        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (processing_thread != null)
            {
                // Stop capture and tracking
                thread_running = false;
                processing_thread.Join();
                                
            }
            
            if (face_analyser != null)
                face_analyser.Dispose();
            if(landmark_detector != null)
                landmark_detector.Dispose();

        }

        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.R)
            {
                reset = true;
            }
        }

        private void video_MouseDown(object sender, MouseButtonEventArgs e)
        {
            var clickPos = e.GetPosition(video);
            resetPoint = new Point(clickPos.X / video.ActualWidth, clickPos.Y / video.ActualHeight);
            reset = true;
        }


    }
}
