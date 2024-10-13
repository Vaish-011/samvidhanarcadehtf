import 'package:flutter/material.dart';

class DragAndDropGame extends StatefulWidget {
  const DragAndDropGame({Key? key}) : super(key: key);

  @override
  _DragAndDropGameState createState() => _DragAndDropGameState();
}

class _DragAndDropGameState extends State<DragAndDropGame> {
  // Terms related to the constitution across 10 levels (only one word per level)
  final List<String> targetWords = [
    'Equality',
    'Sovereignty',
    'Justice',
    'Fraternity',
    'Republic',
    'Secularism',
    'Socialism',
    'Democracy',
    'Unity',
    'Liberty',
  ];

  // Sentences corresponding to the levels, with one correct sentence and 3 incorrect ones
  final List<List<String>> sentencesPerLevel = [
    [
      'The Constitution of India guarantees _____ before the law for all citizens.', // Correct
      'The _____ of India provides the fundamental rights to freedom of speech and expression.',
      'India is a _____, socialist, secular, and democratic republic.',
      'The preamble mentions that India shall be a _____ state.'
    ],


    [
      'The government promotes _____ to foster social harmony.',
      'India’s _____ ensures that no external authority controls its decisions.', // Correct
      'The _____ of the Constitution guarantees fundamental rights.',
      '_____ is achieved through democratic principles.'
    ],
    [

      '_____ is an essential element in ensuring state cohesion.',
      'The Constitution provides social, economic, and political _____ to its citizens.', // Correct
      'The state promotes _____ to maintain equality among its citizens.',
      '_____ refers to the country’s independence from foreign control.'
    ],
    [
      'The Preamble promotes _____, ensuring brotherhood among all citizens.', // Correct
      'The government ensures _____ through its sovereignty.',
      '_____ is an essential right under the Constitution.',
      'The country’s _____ is established through democratic elections.'
    ],
    [
      '_____ promotes fundamental rights for all citizens.',
      'The state supports _____ as a form of governance.',
      'India is a _____, meaning the head of state is elected.', // Correct
      '_____ guarantees individual freedoms under the Constitution.'
    ],
    [
      'The Indian government supports _____ to promote democracy.',
      'The idea of _____ is central to social justice.',
      'The state’s _____ is established by its governing principles.',
      '_____ means the state has no official religion and treats all religions equally.', // Correct
    ],
    [
      'The Constitution supports _____ through its laws.',
      '_____ refers to the economic and social system that promotes equality.', // Correct
      '_____ is ensured through the fundamental rights of citizens.',
      '_____ is the foundation of a democratic society.'
    ],
    [
      'India is the largest _____ in the world.', // Correct
      'The Constitution supports _____ for economic reforms.',
      'The _____ of citizens is paramount in a sovereign state.',
      'India is a _____, ensuring brotherhood among its citizens.'
    ],
    [
      '_____ is the guiding principle of economic development.',
      '_____ ensures that laws are implemented fairly across the country.',
      'The Constitution promotes _____ in diversity, ensuring strength in unity.', // Correct
      'The state ensures _____ through its social reforms.'
    ],
    [
      '_____ is the right of individuals to act according to their will without restraint.', // Correct
      'The government enforces _____ to ensure equality in the social, economic, and political spheres.',
      'India maintains _____ through its democratic system.',
      'The _____ of India has been established as a republic.'
    ],
  ];

  // Correct index for each word's matching sentence in each level
  final List<int> correctSentenceIndices = [
    0, // Equality
    1, // Liberty
    1, // Democracy
    0, // Sovereignty
    2, // Justice
    3, // Fraternity
    1, // Republic
    0, // Secularism
    2, // Socialism
    0, // Unity
  ];

  // Store the current level
  int currentLevel = 0;
  bool isCorrect = false;
  bool gameComplete = false;

  // To hold the current target word
  String? currentTargetWord;

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  // Function to generate a new target word for the current level
  void _generateNewWord() {
    currentTargetWord = targetWords[currentLevel];
  }

  // Move to the next word in the current level
  void moveToNextLevel() {
    setState(() {
      if (currentLevel < targetWords.length - 1) {
        currentLevel++;
      } else {
        currentLevel = 0; // Reset to first level if all levels are complete
      }
      isCorrect = false;
      gameComplete = false;
      _generateNewWord(); // Generate new word for the next level
    });
  }

  // Reset the entire game state
  void resetGame() {
    setState(() {
      currentLevel = 0;
      isCorrect = false;
      gameComplete = false;
      _generateNewWord(); // Reset with new word
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution Learning Game'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Drag the correct constitutional term and drop it into the correct sentence:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Display the current draggable word
              Center(
                child: Draggable<String>(
                  data: currentTargetWord!,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Text(
                      currentTargetWord!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(), // Hide word while dragging
                  child: Text(
                    currentTargetWord!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Display Sentences (with one correct sentence per level)
              Column(
                children: List.generate(sentencesPerLevel[currentLevel].length, (index) {
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: gameComplete && correctSentenceIndices[currentLevel] == index
                              ? Colors.green
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          sentencesPerLevel[currentLevel][index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                    onWillAccept: (data) => true, // Accept all drags
                    onAccept: (data) {
                      setState(() {
                        // Check if the word is correct for the sentence
                        if (correctSentenceIndices[currentLevel] == index) {
                          isCorrect = true;
                          gameComplete = true;
                        } else {
                          isCorrect = false;
                          gameComplete = false;
                        }
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Display success or retry messages
              if (gameComplete)
                const Text(
                  'Congratulations! You placed the word correctly!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (!isCorrect)
                const Text(
                  'Oops! Try again.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              // Next Button
              if (gameComplete)
                ElevatedButton(
                  onPressed: moveToNextLevel,
                  child: const Text('Next Word'),
                ),
              // Reset Button
              ElevatedButton(
                onPressed: resetGame,
                child: const Text('Restart Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
