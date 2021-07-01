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
            this.cnvGrid.Focus();
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
            }
        }
    }
}
