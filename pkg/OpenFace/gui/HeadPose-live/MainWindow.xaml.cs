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
using System.Diagnostics;
using System.Drawing.Imaging;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

using OpenCVWrappers;
using CppInterop;
using CppInterop.LandmarkDetector;
using System.Windows.Threading;
using GazeAnalyser_Interop;
using FaceDetectorInterop;

using ZeroMQ;
using System.Drawing;
using System.Collections.Concurrent;

namespace HeadPoseLive
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
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

        OpenFaceOffline.FpsTracker processing_fps = new OpenFaceOffline.FpsTracker();

        Thread processing_thread;
        Thread rec_thread;

        string subject_id;
        bool record_video;
        bool record_head_pose;

        // Controls if the view should be mirrored or not
        volatile bool mirror_image = false;

        // Capturing and displaying the images
        OpenFaceOffline.OverlayImage webcam_img;

        // Some members for displaying the results
        private WriteableBitmap latest_img;

        // For tracking
        bool reset = false;

        // For recording
        string record_root = "./head_pose_live_recordings/subject";
        string output_root;
        private Object recording_lock = new Object();
        int trial_id = 0;
        bool recording = false;
        int img_width;
        int img_height;

        double seconds_to_record = 10;

        System.IO.StreamWriter recording_success_file = null;

        ConcurrentQueue<Tuple<RawImage, bool, List<float>>> recording_objects;

        // For broadcasting the results
        ZeroMQ.ZContext zero_mq_context;
        ZeroMQ.ZSocket zero_mq_socket;

        volatile bool running = true;
        volatile bool pause = false;

        public void StartExperiment()
        {
            // Inquire more from the user

            // Get the entry dialogue now for the subject ID
            trial_id = 0;
            TextEntryWindow subject_id_window = new TextEntryWindow();
            subject_id_window.Icon = this.Icon;

            subject_id_window.WindowStartupLocation = WindowStartupLocation.CenterScreen;

            if (subject_id_window.ShowDialog() == true)
            {

                subject_id = subject_id_window.ResponseText;

                // Remove trailing spaces and full stops at the end of the folder name
                int old_length;
                do
                {
                    old_length = subject_id.Length;
                    subject_id = subject_id.Trim();
                    if (subject_id.Length > 0)
                    {
                        while (subject_id[subject_id.Length - 1].Equals('.'))
                        {
                            subject_id = subject_id.Substring(0, subject_id.Length - 1);
                        }
                    }
                } while (subject_id.Length != old_length);

                output_root = record_root + subject_id + "/";

                if (System.IO.Directory.Exists(output_root))
                {
                    string messageBoxText = "The recording for subject already exists, are you sure you want to continue?";
                    string caption = "Directory exists!";
                    MessageBoxButton button = MessageBoxButton.YesNo;
                    MessageBoxImage icon = MessageBoxImage.Warning;
                    MessageBoxResult result = MessageBox.Show(messageBoxText, caption, button, icon);
                    if (result == MessageBoxResult.No)
                    {
                        this.Close();
                    }

                    // Else find the latest trial from which to continu
                    int trial_id_not_found = 0;
                    while (System.IO.File.Exists(output_root + '/' + "trial_" + trial_id_not_found + ".avi"))
                    {
                        trial_id_not_found++;
                    }
                    trial_id = trial_id_not_found;
                }

                System.IO.Directory.CreateDirectory(output_root);

                record_video = subject_id_window.RecordVideo;
                record_head_pose = subject_id_window.RecordHeadPose;
                RecordingButton.Content = "Record trial: " + trial_id;

            }
            else
            {
                this.Close();
            }

        }

        public MainWindow()
        {
            InitializeComponent();

            DateTime now = DateTime.Now;

            // Set the icon
            Uri iconUri = new Uri("logo1.ico", UriKind.RelativeOrAbsolute);
            this.Icon = BitmapFrame.Create(iconUri);

            // Warn about the liability
            Liability liab = new Liability();
            liab.Icon = BitmapFrame.Create(iconUri);
            liab.ShowDialog();

            if (!liab.continue_pressed)
            {
                this.Close();
                return;
            }

            BitmapImage src = new BitmapImage();
            src.BeginInit();
            src.UriSource = new Uri("logo1.png", UriKind.RelativeOrAbsolute);
            src.CacheOption = BitmapCacheOption.OnLoad;
            src.EndInit();

            logoLabel.Source = src;

            // First make the user chooose a webcam
            OpenFaceOffline.CameraSelection cam_select = new OpenFaceOffline.CameraSelection();
            cam_select.Icon = BitmapFrame.Create(iconUri);

            if (!cam_select.no_cameras_found)
            {
                cam_select.ShowDialog();
            }

            if (cam_select.camera_selected)
            {

                // Create the capture device
                int cam_id = cam_select.selected_camera.Item1;
                img_width = cam_select.selected_camera.Item2;
                img_height = cam_select.selected_camera.Item3;

                UtilitiesOF.SequenceReader reader = new UtilitiesOF.SequenceReader(cam_id, img_width, img_height);
                
                if (reader.IsOpened())
                {

                    // Create the ZeroMQ context for broadcasting the results
                    zero_mq_context = ZeroMQ.ZContext.Create();
                    zero_mq_socket = new ZSocket(zero_mq_context, ZeroMQ.ZSocketType.PUB);

                    // Bind on localhost port 5000
                    zero_mq_socket.Bind("tcp://127.0.0.1:5000");

                    processing_thread = new Thread(() => VideoLoop(reader));
                    processing_thread.Name = "Webcam processing";
                    processing_thread.Start();
                }
                else
                {

                    string messageBoxText = "Failed to open a webcam";
                    string caption = "Webcam failure";
                    MessageBoxButton button = MessageBoxButton.OK;
                    MessageBoxImage icon = MessageBoxImage.Warning;

                    // Display message box
                    MessageBox.Show(messageBoxText, caption, button, icon);
                    this.Close();
                }

                // Create an overlay image for display purposes
                webcam_img = new OpenFaceOffline.OverlayImage();

                webcam_img.SetValue(Grid.RowProperty, 1);
                webcam_img.SetValue(Grid.ColumnProperty, 1);
                MainGrid.Children.Add(webcam_img);

                StartExperiment();

            }
            else
            {
                cam_select.Close();
                this.Close();
            }

        }

        private bool ProcessFrame(CLNF landmark_detector, GazeAnalyserManaged gaze_analyser, FaceModelParameters model_params, RawImage frame, RawImage grayscale_frame, float fx, float fy, float cx, float cy)
        {
            bool detection_succeeding = landmark_detector.DetectLandmarksInVideo(frame, model_params, grayscale_frame);
            gaze_analyser.AddNextFrame(landmark_detector, detection_succeeding, fx, fy, cx, cy);
            return detection_succeeding;

        }

        // Capturing and processing the video frame by frame
        private void RecordingLoop()
        {
            // Set up the recording objects first
            Thread.CurrentThread.IsBackground = true;

            System.IO.StreamWriter output_head_pose_file = null;

            if (record_head_pose)
            {
                String filename_poses = output_root + "/trial_" + trial_id + ".poses.txt";
                output_head_pose_file = new System.IO.StreamWriter(filename_poses);
                output_head_pose_file.WriteLine("time(ms), success, pose_X(mm), pose_Y(mm), pose_Z(mm), pitch(deg), yaw(deg), roll(deg)");
            }

            VideoWriter video_writer = null;

            if (record_video)
            {
                double fps = processing_fps.GetFPS();
                String filename_video = output_root + "/trial_" + trial_id + ".avi";
                video_writer = new VideoWriter(filename_video, img_width, img_height, fps, true);
            }

            // The timiing should be when the item is captured, but oh well
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            while (recording)
            {
                Tuple<RawImage, bool, List<float>> recording_object;
                if (recording_objects.TryDequeue(out recording_object))
                {

                    if (record_video)
                    {
                        video_writer.Write(recording_object.Item1);
                    }

                    if (record_head_pose)
                    {
                        String output_pose_line = stopWatch.ElapsedMilliseconds.ToString();
                        if (recording_object.Item2)
                            output_pose_line += ", 1";
                        else
                            output_pose_line += ", 0";

                        for (int i = 0; i < recording_object.Item3.Count; ++i)
                        {
                            double num = recording_object.Item3[i];
                            if (i > 2)
                            {
                                output_pose_line += ", " + num * 180 / Math.PI;
                            }
                            else
                            {
                                output_pose_line += ", " + num;
                            }
                        }
                        output_head_pose_file.WriteLine(output_pose_line);
                    }
                }

                Thread.Sleep(10);
            }

            // Clean up the recording
            if (record_head_pose)
            {
                output_head_pose_file.Close();
            }
        }

        // Capturing and processing the video frame by frame
        private void VideoLoop(UtilitiesOF.SequenceReader reader)
        {
            Thread.CurrentThread.IsBackground = true;

            String root = AppDomain.CurrentDomain.BaseDirectory;
            FaceModelParameters model_params = new FaceModelParameters(root, true, false, false);

            // Initialize the face detector
            FaceDetector face_detector = new FaceDetector(model_params.GetHaarLocation(), model_params.GetMTCNNLocation());

            // If MTCNN model not available, use HOG
            if (!face_detector.IsMTCNNLoaded())
            {
                model_params.SetFaceDetector(false, true, false);
            }

            CLNF face_model = new CLNF(model_params);
            GazeAnalyserManaged gaze_analyser = new GazeAnalyserManaged();

            DateTime? startTime = CurrentTime;

            var lastFrameTime = CurrentTime;

            while (running)
            {

                //////////////////////////////////////////////
                // CAPTURE FRAME AND DETECT LANDMARKS FOLLOWED BY THE REQUIRED IMAGE PROCESSING
                //////////////////////////////////////////////

                RawImage frame = reader.GetNextImage();

                lastFrameTime = CurrentTime;
                processing_fps.AddFrame();

                var grayFrame = reader.GetCurrentFrameGray();

                if (mirror_image)
                { 
                    frame.Mirror();
                    grayFrame.Mirror();
                }

                bool detectionSucceeding = ProcessFrame(face_model, gaze_analyser, model_params, frame, grayFrame, reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());

                lock (recording_lock)
                {
                    if (recording)
                    {
                        // Add objects to recording queues
                        List<float> pose = new List<float>();
                        face_model.GetPose(pose, reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());
                        recording_objects.Enqueue(new Tuple<RawImage, bool, List<float>>(frame, detectionSucceeding, pose));

                    }
                }

                List<Tuple<System.Windows.Point, System.Windows.Point>> lines = null;
                List<Tuple<float, float>> eye_landmarks = null;
                List<System.Windows.Point> landmarks = new List<System.Windows.Point>();
                List<Tuple<System.Windows.Point, System.Windows.Point>> gaze_lines = null;
                Tuple<float, float> gaze_angle = new Tuple<float, float>(0, 0);
                var visibilities = face_model.GetVisibilities();
                double scale = face_model.GetRigidParams()[0];

                if (detectionSucceeding)
                {
                    List<Tuple<float, float>> landmarks_doubles = face_model.CalculateAllLandmarks();

                    foreach (var p in landmarks_doubles)
                        landmarks.Add(new System.Windows.Point(p.Item1, p.Item2));

                    eye_landmarks = face_model.CalculateVisibleEyeLandmarks();

                    gaze_lines = gaze_analyser.CalculateGazeLines(reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());
                    gaze_angle = gaze_analyser.GetGazeAngle();

                    lines = face_model.CalculateBox(reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());
                }

                if (reset)
                {
                    face_model.Reset();
                    reset = false;
                }

                // Visualisation updating
                try
                {
                    Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
                    {
                        if (latest_img == null)
                            latest_img = frame.CreateWriteableBitmap();

                        List<float> pose = new List<float>();
                        face_model.GetPose(pose, reader.GetFx(), reader.GetFy(), reader.GetCx(), reader.GetCy());

                        int yaw = (int)(pose[4] * 180 / Math.PI + 0.5);
                        int yaw_abs = Math.Abs(yaw);

                        int roll = (int)(pose[5] * 180 / Math.PI + 0.5);
                        int roll_abs = Math.Abs(roll);

                        int pitch = (int)(pose[3] * 180 / Math.PI + 0.5);
                        int pitch_abs = Math.Abs(pitch);

                        YawLabel.Content = yaw_abs + "°";
                        RollLabel.Content = roll_abs + "°";
                        PitchLabel.Content = pitch_abs + "°";

                        if (yaw > 0)
                            YawLabelDir.Content = "Right";
                        else if (yaw < 0)
                            YawLabelDir.Content = "Left";
                        else
                            YawLabelDir.Content = "Straight";

                        if (pitch > 0)
                            PitchLabelDir.Content = "Down";
                        else if (pitch < 0)
                            PitchLabelDir.Content = "Up";
                        else
                            PitchLabelDir.Content = "Straight";

                        if (roll > 0)
                            RollLabelDir.Content = "Left";
                        else if (roll < 0)
                            RollLabelDir.Content = "Right";
                        else
                            RollLabelDir.Content = "Straight";

                        XPoseLabel.Content = (int)pose[0] + " mm";
                        YPoseLabel.Content = (int)pose[1] + " mm";
                        ZPoseLabel.Content = (int)pose[2] + " mm";

                        String x_angle = String.Format("{0:F0}°", gaze_angle.Item1 * (180.0 / Math.PI));
                        String y_angle = String.Format("{0:F0}°", gaze_angle.Item2 * (180.0 / Math.PI));
                        YawLabelGaze.Content = x_angle;
                        PitchLabelGaze.Content = y_angle;

                        if (gaze_angle.Item1 > 0)
                            YawLabelGazeDir.Content = "Right";
                        else if (gaze_angle.Item1 < 0)
                            YawLabelGazeDir.Content = "Left";
                        else
                            YawLabelGazeDir.Content = "Straight";

                        if (gaze_angle.Item2 > 0)
                            PitchLabelGazeDir.Content = "Down";
                        else if (gaze_angle.Item2 < 0)
                            PitchLabelGazeDir.Content = "Up";
                        else
                            PitchLabelGazeDir.Content = "Straight";

                        double confidence = face_model.GetConfidence();

                        if (confidence < 0)
                            confidence = 0;
                        else if (confidence > 1)
                            confidence = 1;

                        frame.UpdateWriteableBitmap(latest_img);
                        webcam_img.Clear();

                        webcam_img.Source = latest_img;
                        webcam_img.Confidence.Add(confidence);
                        webcam_img.FPS = processing_fps.GetFPS();
                        if(detectionSucceeding)
                        {
                            webcam_img.OverlayLines.Add(lines);
                            webcam_img.OverlayPoints.Add(landmarks);
                            webcam_img.OverlayPointsVisibility.Add(visibilities);
                            webcam_img.FaceScale.Add(scale);

                            List<System.Windows.Point> eye_landmark_points = new List<System.Windows.Point>();
                            foreach (var p in eye_landmarks)
                            {
                                eye_landmark_points.Add(new System.Windows.Point(p.Item1, p.Item2));
                            }


                            webcam_img.OverlayEyePoints.Add(eye_landmark_points);
                            webcam_img.GazeLines.Add(gaze_lines);

                            // Publish the information for other applications
                            String str_head_pose = String.Format("{0}:{1:F2}, {2:F2}, {3:F2}, {4:F2}, {5:F2}, {6:F2}", "HeadPose", pose[0], pose[1], pose[2],
                                pose[3] * 180 / Math.PI, pose[4] * 180 / Math.PI, pose[5] * 180 / Math.PI);

                            zero_mq_socket.Send(new ZFrame(str_head_pose, Encoding.UTF8));

                            String str_gaze = String.Format("{0}:{1:F2}, {2:F2}", "GazeAngle", gaze_angle.Item1 * (180.0 / Math.PI), gaze_angle.Item2 * (180.0 / Math.PI));
                            
                            zero_mq_socket.Send(new ZFrame(str_gaze, Encoding.UTF8));
                        }
                    }));

                    while (running & pause)
                    {

                        Thread.Sleep(10);
                    }

                }
                catch (TaskCanceledException)
                {
                    // Quitting
                    break;
                }
            }
            reader.Close();
            System.Console.Out.WriteLine("Thread finished");
        }

        private void startRecordingButton_Click(object sender, RoutedEventArgs e)
        {
            lock (recording_lock)
            {
                RecordingButton.IsEnabled = false;
                CompleteButton.IsEnabled = false;
                PauseButton.IsEnabled = false;

                recording_objects = new ConcurrentQueue<Tuple<RawImage, bool, List<float>>>();

                recording = true;

                new Thread(() =>
                {
                    Thread.CurrentThread.IsBackground = true;

                    // Start the recording thread
                    rec_thread = new Thread(RecordingLoop);
                    rec_thread.Start();

                    double d = seconds_to_record * 1000;

                    Stopwatch stopWatch = new Stopwatch();
                    stopWatch.Start();

                    while (d > 1000)
                    {

                        Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
                        {
                            RecordingButton.Content = ((int)(d / 1000)).ToString() + " seconds remaining";
                        }));

                        System.Threading.Thread.Sleep(1000);

                        d = seconds_to_record * 1000 - stopWatch.ElapsedMilliseconds;
                    }

                    if (d > 0)
                    {
                        System.Threading.Thread.Sleep((int)(d));
                    }

                    recording = false;

                    Dispatcher.Invoke(DispatcherPriority.Render, new TimeSpan(0, 0, 0, 0, 200), (Action)(() =>
                    {
                        RecordingButton.Content = "0 seconds remaining";
                    }));

                    Dispatcher.Invoke(() =>
                    {
                        lock (recording_lock)
                        {

                            // Wait for the recording thread to finish before enabling
                            rec_thread.Join();

                            string messageBoxText = "Was the tracking successful?";
                            string caption = "Success of tracking";
                            MessageBoxButton button = MessageBoxButton.YesNo;
                            MessageBoxImage icon = MessageBoxImage.Question;
                            MessageBoxResult result = MessageBox.Show(messageBoxText, caption, button, icon);

                            if (recording_success_file == null)
                            {
                                recording_success_file = new System.IO.StreamWriter(output_root + "/recording_success.txt", true);
                            }

                            if (result == MessageBoxResult.Yes)
                            {
                                recording_success_file.WriteLine('1');
                            }
                            else
                            {
                                recording_success_file.WriteLine('0');
                            }
                            recording_success_file.Flush();

                            trial_id++;
                            RecordingButton.Content = "Record trial: " + trial_id;
                            RecordingButton.IsEnabled = true;
                            CompleteButton.IsEnabled = true;
                            PauseButton.IsEnabled = true;

                        }

                    });
                }).Start();
            }
        }

        private void ResetButton_Click(object sender, RoutedEventArgs e)
        {
            reset = true;
        }

        private void CompleteButton_Click(object sender, RoutedEventArgs e)
        {
            StartExperiment();
        }

        private void MirrorButton_Click(object sender, RoutedEventArgs e)
        {
            mirror_image = !mirror_image;
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {

            // Let it finish recording
            recording = false;
            if (rec_thread != null)
            {
                rec_thread.Join();
            }

            // Stop capture and tracking
            running = false;
            if (processing_thread != null)
            {
                processing_thread.Join();
            }
            
        }

        private void MorrorButton_Click(object sender, RoutedEventArgs e)
        {

        }

        private void PauseButton_Click(object sender, RoutedEventArgs e)
        {
            pause = !pause;

            if (pause)
            {
                PauseButton.Content = "Resume";
            }
            else
            {
                PauseButton.Content = "Pause";
            }
        }
       
        private void ScreenshotButton_Click(object sender, RoutedEventArgs e)
        {

            PresentationSource source = PresentationSource.FromVisual(Application.Current.MainWindow);

            var topLeft = source.CompositionTarget.TransformToDevice.Transform(new System.Windows.Point(this.Left, this.Top));
            var bottomRight = source.CompositionTarget.TransformToDevice.Transform(new System.Windows.Point(this.Left + this.Width, this.Top + this.Height));

            int Width = (int)(bottomRight.X - topLeft.X);
            int Height = (int)(bottomRight.Y - topLeft.Y);

            using (Bitmap bmpScreenCapture = new Bitmap(Width,
                                                        Height))
            {
                using (System.Drawing.Graphics g = Graphics.FromImage(bmpScreenCapture))
                {
                    g.CopyFromScreen((int)(topLeft.X),
                                     (int)(topLeft.Y),
                                     0, 0,
                                     bmpScreenCapture.Size,
                                     CopyPixelOperation.SourceCopy);

                    // Write out the bitmap here encoded by a time-stamp?
                    String fname = output_root + DateTime.Now.ToString("yyyy-MMM-dd--HH-mm-ss") + ".png";
                    bmpScreenCapture.Save(fname, ImageFormat.Png);
                }
            }
        }

    }
}