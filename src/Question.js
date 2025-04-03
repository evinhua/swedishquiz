import React, { useState, useEffect } from 'react';

function Question({ questionData, currentQuestion, totalQuestions, attempts, onAnswerClick }) {
  const [shuffledOptions, setShuffledOptions] = useState([]);

  useEffect(() => {
    // Shuffle options whenever questionData changes
    const shuffled = [...questionData.options].sort(() => Math.random() - 0.5);
    setShuffledOptions(shuffled);
  }, [questionData]);

  return (
    <div className="question-section">
      <div className="question-count">
        <span>Question {currentQuestion + 1}</span>/{totalQuestions}
      </div>
      <div className="question-text">{questionData.question}</div>
      <div className="answer-section">
        {shuffledOptions.map((option, index) => (
          <button
            key={index}
            onClick={() => onAnswerClick(option === questionData.correctAnswer)}
          >
            {option}
          </button>
        ))}
      </div>
      <div className="attempts-info">
        {attempts > 0 && (
          <p>Attempts used: {attempts}/2 {attempts === 2 ? "(Last try!)" : ""}</p>
        )}
      </div>
    </div>
  );
}

export default Question;
