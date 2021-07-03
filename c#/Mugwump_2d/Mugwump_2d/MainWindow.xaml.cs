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
        readonly Mugwump_2d.Grid grid;
        public MainWindow()
        {
            InitializeComponent();
            this.Title = Settings.GAME_TITLE;
            grid = new Mugwump_2d.Grid(cnvGrid, Settings.MAX_GUESSES, Settings.FONT_SIZE_PX, Settings.INSET_1, Settings.INSET_1);
            UpdateInfo();
            cnvGrid.Focus();
        }

        private void UpdateInfo()
        {
            info.Children.Clear();
            if (grid.GuessCount == 0)
            {
                info.RowDefinitions.Clear();
                RowDefinition row = new RowDefinition
                {
                    Height = GridLength.Auto
                };
                info.RowDefinitions.Add(row);
                tbNewGame.Visibility = Visibility.Visible;
                System.Windows.Controls.Grid.SetRow(tbNewGame, 0);
                System.Windows.Controls.Grid.SetColumn(tbNewGame, 0);
                System.Windows.Controls.Grid.SetColumnSpan(tbNewGame, 3);
                info.Children.Add(tbNewGame);
            }
            else
            {
                tbNewGame.Visibility = grid.GuessCount > 0 ? Visibility.Hidden : Visibility.Visible;
                info.RowDefinitions.Clear();
                for (int i = 0; i < Settings.COUNT_MUGWUMPS; i++)
                {
                    RowDefinition rowDef = new RowDefinition
                    {
                        Height = GridLength.Auto
                    };
                    info.RowDefinitions.Add(rowDef);
                    TextBlock tbIndex = new TextBlock
                    {
                        FontSize = Settings.FONT_SIZE_PX,
                        Text = "#" + (i + 1).ToString()
                    };
                    System.Windows.Controls.Grid.SetRow(tbIndex, i);
                    System.Windows.Controls.Grid.SetColumn(tbIndex, 0);
                    info.Children.Add(tbIndex);

                    Canvas cnvIcon = new Canvas
                    {
                        MinWidth = Settings.FONT_SIZE_PX + 2,
                        MinHeight = Settings.FONT_SIZE_PX + 2
                    };
                    cnvIcon.Height = cnvIcon.Width = tbIndex.Height;
                    System.Windows.Controls.Grid.SetRow(cnvIcon, i);
                    System.Windows.Controls.Grid.SetColumn(cnvIcon, 1);
                    info.Children.Add(cnvIcon);
                    grid.Mugwumps[i].Draw(cnvIcon, 1, 1, Settings.FONT_SIZE_PX);

                    TextBlock tbDescription = new TextBlock
                    {
                        FontSize = Settings.FONT_SIZE_PX
                    };
                    if (grid.Mugwumps[i].Found)
                    {
                        tbDescription.Text = " FOUND!";
                    }
                    else
                    {
                        int guessIDX = grid.Guesses.Count - 1;
                        int x = guessIDX >= 0 ? grid.Guesses[guessIDX].X : 0;
                        int y = guessIDX >= 0 ? grid.Guesses[guessIDX].Y : 0;
                        float dx = (float)(x - grid.Mugwumps[i].X);
                        float dy = (float)(y - grid.Mugwumps[i].Y);
                        double dist = Math.Sqrt((double)(dx * dx) + (double)(dy * dy));
                        tbDescription.Text = $" is {String.Format("{0:0.00}", dist)} units away.";
                    }
                    System.Windows.Controls.Grid.SetRow(tbDescription, i);
                    System.Windows.Controls.Grid.SetColumn(tbDescription, 2);
                    info.Children.Add(tbDescription);
                }
                RowDefinition def = new RowDefinition
                {
                    Height = new GridLength(2 * Settings.FONT_SIZE_PX, GridUnitType.Pixel)
                };
                info.RowDefinitions.Add(def);
                def = new RowDefinition
                {
                    Height = GridLength.Auto
                };
                info.RowDefinitions.Add(def);
                TextBlock tbRemaining = new TextBlock
                {
                    Text = $"You have {Settings.MAX_GUESSES - grid.GuessCount} guesses remaining."
                };
                System.Windows.Controls.Grid.SetRow(tbRemaining, Settings.COUNT_MUGWUMPS + 1);
                System.Windows.Controls.Grid.SetColumn(tbRemaining, 0);
                System.Windows.Controls.Grid.SetColumnSpan(tbRemaining, 3);
                info.Children.Add(tbRemaining);


            }
            if (grid.IsGameOver())
            {
                string message;
                if (grid.IsGameWon())
                    message = "Congratulations! You Won!";
                else
                    message = "Sorry, you lost.";
                message += "\r\nWould you like to play again?";
                if (MessageBox.Show(message, Settings.GAME_TITLE,MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
                {
                    grid.NewGame(Settings.COUNT_MUGWUMPS);
                    UpdateInfo();
                }
                else
                {
                    Close();
                }
            }
            cnvGrid.Focus();
        }

        private void CnvGrid_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            grid.Draw();
        }

        private void CnvGrid_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Up || e.Key == Key.NumPad8 || e.Key == Key.W)
            {
                grid.MoveUp();
            }
            else if (e.Key == Key.Down || e.Key == Key.NumPad2 || e.Key == Key.S)
            {
                grid.MoveDown();
            }
            else if (e.Key == Key.Left || e.Key == Key.NumPad4 || e.Key == Key.A)
            {
                grid.MoveLeft();
            }
            else if (e.Key == Key.Right || e.Key == Key.NumPad6 || e.Key == Key.D)
            {
                grid.MoveRight();
            }
            else if (e.Key == Key.Enter || e.Key == Key.Return || e.Key == Key.Space)
            {
                grid.Select();
                UpdateInfo();
            }
        }

        private void CnvGrid_MouseUp(object sender, MouseButtonEventArgs e)
        {
            Point pos = e.GetPosition(cnvGrid);
            grid.Click((int)pos.X, (int)pos.Y);
            UpdateInfo();
        }

        private void CnvGrid_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            Point pos = e.GetPosition((System.Windows.IInputElement)sender);
            grid.Click((int)pos.X, (int)pos.Y);
            UpdateInfo();
        }
    }
}
