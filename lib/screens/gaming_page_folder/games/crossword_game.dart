import 'package:flutter/material.dart';
import 'dart:math'; // Import this for shuffling the letters

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({Key? key}) : super(key: key);

  @override
  _ConstitutionCrosswordGameState createState() => _ConstitutionCrosswordGameState();
}

class _ConstitutionCrosswordGameState extends State<CrosswordGame> {
  int currentLevel = 0;
  String formedWord = '';
  List<int> selectedIndexes = [];
  List<String> shuffledLetters = [];

  // List of levels with letters, correct word, and hint/explanation
  final List<Map<String, dynamic>> levels = [
    {
      'letters': ['R', 'I', 'G', 'H', 'T', 'S'],
      'correctWord': 'RIGHTS',
      'hint': 'A fundamental legal entitlement that every citizen has.',
      'explanation': 'Rights are legal, social, or ethical principles of freedom or entitlement.'
    },
    {
      'letters': ['A', 'M', 'E', 'N', 'D'],
      'correctWord': 'AMEND',
      'hint': 'To formally change a legal document like the constitution.',
      'explanation': 'To amend is to formally change or add to a legal document such as the constitution.'
    },
    {
      'letters': ['L', 'I', 'B', 'E', 'R', 'T', 'Y'],
      'correctWord': 'LIBERTY',
      'hint': 'The state of being free from oppressive restrictions.',
      'explanation': 'Liberty refers to the state of being free within society from oppressive restrictions.'
    },
    {
      'letters': ['J', 'U', 'S', 'T', 'I', 'C', 'E'],
      'correctWord': 'JUSTICE',
      'hint': 'Moral fairness and legal equality.',
      'explanation': 'Justice represents fairness in protection of rights and punishment of wrongs.'
    },
    {
      'letters': ['E', 'Q', 'U', 'A', 'L', 'I', 'T', 'Y'],
      'correctWord': 'EQUALITY',
      'hint': 'The state of being equal, especially in rights and opportunities.',
      'explanation': 'Equality refers to ensuring that everyone is treated the same in law and society.'
    },
    {
      'letters': ['F', 'R', 'E', 'E', 'D', 'O', 'M'],
      'correctWord': 'FREEDOM',
      'hint': 'The power or right to act, speak, or think freely.',
      'explanation': 'Freedom is the power or right to act, speak, or think without hindrance or restraint.'
    },
    {
      'letters': ['D', 'E', 'M', 'O', 'C', 'R', 'A', 'C', 'Y'],
      'correctWord': 'DEMOCRACY',
      'hint': 'A system of government by the whole population.',
      'explanation': 'Democracy is a system of government in which the citizens exercise power by voting.'
    },
    {
      'letters': ['S', 'O', 'V', 'E', 'R', 'E', 'I', 'G', 'N'],
      'correctWord': 'SOVEREIGN',
      'hint': 'Supreme power or authority.',
      'explanation': 'Sovereign refers to the authority of a state to govern itself or another state.'
    },
    {
      'letters': ['S', 'E', 'C', 'U', 'L', 'A', 'R'],
      'correctWord': 'SECULAR',
      'hint': 'Not connected with religious or spiritual matters.',
      'explanation': 'A secular state is one that does not favor any religion.'
    },
    {
      'letters': ['J', 'U', 'D', 'I', 'C', 'I', 'A', 'R', 'Y'],
      'correctWord': 'JUDICIARY',
      'hint': 'The system of courts that interprets and applies the law.',
      'explanation': 'The judiciary is responsible for upholding the law and ensuring justice is served.'
    },
    {
      'letters': ['P', 'R', 'E', 'S', 'I', 'D', 'E', 'N', 'T'],
      'correctWord': 'PRESIDENT',
      'hint': 'The head of state in a republic.',
      'explanation': 'The President of India is the ceremonial head of state and exercises certain powers as per the Constitution.'
    },
    {
      'letters': ['P', 'A', 'R', 'L', 'I', 'A', 'M', 'E', 'N', 'T'],
      'correctWord': 'PARLIAMENT',
      'hint': 'The supreme legislative body in India.',
      'explanation': 'The Parliament of India is the supreme legislative body that enacts laws for the country.'
    },
    {
      'letters': ['F', 'E', 'D', 'E', 'R', 'A', 'L', 'I', 'S', 'M'],
      'correctWord': 'FEDERALISM',
      'hint': 'The system of government where power is divided between central and state governments.',
      'explanation': 'Federalism allows different levels of government to share control over the same geographic area.'
    },
    {
      'letters': ['R', 'E', 'P', 'U', 'B', 'L', 'I', 'C'],
      'correctWord': 'REPUBLIC',
      'hint': 'A state in which supreme power is held by the people and their elected representatives.',
      'explanation': 'India is a republic, meaning the head of state is elected, not a monarch.'
    },
    {
      'letters': ['S', 'O', 'C', 'I', 'A', 'L', 'I', 'S', 'T'],
      'correctWord': 'SOCIALIST',
      'hint': 'The belief in the redistribution of resources for the welfare of all.',
      'explanation': 'Socialism advocates for the government or community ownership of production for the welfare of society.'
    },
    {
      'letters': ['D', 'I', 'R', 'E', 'C', 'T', 'I', 'V', 'E'],
      'correctWord': 'DIRECTIVE',
      'hint': 'Instructions given by the government to guide policy-making.',
      'explanation': 'Directive principles guide the Indian government to make laws that aim to achieve social and economic welfare.'
    },
    {
      'letters': ['P', 'R', 'E', 'A', 'M', 'B', 'L', 'E'],
      'correctWord': 'PREAMBLE',
      'hint': 'An introductory statement of the Constitution.',
      'explanation': 'The Preamble of the Indian Constitution outlines its goals and principles.'
    },
    {
      'letters': ['F', 'U', 'N', 'D', 'A', 'M', 'E', 'N', 'T', 'A', 'L'],
      'correctWord': 'FUNDAMENTAL',
      'hint': 'A basic or essential part of a system.',
      'explanation': 'Fundamental rights are essential freedoms guaranteed to Indian citizens by the Constitution.'
    },
    {
      'letters': ['C', 'I', 'T', 'I', 'Z', 'E', 'N', 'S', 'H', 'I', 'P'],
      'correctWord': 'CITIZENSHIP',
      'hint': 'The status of being a recognized member of a state.',
      'explanation': 'Citizenship defines the rights and duties of citizens in the nation.'
    },
    {
      'letters': ['A', 'R', 'T', 'I', 'C', 'L', 'E', 'S'],
      'correctWord': 'ARTICLES',
      'hint': 'The various numbered sections in the Constitution.',
      'explanation': 'Articles in the Constitution cover different provisions related to the governance of the country.'
    }
  ];

  @override
  void initState() {
    super.initState();
    shuffleLetters(); // Shuffle letters when the game starts
  }

  void shuffleLetters() {
    shuffledLetters = List.from(levels[currentLevel]['letters']);
    shuffledLetters.shuffle(Random()); // Shuffle the letters randomly
  }

  void selectLetter(int index) {
    setState(() {
      formedWord += shuffledLetters[index];
      selectedIndexes.add(index);
    });
  }

  void resetGame() {
    setState(() {
      formedWord = '';
      selectedIndexes.clear();
    });
  }

  void checkWord() {
    if (formedWord == levels[currentLevel]['correctWord']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Correct! ${levels[currentLevel]['correctWord']}: ${levels[currentLevel]['explanation']}',
          ),
        ),
      );
      moveToNextLevel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oops! Try again.')),
      );
      resetGame();
    }
  }

  void moveToNextLevel() {
    setState(() {
      if (currentLevel < levels.length - 1) {
        currentLevel++;
      } else {
        currentLevel = 0; // Restart from the first level if all are completed
      }
      shuffleLetters(); // Shuffle letters for the new level
      resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentHint = levels[currentLevel]['hint'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Constitution Crossword - Level ${currentLevel + 1}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Hint: $currentHint',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: shuffledLetters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectedIndexes.contains(index)
                      ? null
                      : () => selectLetter(index),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    color: selectedIndexes.contains(index)
                        ? Colors.blueAccent
                        : Colors.grey[300],
                    child: Center(
                      child: Text(
                        shuffledLetters[index],
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Formed Word: $formedWord',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: resetGame,
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: checkWord,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
