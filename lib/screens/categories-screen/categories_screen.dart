import 'package:flutter/material.dart';
import 'package:rep_records/components/category-card/category_card.dart';
import 'package:rep_records/screens/category-exercises-screen/category_exercises_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
                            'Categories',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  
                      CategoryCard(
                        name: 'Category 1',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryExercisesScreen(),
                            ),
                          );
                        },
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
