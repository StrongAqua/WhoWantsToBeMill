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
    
    var questions: [Question] = []

    var currentQuestion: Question?
    var answersCount: Int = 0
    
    // delegate 'port'
    weak var gameSessionDelegate: GameSessionDelegate?
    
    // closure 'port'
    var gameOverEvent: ((Int, Int) -> Void)?
    
    init() {
        questions = QuestionsManager.shared.getQuestionsForGame()
    }
    
    func getAnswerText(_ variantNum: Int) -> String {
        guard variantNum < 4 && variantNum >= 0 else {return ""}
        return currentQuestion?.answers[variantNum].answer ?? "(error)"
    }

    func nextQuestion() {
        answersCount = answersCount + 1

        if answersCount > questions.count {
            gameOver()
            return
        }

        currentQuestion = questions[answersCount - 1]
        gameSessionDelegate?.onNextQuestion(question: currentQuestion!)
    }

    func gameOver() {
        answersCount -= 1

        // call delegate
        gameSessionDelegate?.onGameOver(answersCount, questions.count)
        // call closure
        // gameOverEvent?(answersCount, questions.count)
    }

}

extension GameSession: UserEventsDelegate {

    func onAnswerSelected(_ answerNum: Int) {
        guard answerNum < 4 else {return}
        guard let question = self.currentQuestion else {return}

        if question.answers[answerNum].correctAnswer == false {
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
