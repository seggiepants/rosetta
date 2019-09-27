Option Strict On

Imports System

Module mugwump

    '  MUGWUMP
    ' =======
    ' CREATIVE COMPUTING  MORRISTOWN, New JERSEY
    ' Courtesy People's Computer Company
    ' 
    ' Adapted by SeggiePants from the book "BASIC COMPUTER GAMES" Edited by David H. Ahl
    ' 
    ' Can be found online at:  https://www.atariarchives.org/basicgames/showpage.php?page=114

    ' Global Constants
    Const NUM_MUGWUMPS As Integer = 4
    Const GRID_W As Integer = 10
    Const GRID_H As Integer = GRID_W

    Dim Pos(NUM_MUGWUMPS - 1) As position 'Looks like Dim goes from 0 to NUM not 0 to NUM - 1 so subtract one.

    Sub Main(args As String())
        Dim delim() As Char = {","c}
        Dim distance As Double
        Dim i As Integer
        Dim items() As String
        Dim line As String
        Dim playAgain As String
        Dim remaining As Integer
        Dim turn As Integer
        Dim x As Integer
        Dim y As Integer

        For i = 0 To Pos.Length - 1
            Pos(i) = New position()
        Next

        ' Show the introductory text.
        PrintIntroduction()

        While True 'Loop for each game run
            ' Position the MugWumps
            InitMugwumps()
            turn = 1 ' First turn

            While True  'Single Game loop
                Console.WriteLine("")
                Console.WriteLine("")

                ' Get coordinates from the user.
                Do
                    Console.Write(String.Format("Turn No. {0} what is your guess? ", turn))
                    ' Input locations
                    line = Console.ReadLine()
                    items = line.Split(delim)
                    If items.Length >= 2 Then
                        If Not Integer.TryParse(items(0), x) Then
                            x = -1
                        End If

                        If Not Integer.TryParse(items(1), y) Then
                            y = -1
                        End If
                    End If

                Loop Until x >= 0 And x < GRID_W And y >= 0 And y < GRID_H

                ' Check to see if you found a mugwump, report how far away you are otherwise.
                For i = 0 To Pos.Length - 1
                    If Not Pos(i).found Then
                        If Pos(i).x <> x Or Pos(i).y <> y Then
                            distance = Math.Sqrt((Pos(i).x - x) ^ 2 + (Pos(i).y - y) ^ 2)
                            Console.WriteLine("You are {0} units from Mugwump {1}", distance.ToString("0.##"), i + 1, x, y)
                        Else
                            Pos(i).found = True
                            Console.WriteLine(String.Format("YOU HAVE FOUND MUGWUMP {0}", i + 1))
                        End If
                    End If
                Next i

                ' Increment turn And find how many mugwumps remaining.
                turn = turn + 1
                remaining = 0
                For Each mugwump As position  In Pos
                    If Not mugwump.found Then
                        remaining = remaining + 1
                    End If
                Next

                If remaining = 0 Then
                    ' Win State
                    Console.WriteLine()
                    Console.WriteLine(String.Format("YOU GOT THEM ALL IN {0} TURNS!", turn))
                    Exit While
                ElseIf turn >= 10 Then
                    ' Lose State
                    Console.WriteLine()
                    PrettyPrint("SORRY, THAT'S 10 TRIES, HERE is WHERE THEY'RE HIDING")
                    Console.WriteLine()
                    For Each mugwump As position In Pos
                        If mugwump.found = False Then
                            Console.WriteLine(String.Format("MUGWUMP {0} IS AT ({1}, {2})", i + 1, mugwump.x, mugwump.y))
                        End If
                    Next
                    Exit While
                End If
            End While

            ' Would you Like to play again.
            Console.WriteLine()
            Console.WriteLine("THAT WAS FUN!")
            ' Loop until you get Y Or N
            Do
                Console.Write("Would you like to play again? (Y/N) ")
                playAgain = Console.ReadLine().Trim().ToUpper()(0)
            Loop Until playAgain = "Y" Or playAgain = "N"

            ' Break out if you don't want to play anymore.
            If playAgain = "N" Then
                Exit While
            End If

            ' Prepare to restart the game.
            Console.WriteLine("FOUR MORE MUGWUMPS ARE NOW IN HIDING.")
        End While
    End Sub

    ''' <summary>
    ''' Print MESSAGE$ centered on the display.
    ''' </summary>
    ''' <param name="message">The value to print centered on the display.</param>
    ''' 
    Sub CenterPrint(message As String)
        Console.CursorLeft = Math.Max(0, (Console.WindowWidth - message.Length) \ 2)
        Console.WriteLine(message)
    End Sub

    ''' <summary>
    ''' Initialize the position of the MUGWUMPS
    ''' </summary>
    Sub InitMugwumps()
        Dim r As New Random()

        For Each mugwump As position In Pos
            mugwump.RandomPosition(r, GRID_W, GRID_H)
        Next

    End Sub

    ''' <summary>
    ''' Print out a message in a pretty way by splitting characters on word
    ''' boundaries And attempting to keep whole words on a line.
    ''' </summary>
    ''' <param name="message">The message to print.</param>
    Sub PrettyPrint(message As String)
        Dim words() As String
        Dim delim() As Char = {" "c} 'Will let tab, carriage return and line feed pass through as-is

        words = message.Split(delim)
        For Each word As String In words
            If Console.CursorLeft > 0 And Console.CursorLeft < Console.WindowWidth Then
                Console.Write(" ")
            End If
            If Console.CursorLeft + word.Length >= Console.WindowWidth Then
                Console.WriteLine()
            End If
            Console.Write(word)
        Next
    End Sub


    ''' <summary>
    ''' Print the program introduction
    ''' </summary>
    Sub PrintIntroduction()
        Console.Clear()
        CenterPrint("MUGWUMP")
        CenterPrint("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY")
        Console.WriteLine()
        Console.WriteLine()
        Console.WriteLine()

        ' Courtesy People's Computer Company
        PrettyPrint("The object of this game is to find four Mugwumps ")
        PrettyPrint("hidden on a 10 by 10 grid. Home base is position 0, 0. ")
        PrettyPrint("Any guess you make must be two numbers with each ")
        PrettyPrint("number between 0 and 9 inclusive. The first number ")
        PrettyPrint("is the distance to the right of home base and the second number ")
        PrettyPrint("is distance above home base.")
        Console.WriteLine()
        Console.WriteLine()
        PrettyPrint("You get 10 tries. After each try, I will tell ")
        PrettyPrint("you how far you are from each Mugwump.")
        Console.WriteLine()
        Console.WriteLine()
    End Sub

End Module
