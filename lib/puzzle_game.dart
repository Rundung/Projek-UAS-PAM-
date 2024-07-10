import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:projek_uts/widgets/wood_background.dart';

class PuzzleGame extends StatefulWidget {
  final DifficultyLevel difficulty;

  PuzzleGame({required this.difficulty});

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  List<List<int>> _puzzleMatrix = [];
  int _emptyRow = 2;
  int _emptyCol = 2;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePuzzle();
  }

  void _initializePuzzle() {
    _puzzleMatrix = List.generate(3, (row) => List.generate(3, (col) => row * 3 + col + 1));
    _puzzleMatrix[2][2] = 0;
    _shufflePuzzle();
  }

  void _shufflePuzzle() {
    final random = Random();
    int shuffleCount = 100;

    switch (widget.difficulty) {
      case DifficultyLevel.Easy:
        shuffleCount = 30;
        break;
      case DifficultyLevel.Medium:
        shuffleCount = 50;
        break;
      case DifficultyLevel.Hard:
        shuffleCount = 100;
        break;
    }

    for (int i = 0; i < shuffleCount; i++) {
      int row = _emptyRow;
      int col = _emptyCol;
      int direction = random.nextInt(4);
      if (direction == 0 && row > 0)
        row--;
      else if (direction == 1 && col < 2)
        col++;
      else if (direction == 2 && row < 2)
        row++;
      else if (direction == 3 && col > 0)
        col--;
      _puzzleMatrix[_emptyRow][_emptyCol] = _puzzleMatrix[row][col];
      _puzzleMatrix[row][col] = 0;
      _emptyRow = row;
      _emptyCol = col;
    }
  }

  bool isPuzzleSolved() {
    for (int i = 0; i < _puzzleMatrix.length; i++) {
      for (int j = 0; j < _puzzleMatrix[i].length; j++) {
        if (_puzzleMatrix[i][j] != i * 3 + j + 1 && !(i == 2 && j == 2)) {
          return false;
        }
      }
    }
    return true;
  }

  void _moveTile(int row, int col) {
    if ((row == _emptyRow && (col == _emptyCol - 1 || col == _emptyCol + 1)) ||
        (col == _emptyCol && (row == _emptyRow - 1 || row == _emptyRow + 1))) {
      setState(() {
        _puzzleMatrix[_emptyRow][_emptyCol] = _puzzleMatrix[row][col];
        _puzzleMatrix[row][col] = 0;
        _emptyRow = row;
        _emptyCol = col;

        _playMoveSound(); // Memanggil fungsi untuk memainkan suara pergerakan

        if (isPuzzleSolved()) {
          _showCompletionDialog(); // Menampilkan dialog ketika puzzle selesai
        }
      });
    }
  }

  void _playMoveSound() async {
    await _audioPlayer.play(AssetSource('click_sound.ogg'));
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown[700],
          title: Text(
            'Selamat!',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Anda telah menyelesaikan puzzle!',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Balok', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[700],
      ),
      body: WoodBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6, // Mengurangi ukuran puzzle agar lebih pas di layar
                  height: MediaQuery.of(context).size.width * 0.6, // Mengurangi ukuran puzzle agar lebih pas di layar
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return GestureDetector(
                        onTap: () {
                          _moveTile(row, col);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300), // Durasi animasi
                          curve: Curves.easeInOut, // Efek animasi
                          decoration: BoxDecoration(
                            color: _puzzleMatrix[row][col] == 0 ? Colors.brown[300] : Colors.brown[700],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _puzzleMatrix[row][col] == 0 ? '' : _puzzleMatrix[row][col].toString(),
                              style: TextStyle(
                                fontSize: 18, // Mengurangi ukuran font lebih lanjut
                                color: _puzzleMatrix[row][col] == 0 ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Memastikan untuk menghentikan pemutaran audio saat widget di dispose
    super.dispose();
  }
}

enum DifficultyLevel {
  Easy,
  Medium,
  Hard,
}
