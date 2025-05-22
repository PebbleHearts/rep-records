import 'package:flutter/material.dart';
import 'package:rep_records/components/exercise-card/exercise_card.dart';

class ManageExercisesScreen extends StatelessWidget {
  const ManageExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                          child: Text(
                            'Exercises',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Chest',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ExerciseCard(
                        name: 'Bench Press',
                        equipment: 'Barbell',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 10),
                      ExerciseCard(
                        name: 'Incline Dumbbell Press',
                        equipment: 'Dumbbells',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ExerciseCard(
                        name: 'Pull-ups',
                        equipment: 'Bodyweight',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 10),
                      ExerciseCard(
                        name: 'Barbell Rows',
                        equipment: 'Barbell',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Legs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ExerciseCard(
                        name: 'Squats',
                        equipment: 'Barbell',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 10),
                      ExerciseCard(
                        name: 'Deadlifts',
                        equipment: 'Barbell',
                        onTap: () {},
                        onDelete: () {},
                        onEdit: () {},
                        displayCta: true,
                      ),
                      const SizedBox(height: 20),
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