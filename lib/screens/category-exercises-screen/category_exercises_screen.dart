import 'package:flutter/material.dart';
import 'package:rep_records/components/exercise-card/exercise_card.dart';

class CategoryExercisesScreen extends StatelessWidget {
  const CategoryExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Category 1',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  
                      ExerciseCard(
                        name: 'Exercise 1',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}