Module DrawUtil
    Public Sub Circle(canvas As Canvas, x As Integer, y As Integer, radius As Integer, color As Color)
        If (radius <= 0) Then
            Return
        End If
        Dim Circle As Ellipse = New Ellipse With
            {
                .Fill = CreateBrush(color),
                .Width = radius * 2,
                .Height = radius * 2
            }
        Canvas.SetLeft(Circle, x - radius)
        Canvas.SetTop(Circle, y - radius)
        canvas.Children.Add(Circle)
    End Sub

    Public Sub Circle(canvas As Canvas, x As Integer, y As Integer, radius As Integer, color As System.Drawing.Color)
        Circle(canvas, x, y, radius, AdaptColor(color))
    End Sub

    Public Sub Rectangle(canvas As Canvas, x As Integer, y As Integer, w As Integer, h As Integer, color As Color)
        If (w <= 0 Or h <= 0) Then
            Return
        End If
        Dim Rect As Rectangle = New Rectangle() With
            {
                .Fill = CreateBrush(color),
                .Width = w,
                .Height = h
            }
            Canvas.SetLeft(Rect, x)
            Canvas.SetTop(Rect, y)
            canvas.Children.Add(Rect)
        End Sub

    Public Sub Rectangle(canvas As Canvas, x As Integer, y As Integer, w As Integer, h As Integer, color As System.Drawing.Color)
        Rectangle(canvas, x, y, w, h, AdaptColor(color))
    End Sub

    Private Function AdaptColor(color As System.Drawing.Color) As System.Windows.Media.Color
        Return System.Windows.Media.Color.FromArgb(color.A, color.R, color.G, color.B)
    End Function

    Public Function CreateBrush(clr As System.Drawing.Color) As SolidColorBrush
        Return New SolidColorBrush(AdaptColor(clr))
    End Function

    Public Function CreateBrush(clr As System.Windows.Media.Color) As SolidColorBrush
        Return New SolidColorBrush(clr)
    End Function
End Module
