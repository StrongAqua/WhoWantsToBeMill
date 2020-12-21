//
//  GameSession.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/12/20.
//

import Foundation

protocol GameSessionDelegate: class {
    func onGameOver(_ result: Int, _ total: Int)
    func onNextQuestion(question: Question)
}

protocol UserEventsDelegate {
    func onAnswerSelected(_ answerNum: Int)
}

class GameSession {
    
    let questions: [Question]
    
    var currentQuestion: Question?
    var answersCount: Observable<Int>
    
    // delegate 'port'
    weak var gameSessionDelegate: GameSessionDelegate?
    
    // closure 'port'
    var gameOverEvent: ((Int, Int) -> Void)?
    
    init(strategy: QuestionsSequenceStrategy = .ordered) {
        answersCount = Observable(0)
        questions =
            QuestionsManager.shared.getQuestionsForGame(
                strategy: strategy
            )
    }
    
    func getCurrentQuestion() -> Question? {
        return currentQuestion
    }

    func nextQuestion() {
        answersCount.value = answersCount.value + 1

        if answersCount.value > questions.count {
            gameOver()
            return
        }

        currentQuestion = questions[answersCount.value - 1]
        gameSessionDelegate?.onNextQuestion(question: currentQuestion!)
    }

    func gameOver() {
        answersCount.value -= 1

        // call delegate
        gameSessionDelegate?.onGameOver(answersCount.value, questions.count)
        // call closure
        // gameOverEvent?(answersCount, questions.count)
        
        Game.shared.records.append(Record(date: Date(), value: answersCount.value))
    }

}

extension GameSession: UserEventsDelegate {

    func onAnswerSelected(_ answerNum: Int) {
        guard answerNum < 4 else {return}
        guard let question = self.currentQuestion else {return}
        
        let answer = question.answers[answerNum]
        if answer.disabled {return}

        if answer.correctAnswer == false {
            gameOver()
            return
        }

        nextQuestion() // already contains reloadData()
    }

}

struct Record: Codable {
    let date: Date
    let value: Int
}
