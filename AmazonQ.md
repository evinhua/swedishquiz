# Swedish Quiz App Deployment Notes

## Initial Issue: Quiz freezing on the third question

The quiz was freezing on the third question because the Question component wasn't properly resetting its state when moving to a new question. This is a common issue in React applications when component state needs to be reset based on changing props.

### Solution

Added a `useEffect` hook to the Question component that resets the component's state whenever the question prop changes:

```jsx
// Reset state when question changes
useEffect(() => {
  setSelectedOption(null);
  setFeedback(null);
  setAttempts(0);
}, [question]);
```

This ensures that when the user moves to a new question, all the previous state (selected option, feedback, and attempts) is cleared, allowing the user to properly interact with the new question.

## Deployment Issue: Blank page on AWS Amplify

When deploying to AWS Amplify, the app initially showed a blank page because the `homepage` field in package.json was set to:

```json
"homepage": "https://evinhua.github.io/swedishquiz"
```

This setting was configuring the app for GitHub Pages deployment, not AWS Amplify.

### Solution

Removed the `homepage` field from package.json, which allowed the app to be built for deployment at the root path (`/`) instead of a specific path (`/swedishquiz`).

## How to test the app

1. Visit the AWS Amplify hosted URL
2. Play through the quiz and verify that you can progress through all questions
3. Check that the attempts counter resets properly for each new question
4. Verify that the scoring system works correctly throughout all 10 questions

## Additional improvements that could be made

1. Add error boundaries to catch and handle unexpected errors
2. Implement local storage to save quiz progress
3. Add animations for smoother transitions between questions
4. Create a timer option for added challenge
5. Add difficulty levels with different question sets
