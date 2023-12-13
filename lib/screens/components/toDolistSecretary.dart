import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';

class ToDoListSecretary extends StatelessWidget {
  const ToDoListSecretary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your list of To-Do items
    List<ToDoItem> toDoItems = [
      ToDoItem(
          title: 'Task 1',
          description: 'Manage and organize doctor\'s schedule for the day.'),
      ToDoItem(
          title: 'Task 2',
          description:
              'Handle and respond to urgent emails, messages, and phone calls on behalf of the doctor.'),
      ToDoItem(
          title: 'Task 3',
          description: 'Review and summarize patient cases for the day.'),
      ToDoItem(
          title: 'Task 4',
          description:
              'Complete and organize administrative paperwork for the doctor.'),
      ToDoItem(
          title: 'Task 5',
          description:
              'Ensure completion of necessary medical forms for upcoming appointments.'),
      // Add more To-Do items as needed
    ];

    return Container(
      height: 440,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To-Do List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: toDoItems.length,
              itemBuilder: (context, index) => ToDoItemWidget(
                toDoItem: toDoItems[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a new widget to display a single To-Do item
class ToDoItemWidget extends StatelessWidget {
  final ToDoItem toDoItem;

  const ToDoItemWidget({Key? key, required this.toDoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: appPadding),
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toDoItem.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            toDoItem.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// Create a simple class to represent a To-Do item
class ToDoItem {
  final String title;
  final String description;

  ToDoItem({required this.title, required this.description});
}
