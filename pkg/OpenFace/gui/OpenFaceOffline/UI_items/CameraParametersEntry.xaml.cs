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
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace OpenFaceOffline
{
    /// <summary>
    /// Interaction logic for TextEntryWindow.xaml
    /// </summary>
    public partial class CameraParametersEntry : Window
    {
        public CameraParametersEntry(float fx, float fy, float cx, float cy)
        {
            InitializeComponent();
            this.KeyDown += new KeyEventHandler(TextEntry_KeyDown);

            if(fx == -1 || fy == -1 || cx == -1 || cy == -1)
            {
                this.fx = 500; this.fy = 500; this.cx = 320; this.cy = 240;
            }
            else
            {
                this.fx = fx; this.fy = fy; this.cx = cx; this.cy = cy;
                automaticCheckBox.IsChecked = false;
                fxTextBox.IsEnabled = true;
                fyTextBox.IsEnabled = true;
                cxTextBox.IsEnabled = true;
                cyTextBox.IsEnabled = true;
            }

            fxTextBox.Text = this.fx.ToString();
            fyTextBox.Text = this.fy.ToString();
            cxTextBox.Text = this.cx.ToString();
            cyTextBox.Text = this.cy.ToString();

            fxTextBox.TextChanged += ResponseTextBox_TextChanged;
            fyTextBox.TextChanged += ResponseTextBox_TextChanged;
            cxTextBox.TextChanged += ResponseTextBox_TextChanged;
            cyTextBox.TextChanged += ResponseTextBox_TextChanged;

        }

        private void OKButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            DialogResult = true;
        }

        private void TextEntry_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                DialogResult = true;
            }
        }

        private float fx = -1, fy = -1, cx = -1, cy = -1;

        public bool IsAutomatic
        {
            get { return automaticCheckBox.IsChecked == true; }
        }
        public float Fx
        {
            get { return automaticCheckBox.IsChecked == true ? -1 : fx; }
        }

        public float Fy
        {
            get { return automaticCheckBox.IsChecked == true ? -1 : fy; }
        }
        public float Cx
        {
            get { return automaticCheckBox.IsChecked == true ? -1 : cx; }
        }
        public float Cy
        {
            get { return automaticCheckBox.IsChecked == true ? -1 : cy; }
        }

        private void CheckBox_Click(object sender, RoutedEventArgs e)
        {
            if(automaticCheckBox.IsChecked == true)
            {
                fxTextBox.IsEnabled = false;
                fyTextBox.IsEnabled = false;
                cxTextBox.IsEnabled = false;
                cyTextBox.IsEnabled = false;
            }
            else
            {
                fxTextBox.IsEnabled = true;
                fyTextBox.IsEnabled = true;
                cxTextBox.IsEnabled = true;
                cyTextBox.IsEnabled = true;
            }
        }

        // Do not allow illegal characters like
        private void ResponseTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                float fx_n = (float)Double.Parse(fxTextBox.Text);
                float fy_n = (float)Double.Parse(fyTextBox.Text);
                float cx_n = (float)Double.Parse(cxTextBox.Text);
                float cy_n = (float)Double.Parse(cyTextBox.Text);

                if (fx_n > 0 && fy_n > 0 && cx_n > 0 && cy_n > 0)
                {
                    fx = fx_n;
                    fy = fy_n;
                    cx = cx_n;
                    cy = cy_n;
                    warningLabel.Visibility = System.Windows.Visibility.Hidden;
                }
                else
                {
                    warningLabel.Visibility = System.Windows.Visibility.Visible;

                    fxTextBox.Text = fx.ToString();
                    fyTextBox.Text = fy.ToString();
                    cxTextBox.Text = cx.ToString();
                    cyTextBox.Text = cy.ToString();

                    fxTextBox.SelectionStart = fxTextBox.Text.Length;
                    fyTextBox.SelectionStart = fyTextBox.Text.Length;
                    cxTextBox.SelectionStart = cxTextBox.Text.Length;
                    cyTextBox.SelectionStart = cyTextBox.Text.Length;

                }
            }
            catch (FormatException except)
            {
                fxTextBox.Text = fx.ToString();
                fyTextBox.Text = fy.ToString();
                cxTextBox.Text = cx.ToString();
                cyTextBox.Text = cy.ToString();

                fxTextBox.SelectionStart = fxTextBox.Text.Length;
                fyTextBox.SelectionStart = fyTextBox.Text.Length;
                cxTextBox.SelectionStart = cxTextBox.Text.Length;
                cyTextBox.SelectionStart = cyTextBox.Text.Length;

                warningLabel.Visibility = System.Windows.Visibility.Visible;
            }

        }

    }
}
