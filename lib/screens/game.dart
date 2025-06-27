import 'package:flutter/material.dart';
import 'dart:async';

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, '');
  bool xTurn = true;
  String? winner;
  bool gameStarted = false;
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (stopwatch.isRunning) setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _handleTap(int index) {
    if (!gameStarted || board[index] != '' || winner != null) return;

    setState(() {
      board[index] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      winner = _checkWinner();
    });
  }

  String? _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      String a = board[pattern[0]];
      String b = board[pattern[1]];
      String c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        stopwatch.stop();
        return a;
      }
    }

    if (!board.contains('')) {
      stopwatch.stop();
      return 'Draw';
    }

    return null;
  }

  void _startGame() {
    setState(() {
      board = List.filled(9, '');
      xTurn = true;
      winner = null;
      gameStarted = true;
      stopwatch.reset();
      stopwatch.start();
    });
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      xTurn = true;
      winner = null;
      gameStarted = false;
      stopwatch.reset();
    });
  }

  Widget _buildBox(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: board[index] == 'X'
                  ? Colors.blue
                  : board[index] == 'O'
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildBoard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (_, index) => _buildBox(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String status = winner == null
        ? '${xTurn ? 'X' : 'O'}\'s Turn'
        : winner == 'Draw'
        ? 'It\'s a Draw!'
        : '$winner Wins!';

    String time = stopwatch.elapsed.inMinutes.toString().padLeft(2, '0') +
        ":" + (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(status, style: TextStyle(fontSize: 28, color: Colors.black)),
          SizedBox(height: 20),
          _buildBoard(),
          SizedBox(height: 20),
          if (!gameStarted)
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Start Game', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          if (winner != null)
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Restart', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          SizedBox(height: 10),
          if (gameStarted)
            Text('Time: $time', style: TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }
}
