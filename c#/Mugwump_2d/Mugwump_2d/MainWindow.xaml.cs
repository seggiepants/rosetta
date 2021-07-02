using System;
using System.Collections.Generic;
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

namespace Mugwump_2d
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        Mugwump_2d.Grid grid;
        public MainWindow()
        {
            InitializeComponent();
            this.grid = new Mugwump_2d.Grid(cnvGrid, Settings.MAX_GUESSES, Settings.FONT_SIZE_PX, Settings.INSET_1, Settings.INSET_1);
            UpdateInfo();
            this.cnvGrid.Focus();
        }

        private void UpdateInfo()
        {
            info.Children.Clear();
            if (this.grid.GuessCount == 0)
            {
                this.info.RowDefinitions.Clear();
                RowDefinition row = new RowDefinition();
                row.Height = GridLength.Auto;
                this.info.RowDefinitions.Add(row);
                this.tbNewGame.Visibility = Visibility.Visible;
                System.Windows.Controls.Grid.SetRow(tbNewGame, 0);
                System.Windows.Controls.Grid.SetColumn(tbNewGame, 0);
                System.Windows.Controls.Grid.SetColumnSpan(tbNewGame, 3);
                info.Children.Add(tbNewGame);
            }
            else
            {
                this.tbNewGame.Visibility = this.grid.GuessCount > 0 ? Visibility.Hidden : Visibility.Visible;
                this.info.RowDefinitions.Clear();
                for (int i = 0; i < Settings.COUNT_MUGWUMPS; i++)
                {
                    RowDefinition rowDef = new RowDefinition();
                    rowDef.Height = GridLength.Auto;
                    this.info.RowDefinitions.Add(rowDef);
                    TextBlock tbIndex = new TextBlock();
                    tbIndex.FontSize = Settings.FONT_SIZE_PX;
                    tbIndex.Text = "#" + (i + 1).ToString();
                    System.Windows.Controls.Grid.SetRow(tbIndex, i);
                    System.Windows.Controls.Grid.SetColumn(tbIndex, 0);
                    info.Children.Add(tbIndex);

                    Canvas cnvIcon = new Canvas();
                    cnvIcon.MinWidth = Settings.FONT_SIZE_PX + 2;
                    cnvIcon.MinHeight = Settings.FONT_SIZE_PX + 2;
                    cnvIcon.Height = cnvIcon.Width = tbIndex.Height;
                    System.Windows.Controls.Grid.SetRow(cnvIcon, i);
                    System.Windows.Controls.Grid.SetColumn(cnvIcon, 1);
                    info.Children.Add(cnvIcon);
                    this.grid.Mugwumps[i].Draw(cnvIcon, 1, 1, Settings.FONT_SIZE_PX);
                    
                    TextBlock tbDescription = new TextBlock();
                    tbDescription.FontSize = Settings.FONT_SIZE_PX;
                    if (this.grid.Mugwumps[i].found)
                    {
                        tbDescription.Text = " FOUND!";
                    }
                    else
                    {
                        int guessIDX = this.grid.Guesses.Count - 1;
                        int x = guessIDX >= 0 ? this.grid.Guesses[guessIDX].X : 0;
                        int y = guessIDX >= 0 ? this.grid.Guesses[guessIDX].Y : 0;
                        float dx = (float)(x - this.grid.Mugwumps[i].x);
                        float dy = (float)(y - this.grid.Mugwumps[i].y);
                        double dist = Math.Sqrt((double)(dx * dx) + (double)(dy * dy));
                        tbDescription.Text = $" is {String.Format("{0:0.00}", dist)} units away.";
                    }
                    System.Windows.Controls.Grid.SetRow(tbDescription, i);
                    System.Windows.Controls.Grid.SetColumn(tbDescription, 2);
                    info.Children.Add(tbDescription);
                }
                RowDefinition def = new RowDefinition();
                def.Height = new GridLength(2 * Settings.FONT_SIZE_PX, GridUnitType.Pixel);
                info.RowDefinitions.Add(def);
                def = new RowDefinition();
                def.Height = GridLength.Auto;
                info.RowDefinitions.Add(def);
                TextBlock tbRemaining = new TextBlock();
                tbRemaining.Text = $"You have {Settings.MAX_GUESSES - this.grid.GuessCount} guesses remaining.";
                System.Windows.Controls.Grid.SetRow(tbRemaining, Settings.COUNT_MUGWUMPS + 1);
                System.Windows.Controls.Grid.SetColumn(tbRemaining, 0);
                System.Windows.Controls.Grid.SetColumnSpan(tbRemaining, 3);
                info.Children.Add(tbRemaining);


            }
            cnvGrid.Focus();
        }

        private void cnvGrid_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            this.grid.Draw();
        }

        private void cnvGrid_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Up || e.Key == Key.NumPad8 || e.Key == Key.W)
            {
                this.grid.MoveUp();
            }
            else if (e.Key == Key.Down || e.Key == Key.NumPad2 || e.Key == Key.S)
            {
                this.grid.MoveDown();
            }
            else if (e.Key == Key.Left || e.Key == Key.NumPad4 || e.Key == Key.A)
            {
                this.grid.MoveLeft();
            }
            else if (e.Key == Key.Right || e.Key == Key.NumPad6 || e.Key == Key.D)
            {
                this.grid.MoveRight();
            }
            else if (e.Key == Key.Enter || e.Key == Key.Return || e.Key == Key.Space)
            {
                this.grid.Select();
                UpdateInfo();
            }
        }
    }
}
