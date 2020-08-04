using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace OpenFaceDemo
{
    public class DataPointGraph
    {
        public DataPointGraph()
        {
            Time = AxesTimeSeriesPlot.CurrentTime;

        }
        public DateTime Time { get; set; }

        public Dictionary<int, double> values = new Dictionary<int, double>();

        public double Confidence { get; set; }
    }
    /// <summary>
    /// Interaction logic for AxesTimeSeriesPlot.xaml
    /// </summary>
    public partial class AxesTimeSeriesPlot : UserControl
    {

        #region High-Resolution Timing
        static DateTime startTime;
        static Stopwatch sw = new Stopwatch();

        public double MinVal { get; set; }
        public double MaxVal { get; set; }
        public int NumVertGrid { get; set; }

        public bool ShowXLabel { get; set; }
        public bool ShowYLabel { get; set; }

        public string RangeLabel { get; set; }

        public bool XTicks { get; set; }

        static AxesTimeSeriesPlot()
        {
            startTime = DateTime.Now;
            sw.Start();

        }
        public static DateTime CurrentTime
        {
            get { return startTime + sw.Elapsed; }
        }
        #endregion


        public Orientation Orientation { get; set; }

        public bool ShowLegend { get; set; }

        Queue<DataPointGraph> dataPoints = new Queue<DataPointGraph>();
        TimeSpan historyLength = TimeSpan.FromSeconds(10);
        Dictionary<int, Brush> brushes = new Dictionary<int, Brush>();
        Dictionary<int, int> brush_thicknesses = new Dictionary<int, int>();
        Dictionary<int, String> line_names = new Dictionary<int, String>();
        Dictionary<int, Color> brush_colors = new Dictionary<int, Color>();

        // Knowing where to draw things
        private double MinAxesX { get; set; }
        private double MinAxesY { get; set; }
        private double MaxAxesX { get; set; }
        private double MaxAxesY { get; set; }

        public AxesTimeSeriesPlot()
        {
            InitializeComponent();
            ShowLegend = false;
            ClipToBounds = true;
            DispatcherTimer dt = new DispatcherTimer(TimeSpan.FromMilliseconds(20), DispatcherPriority.Background, Timer_Tick, Dispatcher);

            MinVal = -1;
            MaxVal = 1;
            NumVertGrid = 5;
            ShowXLabel = true;
            ShowYLabel = true;
            XTicks = true;

        }

        private void PruneData()
        {
            lock (dataPoints)
            {
                while (dataPoints.Count > 0 && dataPoints.Peek().Time < CurrentTime - historyLength - TimeSpan.FromSeconds(2))
                    dataPoints.Dequeue();
            }
        }

        public void AddDataPoint(DataPointGraph dp)
        {
            lock (dataPoints)
                dataPoints.Enqueue(dp);
        }

        public void ClearDataPoints()
        {
            lock (dataPoints)
                dataPoints.Clear();
        }

        private void Timer_Tick(object sender, EventArgs e)
        {
            PruneData();

            if (this.IsVisible)
                InvalidateVisual();
        }

        public void AssocColor(int seriesId, Color b)
        {
            Color bTransparent = b;
            bTransparent.A = 0;

            GradientStopCollection gs = new GradientStopCollection();
            gs.Add(new GradientStop(bTransparent, 0));
            gs.Add(new GradientStop(b, 0.2));
            LinearGradientBrush g = new LinearGradientBrush(gs, new Point(0, 0), Orientation == System.Windows.Controls.Orientation.Horizontal ? new Point(ActualWidth, 0) : new Point(0, ActualHeight));
            g.MappingMode = BrushMappingMode.Absolute;
            g.Freeze();
            brushes[seriesId] = g;

            brush_colors[seriesId] = b;
        }

        public void AssocThickness(int seriesId, int thickness)
        {
            brush_thicknesses[seriesId] = thickness;
        }

        public void AssocName(int seriesId, String name)
        {
            line_names[seriesId] = name;
        }

        protected override void OnRender(DrawingContext dc)
        {
            base.OnRender(dc);

            if (Orientation == System.Windows.Controls.Orientation.Horizontal)
                RenderHorizontal(dc);
            else
                RenderVertical(dc);

        }

        // Grid rendering
        private void RenderHorizontal(DrawingContext dc)
        {
            Pen p = new Pen(Brushes.Black, 1);
            Pen q = new Pen(Brushes.LightGray, 1);

            double padLeft = Padding.Left;
            double padBottom = Padding.Bottom - 2 + 10;
            double padTop = Padding.Top;
            double padRight = Padding.Right;

            // Draw horizontal gridlines

            double step_size = (MaxVal - MinVal) / (NumVertGrid - 1.0);

            for (int i = 0; i < NumVertGrid; i++)
            {
                double y = (int)(padTop + ((NumVertGrid - 1.0) - i) * ((ActualHeight - padBottom - padTop) / (NumVertGrid - 1.0))) - 0.5;


                double y_val = MinVal + i * step_size;

                if (y_val != 0)
                    dc.DrawLine(q, new Point(padLeft, y), new Point(ActualWidth - padRight, y));
                else
                    dc.DrawLine(p, new Point(padLeft, y), new Point(ActualWidth - padRight, y));

                dc.DrawLine(p, new Point(padLeft - 10, y), new Point(padLeft, y));

                var t = FormT((MinVal + i * step_size).ToString("0.0"), 10);
                dc.DrawText(t, new Point(padLeft - t.Width - 12, y - t.Height / 2));

                if (i == 0)
                    MinAxesY = y;
                if (i == NumVertGrid - 1)
                    MaxAxesY = y;
            }

            // Draw vertical gridlines

            for (int i = 0; i < 11; i++)
            {
                double x = (int)(padLeft + (10 - i) * ((ActualWidth - padLeft - padRight) / 10.0)) - 0.5;
                if (i < 10)
                    dc.DrawLine(q, new Point(x, ActualHeight - padBottom), new Point(x, padTop));
                dc.DrawLine(p, new Point(x, ActualHeight - padBottom + 10), new Point(x, ActualHeight - padBottom));

                if (XTicks)
                {
                    var t = FormT(i.ToString(), 10);
                    dc.DrawText(t, new Point(x - t.Width / 2, ActualHeight - padBottom + t.Height));
                }
                if (i == 0)
                    MaxAxesX = x;
                if (i == (11 - 1))
                    MinAxesX = x;
            }

            // Draw y axis
            dc.DrawLine(p, new Point(((int)padLeft) - 0.5, padTop), new Point(((int)padLeft) - 0.5, ActualHeight - padBottom));
            
            //dc.DrawLine(p, new Point(MinAxesX, MinAxesY), new Point(MaxAxesX, MaxAxesY));
            //dc.DrawLine(p, new Point(MaxAxesX, padTop), new Point(MaxAxesX, ActualHeight - padBottom));

            // Draw x axis label
            if (ShowXLabel)
            {
                FormattedText ft = FormT("History (seconds)", 20);
                dc.DrawText(ft, new Point(padLeft + (ActualWidth - padLeft - padRight) / 2 - ft.Width / 2, ActualHeight - ft.Height));
            }

            // Draw y axis label
            if (ShowYLabel)
            {
                FormattedText ft = FormT(RangeLabel, 20);
                dc.PushTransform(new RotateTransform(-90));
                dc.DrawText(ft, new Point(-ft.Width - ActualHeight / 2 + ft.Width / 2, 0));
                dc.Pop();
            }

            DataPointGraph[] localPoints;
            lock (dataPoints)
                localPoints = dataPoints.ToArray();

            var pfs = new Dictionary<int, PathFigure>();
            
            for (int i = 0; i < localPoints.Length; i++)
            {
                var ptTime = localPoints[i].Time;
                var ptAge = (DateTime.Now - ptTime).TotalSeconds;

                foreach (var kvp in localPoints[i].values)
                {
                    var seriesId = kvp.Key;

                    double v = (kvp.Value - MinVal) / (MaxVal - MinVal);

                    // X starts here MinAxesX
                    // X ends here  MaxAxesX

                    double y = MinAxesY - (MinAxesY - MaxAxesY) * v;
                    double x = MaxAxesX - (CurrentTime - localPoints[i].Time).TotalMilliseconds * ((MaxAxesX-MinAxesX) / historyLength.TotalMilliseconds);

                    // Make sure everything is within bounds
                    if (x < MinAxesX)
                        continue;

                    y = Math.Min(MinAxesY, Math.Max(MaxAxesY, y));
                    
                    if (!pfs.ContainsKey(seriesId))
                    {
                        pfs[seriesId] = new PathFigure();
                        pfs[seriesId].IsClosed = false;
                        pfs[seriesId].StartPoint = new Point(x, y);
                    }
                    else
                    {
                        pfs[seriesId].Segments.Add(new LineSegment(new Point(x, y), true));
                    }
                }
            }


            foreach (var kvp in pfs)
            {
                var seriesId = kvp.Key;
                var pf = kvp.Value;

                Brush b = brushes.ContainsKey(seriesId) ? brushes[seriesId] : Brushes.Black;

                int thickness = brush_thicknesses.ContainsKey(seriesId) ? brush_thicknesses[seriesId] : 2;

                PathGeometry pg = new PathGeometry(new PathFigure[] { pf });

                Pen p2 = new Pen(b, thickness);
                
                dc.DrawGeometry(null, p2, pg);
            }

            if (ShowLegend && line_names.Count > 0)
            {
                int height_one = 18;
                int height = height_one * line_names.Count;

                Pen p2 = new Pen(Brushes.Black, 1);
                Brush legend_b = new SolidColorBrush(Color.FromRgb(255, 255, 255));

                dc.DrawRectangle(legend_b, p2, new Rect(MinAxesX, MaxAxesY, 100, height));

                int i = 0;
                foreach (var key_name_pair in line_names)
                {
                    var line_name = key_name_pair.Value;
                    FormattedText ft = FormT(line_name, 11);

                    // Draw the text
                    dc.DrawText(ft, new Point(MinAxesX + 15, MaxAxesY + 1 + height_one * i));
                    // Draw example lines

                    Brush legend_c = new SolidColorBrush(brush_colors[key_name_pair.Key]);
                    Pen p_line = new Pen(legend_c, brush_thicknesses[key_name_pair.Key]);
                    dc.DrawLine(p_line, new Point(MinAxesX, MaxAxesY + height_one * i - 1 + height_one / 2), new Point(MinAxesX + 14, MaxAxesY -1 + height_one * i + height_one / 2));
                    i++;
                }
            }

        }

        private void RenderVertical(DrawingContext dc)
        {
            Pen p = new Pen(Brushes.Black, 1);
            Pen q = new Pen(Brushes.LightGray, 1);

            double padLeft = Padding.Left;
            double padBottom = Padding.Bottom - 2 + 10;
            double padTop = Padding.Top;
            double padRight = Padding.Right;

            // Draw horizontal gridlines

            for (int i = 0; i < 11; i++)
            {
                double y = (int)(padTop + (10 - i) * ((ActualHeight - padBottom - padTop) / 10.0)) - 0.5;
                if (i > 0)
                    dc.DrawLine(q, new Point(padLeft, y), new Point(ActualWidth - padRight, y));
                dc.DrawLine(p, new Point(padLeft - 10, y), new Point(padLeft, y));
                var t = FormT(i.ToString(), 10);
                dc.DrawText(t, new Point(padLeft - t.Width - 12, y - t.Height / 2));
            }

            // Draw vertical gridlines

            for (int i = 0; i < 5; i++)
            {
                double x = (int)(padLeft + (4 - i) * ((ActualWidth - padLeft - padRight) / 4.0)) - 0.5;
                if (i < 10)
                    dc.DrawLine(q, new Point(x, ActualHeight - padBottom), new Point(x, padTop));
                dc.DrawLine(p, new Point(x, ActualHeight - padBottom + 10), new Point(x, ActualHeight - padBottom));

                var t = FormT(((4 - i) / 2.0 - 1).ToString("0.0"), 10);
                dc.DrawText(t, new Point(x - t.Width / 2, ActualHeight - padBottom + t.Height));
            }

            // Draw y axis

            dc.DrawLine(p, new Point(((int)((ActualWidth - padRight - padLeft) / 2 + padLeft)) - 0.5, padTop), new Point(((int)((ActualWidth - padRight - padLeft) / 2 + padLeft)) - 0.5, ActualHeight - padBottom));

            // Draw x axis
            dc.DrawLine(p, new Point(padLeft, ((int)((ActualHeight - padBottom))) - 0.5), new Point(ActualWidth - padRight, ((int)((ActualHeight - padBottom))) - 0.5));

            // Draw x axis label

            FormattedText ft = FormT(RangeLabel, 20);
            dc.DrawText(ft, new Point(padLeft + (ActualWidth - padLeft - padRight) / 2 - ft.Width / 2, ActualHeight - ft.Height));

            // Draw y axis label

            ft = FormT("History (seconds)", 20);
            dc.PushTransform(new RotateTransform(-90));
            dc.DrawText(ft, new Point(-ft.Width - ActualHeight / 2 + ft.Width / 2, 0));
        }

        private FormattedText FormT(string text, int size)
        {
            return new FormattedText(text, CultureInfo.CurrentCulture, System.Windows.FlowDirection.LeftToRight, new Typeface("Verdana"), size, Brushes.Black);
        }


    }

}
