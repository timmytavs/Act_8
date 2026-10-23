# IT 110 Lab Activity 9 — Completed Flutter Code

## Run the project
1. Extract this ZIP file.
2. Open a terminal in the `semester_project` folder (the folder containing `pubspec.yaml`).
3. Run:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

## How to demonstrate the four required states
- **Loading:** Open Report Form, complete all required fields, and click Submit Report. Capture the screen during the 3-second wait.
- **Success:** Submit a valid report while **Simulate submission failure** is OFF.
- **Empty:** Click **View reports (empty list demo)** on the form, or **View report list** after success.
- **Error:** Return to the form, turn **Simulate submission failure** ON, fill all required fields, and submit. Click **Retry Submission** to demonstrate recovery.

## Notes
- The submission is simulated with a 3-second delay. No backend/database is connected and no real report is saved.
- Activity 8's login screen and route are preserved. The home screen now links to both Login and Report Form.
- `app_button.dart` and `app_text_field.dart` are reusable shared widgets.
