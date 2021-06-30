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
        }

        private void cnvGrid_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            this.grid.Draw();
        }
    }
}
