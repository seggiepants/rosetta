Public Class Grid

	Dim surface As Canvas
	Dim body_colors As List(Of System.Windows.Media.Color)
	Dim borderWidth As Integer
	Dim borderHeight As Integer
	Dim cellH As Integer
	Dim cellW As Integer
	Dim _guesses As New List(Of Point)
	Dim height As Integer
	Dim maxGuesses As Integer
	Dim _mugwumps As List(Of Mugwump)
	Dim textSize As Integer
	Dim width As Integer
	Dim pos As Point
	Dim x As Integer
	Dim y As Integer

	Public Sub New(app As Canvas, maxGuesses As Integer, textSize As Integer, borderWidth As Integer, borderHeight As Integer)
		Dim h_ticks As List(Of TextBlock)
		Dim v_ticks As List(Of TextBlock)

		body_colors = New List(Of System.Windows.Media.Color)({PINK,
															  VIOLET,
															  LIGHT_BLUE,
															  ORANGE})
		surface = app
		width = surface.ActualWidth
		height = surface.ActualHeight
		Me.textSize = textSize
		Me.borderWidth = borderWidth
		Me.borderHeight = borderHeight
		Me.maxGuesses = maxGuesses
		_mugwumps = New List(Of Mugwump)
		_guesses = New List(Of Point)
		h_ticks = New List(Of TextBlock)
		v_ticks = New List(Of TextBlock)
		Dim tick_width As Integer = 0
		Dim tick_height As Integer = 0
		For i As Integer = 0 To GRID_W - 1
			Dim t As New TextBlock With
				{
					.Text = i.ToString(),
					.FontSize = Me.textSize
				}
			tick_width = Math.Max(tick_width, t.ActualWidth)
			h_ticks.Add(t)
			surface.Children.Add(t)
		Next i
		For i As Integer = 0 To GRID_H - 1
			Dim t As New TextBlock With
				{
					.Text = i.ToString(),
					.FontSize = Me.textSize
				}
			tick_height = Math.Max(tick_height, t.ActualHeight)
			v_ticks.Add(t)
			surface.Children.Add(t)
		Next i

		cellW = (width - (Me.borderWidth * 3) - tick_width) / GRID_W
		cellH = (height - (Me.borderHeight * 3) - tick_height) / GRID_H
		cellW = cellH = Math.Min(cellW, cellH)

		NewGame(COUNT_MUGWUMPS)
	End Sub

	Public Sub Draw()
		surface.Children.Clear()
		Dim h_ticks As New List(Of TextBlock)
		Dim v_ticks As New List(Of TextBlock)

		width = surface.ActualWidth
		height = surface.ActualHeight
		If (width <= 0 Or height <= 0) Then
			Exit Sub
		End If

		Dim tick_width As Integer = 0
		Dim tick_height As Integer = 0

		For i As Integer = 0 To GRID_W - 1
			Dim t As New TextBlock With
			{
				.Text = i.ToString(),
				.FontSize = textSize
			}
			t.Measure(New System.Windows.Size(Double.PositiveInfinity, Double.PositiveInfinity))
			tick_width = Math.Max(tick_width, t.DesiredSize.Width)
			h_ticks.Add(t)
		Next i

		For i As Integer = 0 To GRID_H
			Dim t As New TextBlock With
				{
					.Text = i.ToString(),
					.FontSize = textSize
				}
			t.Measure(New System.Windows.Size(Double.PositiveInfinity, Double.PositiveInfinity))
			tick_height = Math.Max(tick_height, t.DesiredSize.Height)
			v_ticks.Add(t)
		Next i

		cellW = (width - (borderWidth * 3) - tick_width) / GRID_W
		cellH = (height - (borderHeight * 3) - tick_height) / GRID_H
		cellW = Math.Min(cellW, cellH)
		cellH = cellW

		Dim x As Integer = (width - tick_width - (borderWidth * 3) - (cellW * GRID_W)) / 2
		Dim y As Integer = (height - tick_height - (borderHeight * 3) - (cellH * GRID_H)) / 2
		Me.x = x
		Me.y = y

		' Won't get a click event for any part of the canvas you haven't drawn on, so fill the background with window background color.
		Rectangle(surface, Me.x, Me.y, cellW * GRID_W, cellH * GRID_H, SystemColors.WindowColor)

		For i As Integer = 0 To GRID_H
			Dim Line As New Line() With
				{
					.X1 = x,
					.X2 = x + (cellW * GRID_W),
					.Y1 = y + (cellH * i),
					.Y2 = y + (cellH * i),
					.Stroke = CreateBrush(SystemColors.WindowTextColor)
				}
			surface.Children.Add(Line)
			If (i < GRID_H) Then
				' Move tick to x - tick_height - me.border_width, y + (Settings.GRID_H - i) * me.cellH) - (me.cellH / 2)
				v_ticks(i).Foreground = CreateBrush(SystemColors.WindowTextColor)
				Canvas.SetLeft(v_ticks(i), x - tick_width - (borderWidth * 2))
				Canvas.SetTop(v_ticks(i), y + ((GRID_H - i) * cellH) - (cellH / 2) - borderWidth)
				surface.Children.Add(v_ticks(i))
			End If
		Next i

		For i As Integer = 0 To GRID_W
			Dim Line As New Line With
				{
					.X1 = x + (cellW * i),
					.X2 = x + (cellW * i),
					.Y1 = y,
					.Y2 = y + (cellH * GRID_H),
					.Stroke = CreateBrush(SystemColors.WindowTextColor)
				}
			surface.Children.Add(Line)
			If (i < GRID_W) Then
				' Move tick to x + (me.cellW / 2) + (i * me.cellW) - (tick_width / 2), y + (Settings.GRID_H - i) * me.cellH) + (me.borderWidth)
				h_ticks(i).Foreground = CreateBrush(SystemColors.WindowTextColor)
				Canvas.SetLeft(h_ticks(i), x + (cellW / 2) + (i * cellW) - (tick_width / 2))
				Canvas.SetTop(h_ticks(i), y + (GRID_H * cellH) + borderWidth)
				surface.Children.Add(h_ticks(i))
			End If
		Next i

		If (pos.X >= 0 And pos.X < GRID_W And pos.Y >= 0 And pos.Y < GRID_H) Then
			Rectangle(surface, x + (cellW * pos.X) + INSET_1, y + (cellH * pos.Y) + INSET_1, cellW - (2 * INSET_1), cellH - (2 * INSET_1), TEAL)
		End If
		For Each guess As Point In _guesses
			Rectangle(surface, x + (cellW * guess.X) + INSET_2, y + (cellH * guess.Y) + INSET_2, cellW - (2 * INSET_2), cellH - (2 * INSET_2), RED)
		Next guess

		For Each mugwump As Mugwump In _mugwumps
			If (mugwump.Found) Then
				mugwump.Draw(surface, x + (cellW * mugwump.x) + 1, y + (cellH * mugwump.y) + 1, cellW - 2)
			End If
		Next mugwump

		' Mugwump test = New Mugwump(1, 1, True, Settings.VIOLET, Settings.WHITE, Settings.RED, Settings.BLACK)
		' test.Draw(Me.surface, 100, 100, 100)
	End Sub


	Protected Overrides Sub Finalize()

		If (Mugwumps.Count > 0) Then
			_mugwumps.Clear()
		End If

		If (_guesses.Count > 0) Then

			Guesses.Clear()
		End If
	End Sub

	Public Sub Click(x As Integer, y As Integer)
		Dim gridX As Integer = x - Me.x
		Dim gridY As Integer = y - Me.y
		Dim isGridLine As Boolean = ((gridX Mod cellW = 0) Or (gridY Mod cellH = 0))
		If (Not isGridLine And gridX > 0 And gridX < cellW * GRID_W And gridY > 0 And gridY < cellH * GRID_H) Then
			Dim px As Integer = (Math.Floor(gridX / cellW))
			Dim py As Integer = (Math.Floor(gridY / cellH))
			pos.X = px
			pos.Y = py
			Select_Cell()
		End If
	End Sub

	Public ReadOnly Property GuessCount As Integer
		Get
			Return _guesses.Count
		End Get
	End Property

	Private ReadOnly Property MugwumpsFound As Integer
		Get
			Dim countFound As Integer = 0
			For Each mugwump As Mugwump In _mugwumps
				If (mugwump.Found) Then
					countFound = countFound + 1
				End If
			Next mugwump
			Return countFound
		End Get
	End Property

	Public ReadOnly Property Guesses As List(Of Point)
		Get
			Return _guesses
		End Get
	End Property

	Public ReadOnly Property Mugwumps As List(Of Mugwump)
		Get
			Return _mugwumps
		End Get
	End Property

	Private Function FindMugwumpAt(x As Integer, y As Integer) As Integer
		For i As Integer = 0 To _mugwumps.Count - 1
			If (Mugwumps(i).IsAt(x, y)) Then
				Return i
			End If
		Next i
		Return -1
	End Function

	Public Function IsGameOver() As Boolean
		Dim found As Integer = MugwumpsFound
		Return (Guesses.Count >= maxGuesses) Or (found = _mugwumps.Count)
	End Function

	Public Function IsGameWon() As Boolean
		Dim mugwumpsFound As Integer = Me.MugwumpsFound
		Return (Guesses.Count <= maxGuesses) And (mugwumpsFound = _mugwumps.Count)
	End Function

	Public Function IsGuessOK(x As Integer, y As Integer) As Boolean
		Dim matchFound As Boolean = False
		For Each guess As Point In Guesses
			If (guess.X = x And guess.Y = y) Then
				matchFound = True
				Exit For
			End If
		Next guess
		Return Not matchFound
	End Function

	Public Sub MoveDown()
		pos.Y = Math.Min(GRID_H - 1, pos.Y + 1)
		Draw()
	End Sub

	Public Sub MoveLeft()
		pos.X = Math.Max(0, pos.X - 1)
		Draw()
	End Sub

	Public Sub MoveRight()
		pos.X = Math.Min(GRID_W - 1, pos.X + 1)
		Draw()
	End Sub

	Public Sub MoveUp()
		pos.Y = Math.Max(0, pos.Y - 1)
		Draw()
	End Sub

	Public Sub NewGame(numMugwumps As Integer)
		Dim rnd As New Random()
		Guesses.Clear()
		_mugwumps.Clear()
		pos.X = (GRID_W / 2)
		pos.Y = (GRID_H / 2)

		For i As Integer = 0 To numMugwumps - 1
			Dim positionOK As Boolean = False
			Dim x As Integer = 0
			Dim y As Integer = 0
			Dim color As System.Windows.Media.Color

			While (Not positionOK)
				x = rnd.Next(0, GRID_W)
				y = rnd.Next(0, GRID_H)
				color = body_colors(i Mod body_colors.Count)
				Dim mugwumpIDX As Integer = FindMugwumpAt(x, y)
				positionOK = (mugwumpIDX < 0)
			End While
			Mugwumps.Add(New Mugwump(x, y, False, color, WHITE, BLACK, BLACK))
		Next i
		pos.X = (GRID_W / 2)
		pos.Y = (GRID_H / 2)
		Draw()
	End Sub

	Public Sub Select_Cell()
		If (IsGuessOK(pos.X, pos.Y)) Then
			Guesses.Add(New Point(pos.X, pos.Y))
			Dim mugwumpIDX As Integer = FindMugwumpAt(pos.X, pos.Y)
			If (mugwumpIDX >= 0) Then
				_mugwumps(mugwumpIDX).Found = True
			End If
			Draw()
		End If
	End Sub

End Class
