Class MainWindow
    Dim gameGrid As Grid
    Private root As MainWindow
    Public Sub New()
        InitializeComponent()
        root = TryCast(Application.Current.MainWindow, MainWindow)
        Me.Title = Settings.GAME_TITLE
        Me.gameGrid = New Grid(cnvGrid, Settings.MAX_GUESSES, Settings.FONT_SIZE_PX, Settings.INSET_1, Settings.INSET_1)
        UpdateInfo()
        cnvGrid.Focus()
    End Sub

    Private Sub UpdateInfo()
        info.Children.Clear()
        If (gameGrid.GuessCount = 0) Then
            info.RowDefinitions.Clear()
            Dim row As RowDefinition = New RowDefinition() With
                {
                    .Height = GridLength.Auto
                }
            info.RowDefinitions.Add(row)
            tbNewGame.Visibility = Visibility.Visible
            System.Windows.Controls.Grid.SetRow(tbNewGame, 0)
            System.Windows.Controls.Grid.SetColumn(tbNewGame, 0)
            System.Windows.Controls.Grid.SetColumnSpan(tbNewGame, 3)
            info.Children.Add(tbNewGame)
        Else
            If (gameGrid.GuessCount > 0) Then
                tbNewGame.Visibility = Visibility.Hidden
            Else
                tbNewGame.Visibility = Visibility.Visible
            End If
            info.RowDefinitions.Clear()
            For i As Integer = 0 To Settings.COUNT_MUGWUMPS - 1
                Dim rowDef As RowDefinition = New RowDefinition() With
                    {
                        .Height = GridLength.Auto
                    }
                info.RowDefinitions.Add(rowDef)
                Dim tbIndex As TextBlock = New TextBlock() With
                    {
                        .FontSize = Settings.FONT_SIZE_PX,
                        .Text = "#" + (i + 1).ToString()
                    }
                System.Windows.Controls.Grid.SetRow(tbIndex, i)
                System.Windows.Controls.Grid.SetColumn(tbIndex, 0)
                info.Children.Add(tbIndex)

                Dim cnvIcon As Canvas = New Canvas() With
                    {
                        .MinWidth = Settings.FONT_SIZE_PX + 2,
                        .MinHeight = Settings.FONT_SIZE_PX + 2
                    }
                cnvIcon.Height = cnvIcon.Width = tbIndex.Height
                System.Windows.Controls.Grid.SetRow(cnvIcon, i)
                System.Windows.Controls.Grid.SetColumn(cnvIcon, 1)
                info.Children.Add(cnvIcon)
                gameGrid.Mugwumps(i).Draw(cnvIcon, 1, 1, Settings.FONT_SIZE_PX)

                Dim tbDescription As TextBlock = New TextBlock() With
                    {
                        .FontSize = Settings.FONT_SIZE_PX
                    }
                If (gameGrid.Mugwumps(i).Found) Then
                    tbDescription.Text = " FOUND!"
                Else
                    Dim guessIDX As Integer = gameGrid.Guesses.Count - 1
                    Dim x As Integer
                    If guessIDX >= 0 Then
                        x = gameGrid.Guesses(guessIDX).X
                    Else
                        x = 0
                    End If
                    Dim y As Integer
                    If (guessIDX >= 0) Then
                        y = gameGrid.Guesses(guessIDX).Y
                    Else
                        y = 0
                    End If
                    Dim dx As Single = (x - gameGrid.Mugwumps(i).x)
                    Dim dy As Single = (y - gameGrid.Mugwumps(i).y)
                    Dim dist As Double = Math.Sqrt((dx * dx) + (dy * dy))
                    tbDescription.Text = $" is {String.Format("{0:0.00}", dist)} units away."
                End If

                System.Windows.Controls.Grid.SetRow(tbDescription, i)
                System.Windows.Controls.Grid.SetColumn(tbDescription, 2)
                info.Children.Add(tbDescription)
            Next i

            Dim def As New RowDefinition() With
                {
                    .Height = New GridLength(2 * Settings.FONT_SIZE_PX, GridUnitType.Pixel)
                }
            info.RowDefinitions.Add(def)
            def = New RowDefinition() With
                {
                    .Height = GridLength.Auto
                }
            info.RowDefinitions.Add(def)
            Dim tbRemaining As New TextBlock() With
                {
                    .Text = $"You have {Settings.MAX_GUESSES - gameGrid.GuessCount} guesses remaining."
                }
            System.Windows.Controls.Grid.SetRow(tbRemaining, Settings.COUNT_MUGWUMPS + 1)
            System.Windows.Controls.Grid.SetColumn(tbRemaining, 0)
            System.Windows.Controls.Grid.SetColumnSpan(tbRemaining, 3)
            info.Children.Add(tbRemaining)
        End If

        If (gameGrid.IsGameOver()) Then
            Dim message As String
            If (gameGrid.IsGameWon()) Then
                message = "Congratulations! You Won!"
            Else
                message = "Sorry, you lost."
            End If
            message += vbCrLf + "Would you like to play again?"
            If (MessageBox.Show(message, Settings.GAME_TITLE, MessageBoxButton.YesNo, MessageBoxImage.Question) = MessageBoxResult.Yes) Then
                gameGrid.NewGame(Settings.COUNT_MUGWUMPS)
                UpdateInfo()
            Else
                Close()
            End If
        End If
        cnvGrid.Focus()
    End Sub

    Private Sub CnvGrid_SizeChanged(sender As Object, e As SizeChangedEventArgs)
        gameGrid.Draw()
    End Sub

    Private Sub CnvGrid_KeyUp(sender As Object, e As KeyEventArgs)
        If (e.Key = Key.Up Or e.Key = Key.NumPad8 Or e.Key = Key.W) Then
            gameGrid.MoveUp()
        ElseIf (e.Key = Key.Down Or e.Key = Key.NumPad2 Or e.Key = Key.S) Then
            gameGrid.MoveDown()
        ElseIf (e.Key = Key.Left Or e.Key = Key.NumPad4 Or e.Key = Key.A) Then
            gameGrid.MoveLeft()
        ElseIf (e.Key = Key.Right Or e.Key = Key.NumPad6 Or e.Key = Key.D) Then
            gameGrid.MoveRight()
        ElseIf (e.Key = Key.Enter Or e.Key = Key.Return Or e.Key = Key.Space) Then
            gameGrid.Select_Cell()
            UpdateInfo()
        End If
    End Sub

    Private Sub CnvGrid_MouseUp(sender As Object, e As MouseButtonEventArgs)

        Dim pos As Point = e.GetPosition(cnvGrid)
        gameGrid.Click(pos.X, pos.Y)
        UpdateInfo()
    End Sub

    Private Sub CnvGrid_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs)
        Dim pos As Point = e.GetPosition(sender)
        gameGrid.Click(pos.X, pos.Y)
        UpdateInfo()
    End Sub
End Class
