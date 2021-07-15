Public Class Mugwump
    Private _x As Integer
    Private _y As Integer
    Private _found As Boolean

    Public Property x
        Get
            Return _x
        End Get
        Set(value)
            _x = value
        End Set
    End Property

    Public Property y
        Get
            Return _y
        End Get
        Set(value)
            _y = value
        End Set
    End Property

    Public Property Found
        Get
            Return _found
        End Get
        Set(value)
            _found = value
        End Set
    End Property

    Dim color As Color
    Dim eyeColor As Color
    Dim pupilColor As Color
    Dim mouthColor As Color

    Public Sub New(x As Integer, y As Integer, found As Boolean, color As Color, eyeColor As Color, pupilColor As Color, mouthColor As Color)
        Me.X = x
        Me.Y = y
        Me.Found = found
        Me.color = color
        Me.eyeColor = eyeColor
        Me.pupilColor = pupilColor
        Me.mouthColor = mouthColor
    End Sub

    Public Sub Draw(surface As Canvas, x As Integer, y As Integer, size As Integer)
        Dim centerX As Integer = x + (size / 2.0)
        Dim centerY As Integer = y + (size / 2.0)
        Dim eyeDx As Integer = (size / 4.0)
        Dim eyeDy As Integer = (size / 4.0)

        DrawUtil.Circle(surface, centerX, centerY, (size / 2), color)                               ' Body
        DrawUtil.Circle(surface, centerX - eyeDx, centerY - eyeDy, (size / 5), eyeColor)            ' Eyes
        DrawUtil.Circle(surface, centerX + eyeDx, centerY - eyeDy, (size / 5), eyeColor)
        DrawUtil.Circle(surface, centerX - eyeDx, centerY - eyeDy, (size / 10), pupilColor)         ' Pupils
        DrawUtil.Circle(surface, centerX + eyeDx, centerY - eyeDy, (size / 10), pupilColor)
        DrawUtil.Circle(surface, centerX, centerY + (eyeDy / 2), (size / 6), mouthColor)            ' Mouth
    End Sub


    Public Function IsAt(x As Integer, y As Integer) As Boolean
        Return Me.X = x And Me.Y = y
    End Function

End Class
