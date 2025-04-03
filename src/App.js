import React, { useState, useEffect } from 'react';
import './App.css';
import { getRandomQuestions } from './QuizData';
import Question from './Question';

function App() {
  const [questions, setQuestions] = useState([]);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);
  const [showScore, setShowScore] = useState(false);

  useEffect(() => {
    // Get 10 random questions when component mounts
    setQuestions(getRandomQuestions(10));
  }, []);

  const handleAnswerClick = (isCorrect) => {
    if (isCorrect) {
      // Award points based on attempts
      if (attempts === 0) setScore(score + 3);
      else if (attempts === 1) setScore(score + 1);
      
      const nextQuestion = currentQuestion + 1;
      if (nextQuestion < questions.length) {
        setCurrentQuestion(nextQuestion);
        setAttempts(0);
      } else {
        setShowScore(true);
      }
    } else {
      if (attempts < 2) {
        setAttempts(attempts + 1);
      } else {
        const nextQuestion = currentQuestion + 1;
        if (nextQuestion < questions.length) {
          setCurrentQuestion(nextQuestion);
          setAttempts(0);
        } else {
          setShowScore(true);
        }
      }
    }
  };

  const resetQuiz = () => {
    setQuestions(getRandomQuestions(10));
    setCurrentQuestion(0);
    setScore(0);
    setAttempts(0);
    setShowScore(false);
  };

  if (questions.length === 0) {
    return <div className="app">Loading...</div>;
  }

  return (
    <div className="app">
      <h1>Swedish Geography & Culture Quiz</h1>
      {showScore ? (
        <div className="score-section">
          <h2>Quiz completed!</h2>
          <p>Your score: {score} out of {questions.length * 3}</p>
          <button onClick={resetQuiz}>Try Again</button>
        </div>
      ) : (
        <Question
          questionData={questions[currentQuestion]}
          currentQuestion={currentQuestion}
          totalQuestions={questions.length}
          attempts={attempts}
          onAnswerClick={handleAnswerClick}
        />
      )}
    </div>
  );
}

export default App;
