# Quiz_management_system

The Quiz Management System is designed to provide a comprehensive and user-friendly platform for administering and taking quizzes. The system leverages PL/SQL for efficient database management and handling complex queries. This documentation outlines the main functionalities of the system, including database setup, user interaction, and administrative features.

## Functionalities

### Database of Questions
Question Storage: Questions are stored in a database with attributes such as question_id, topic, difficulty_level, question_text, answer_options, correct_answer, and explanation.
Categorization: Questions can be categorized based on topic (e.g., Math, Science) and difficulty level (e.g., Easy, Medium, Hard).

### User Quizzes
Quiz Selection: Users can select quizzes based on topics or difficulty levels.
Instant Feedback: After each question, users receive immediate feedback indicating whether their answer was correct or incorrect.

### Timers
Timed Quizzes: Quizzes can be configured with a timer that counts down from a predefined duration.
Auto-Submission: When the timer reaches zero, the quiz is automatically submitted, and the user's answers are saved.

### Score Tracking
Score Calculation: The system calculates the user's score based on the number of correct answers.
Progress Tracking: Users can view their scores and progress over time, including statistics such as average score, highest score, and quiz completion rate.

### Question Formats
Multiple Choice: Users choose one answer from a list of options.
True/False: Users determine whether a statement is true or false.
Short Answer: Users provide a short text response.

### Randomization
Question Order: Questions within a quiz can be randomized to provide a unique experience each time.
Answer Choices: The order of answer choices for multiple-choice questions can also be randomized.

### Custom Quizzes
Quiz Creation: Instructors can create custom quizzes by selecting specific questions from the database.
Assignment: Quizzes can be assigned to individual users or groups, and instructors can set specific time limits and due dates.

### Explanations
Explanations: After each question, users can view an explanation of the correct answer.
