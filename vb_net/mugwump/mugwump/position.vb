Imports System

Public Class position
    Dim _x As Integer
    Dim _y As Integer
    Dim _found As Boolean

    Public Sub New()
        _x = 0
        _y = 0
        _found = False
    End Sub

    Public Sub RandomPosition(random As Random, Width As Integer, Height As Integer)
        _x = random.Next(0, Width - 1)
        _y = random.Next(0, Height - 1)
        _found = False
    End Sub

    Public ReadOnly Property x() As Integer
        Get
            Return _x
        End Get
    End Property

    Public ReadOnly Property y() As Integer
        Get
            Return _y
        End Get
    End Property

    Public Property found() As Boolean
        Get
            Return _found
        End Get
        Set(value As Boolean)
            _found = value
        End Set
    End Property

End Class
