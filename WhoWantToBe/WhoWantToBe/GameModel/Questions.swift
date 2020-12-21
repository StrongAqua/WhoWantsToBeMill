//
//  Questions.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/10/20.
//

import Foundation

class Answer {
    
    let answer: String
    let correctAnswer: Bool

    var disabled = false
    var probability: Double?
    
    init(answer: String, correctAnswer: Bool) {
        self.answer = answer
        self.correctAnswer = correctAnswer
    }
    
}

class Question {
    
    let question: String
    var answers: [Answer]
    
    init(question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
    }
    
    func fiftyFifty() {
        var incorrectIDs: [Int] = []
        for index in 0..<answers.count {
            if !answers[index].correctAnswer {
                incorrectIDs.append(index)
            }
        }
        let numToDisable = answers.count / 2
        for _ in 0..<numToDisable {
            let index = Int.random(in: 0..<incorrectIDs.count)
            let indexToDisable = incorrectIDs[index]
            incorrectIDs.remove(at: index)
            answers[indexToDisable].disabled = true
        }
    }
    
    func auditoryHelp(_ session: GameSession) {
        let reduceProbability = 1.0 - (Double(session.answersCount)/Double(session.questions.count))
        var votesForAnswers: [Int: Double] = [:]
        var sumOfVotes = 0.0

        for index in 0..<answers.count {
            guard !answers[index].disabled else {continue}

            var votes = Double.random(in: 1...1000)
            if answers[index].correctAnswer {
                votes += 1000.0 * reduceProbability
            }

            votesForAnswers[index] = votes
            sumOfVotes += Double(votes)
        }

        for index in 0..<answers.count {
            guard !answers[index].disabled,
                  let votes = votesForAnswers[index]
            else {continue}

            answers[index].probability = votes / sumOfVotes
        }
    }
}

class QuestionsManager {
    
    private let questions: [Question] = [
        Question(question: "Как правильно продолжить припев детской песни: \"Тили-тили...\"?",
                 answers: [Answer(answer: "хали-гали", correctAnswer: false),
                           Answer(answer: "трали-вали", correctAnswer: true),
                           Answer(answer: "жили-были", correctAnswer: false),
                           Answer(answer: "ели-пили", correctAnswer: false)]),
        Question(question: "Что понадобится, чтобы взрыхлить землю на грядке?",
                 answers: [Answer(answer: "тяпка", correctAnswer: true),
                           Answer(answer: "бабка", correctAnswer: false),
                           Answer(answer: "скобка", correctAnswer: false),
                           Answer(answer: "тряпка", correctAnswer: false)]),
        Question(question: "Как называется экзотическое животное из Южной Америки?",
                 answers: [Answer(answer: "пчеложор", correctAnswer: false),
                           Answer(answer: "термитоглот", correctAnswer: false),
                           Answer(answer: "муравьед", correctAnswer: true),
                           Answer(answer: "комаролов", correctAnswer: false)]),
        Question(question: "Во что превращается гусеница?",
                 answers: [Answer(answer: "в мячик", correctAnswer: false),
                           Answer(answer: "в пирамидку", correctAnswer: false),
                           Answer(answer: "в машинку", correctAnswer: false),
                           Answer(answer: "в куколку", correctAnswer: true)]),
        Question(question: "В какой басне Крылова среди действующих лиц есть человек?",
                 answers: [Answer(answer: "Лягушка и Вол", correctAnswer: false),
                           Answer(answer: "Свинья под Дубом", correctAnswer: false),
                           Answer(answer: "Осел и Соловей", correctAnswer: false),
                           Answer(answer: "Волк на псарне", correctAnswer: true)]),
    ]
    
    static let shared = QuestionsManager()
    private init() { }
    
    func getQuestionsForGame(count: Int = 5) -> [Question] {
        questions
    }
    
}
