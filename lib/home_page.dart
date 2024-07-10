import 'package:flutter/material.dart';
import 'package:projek_uts/puzzle_game.dart';
import 'package:projek_uts/widgets/wood_background.dart';
import 'package:projek_uts/quotes_service.dart';
import 'package:audioplayers/audioplayers.dart';

enum Difficulty_Level {
  Easy,
  Medium,
  Hard,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _quote;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchRandomQuote();
  }

  Future<void> _fetchRandomQuote() async {
    try {
      final quote = await QuotesService.fetchRandomQuote();
      setState(() {
        _quote = quote;
      });
    } catch (error) {
      print('Error fetching quote: $error');
    }
  }

  void _playClickSound() async {
    await _audioPlayer.play(AssetSource('click_sound.ogg'));
  }

  void _playWinSound() async {
    await _audioPlayer.play(AssetSource('win_sound.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permainan Puzzle Balok',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown[700],
      ),
      body: WoodBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang di Permainan Puzzle Kayu!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showDifficultyDialog(context);
                  _playClickSound(); // Memainkan suara saat tombol ditekan
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.brown[600],
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: Text('Mulai Puzzle Balok'),
              ),
              SizedBox(height: 20),
              _quote == null
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _quote!,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text('Pilih Level Kesulitan', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Mudah', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _startGame(context, DifficultyLevel.Easy);
                },
              ),
              ListTile(
                title: Text('Sedang', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _startGame(context, DifficultyLevel.Medium);
                },
              ),
              ListTile(
                title: Text('Sulit', style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _startGame(context, DifficultyLevel.Hard);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startGame(BuildContext context, DifficultyLevel difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PuzzleGame(difficulty: difficulty)),
    );
  }
}
