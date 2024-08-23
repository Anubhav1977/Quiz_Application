// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int quesCtr = 1; // Counter for the current question number
  int points = 0; // Total points scored
  int a = 0; // First number for the addition question
  int b = 0; // Second number for the addition question
  int correctAnswer = 0; // The correct answer to the current question
  List<int> choices = []; // List of choices to display for the current question
  int? selectedOption; // Currently selected option by the user
  bool isAnswered = false; // Flag to indicate if the question has been answered

  @override
  void initState() {
    super.initState();
    generateQuiz(); // Initialize the quiz by generating the first question
  }

  // Method to generate a new quiz question
  void generateQuiz() {
    setState(() {
      a = Random().nextInt(100); // Generate a random number between 0 and 99
      b = Random()
          .nextInt(100); // Generate another random number between 0 and 99
      correctAnswer =
          a + b; // Calculate the correct answer for the addition question

      // Define the range for incorrect answers
      int max = correctAnswer + 5;
      int min = correctAnswer - 5;

      Set<int> options = {
        correctAnswer
      }; // Initialize options with the correct answer

      // Generate additional incorrect options
      while (options.length < 4) {
        int randomNum = min + Random().nextInt((max + 1) - min);
        options.add(randomNum);
      }

      // Shuffle and set the options list
      choices = options.toList();
      choices.shuffle();
      isAnswered = false; // Reset the answer flag
      selectedOption = null; // Reset the selected option
    });
  }

  // Method to check the selected answer
  void checkAnswer(int selected) {
    if (!isAnswered) {
      setState(() {
        selectedOption = selected;
        isAnswered = true;
        if (selected == correctAnswer) {
          points += 10; // Increase points for a correct answer
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar() // Remove any existing SnackBar
            ..showSnackBar(SnackBar(
              content: Text(
                "Right Answer +10 Points",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 5,
              backgroundColor: Colors.greenAccent,
              behavior: SnackBarBehavior.floating,
            ));
        }
      });
    }
  }

  // Widget to build each option container
  Widget optionContainer(int option) {
    return GestureDetector(
      onTap: () => checkAnswer(option),
      child: Container(
        height: 60,
        width: 280,
        decoration: BoxDecoration(
          color: selectedOption == option
              ? (option == correctAnswer ? Colors.green : Colors.red)
              : Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 10,
              color: Colors.black.withOpacity(0.3), // Subtle shadow effect
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.deepPurpleAccent,
            // Border color for better visibility
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            option.toString(),
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "Quiz App",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // Background container
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            // Question and score container
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Display question number and score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Ques: $quesCtr",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Points: $points",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Display the question
                    Text(
                      "Q.$quesCtr Calculate the addition of (A) : $a & (B) : $b",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            // Options list
            Positioned(
              top: 420,
              left: 30,
              right: 30,
              child: Column(
                children: choices.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: optionContainer(option),
                  );
                }).toList(),
              ),
            ),
            // Next Question button
            if (isAnswered)
              Positioned(
                bottom: 150,
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      quesCtr++; // Move to the next question
                      generateQuiz(); // Generate a new question
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 5,
                  ),
                  child: Text(
                    "Next Question",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
