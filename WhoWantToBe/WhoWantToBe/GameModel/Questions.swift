//
//  Questions.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/10/20.
//

import Foundation

class Answer {
    
    let id: Int
    let answer: String
    let correctAnswer: Bool
    
    init(id: Int, answer: String, correctAnswer: Bool) {
        self.id = id
        self.answer = answer
        self.correctAnswer = correctAnswer
    }
    
}

class Question {
    
    let id: Int
    let question: String
    var answers: [Answer]
    
    init(id: Int, question: String, answers: [Answer]) {
        self.id = id
        self.question = question
        self.answers = answers
    }
    
}

class QuestionsManager {
    
    private let questions: [Question] = [
        Question(id: 0,
                 question: "Как правильно продолжить припев детской песни: \"Тили-тили...\"?",
                 answers: [Answer(id: 0, answer: "хали-гали", correctAnswer: false),
                           Answer(id: 1, answer: "трали-вали", correctAnswer: true),
                           Answer(id: 2, answer: "жили-были", correctAnswer: false),
                           Answer(id: 3, answer: "ели-пили", correctAnswer: false)]),
        Question(id: 1,
                 question: "Что понадобится, чтобы взрыхлить землю на грядке?",
                 answers: [Answer(id: 0, answer: "тяпка", correctAnswer: true),
                           Answer(id: 1, answer: "бабка", correctAnswer: false),
                           Answer(id: 2, answer: "скобка", correctAnswer: false),
                           Answer(id: 3, answer: "тряпка", correctAnswer: false)]),
        Question(id: 2,
                 question: "Как называется экзотическое животное из Южной Америки?",
                 answers: [Answer(id: 0, answer: "пчеложор", correctAnswer: false),
                           Answer(id: 1, answer: "термитоглот", correctAnswer: false),
                           Answer(id: 2, answer: "муравьед", correctAnswer: true),
                           Answer(id: 3, answer: "комаролов", correctAnswer: false)]),
        Question(id: 3,
                 question: "Во что превращается гусеница?",
                 answers: [Answer(id: 0, answer: "в мячик", correctAnswer: false),
                           Answer(id: 1, answer: "в пирамидку", correctAnswer: false),
                           Answer(id: 2, answer: "в машинку", correctAnswer: false),
                           Answer(id: 3, answer: "в куколку", correctAnswer: true)]),
        Question(id: 4,
                 question: "В какой басне Крылова среди действующих лиц есть человек?",
                 answers: [Answer(id: 0, answer: "Лягушка и Вол", correctAnswer: false),
                           Answer(id: 1, answer: "Свинья под Дубом", correctAnswer: false),
                           Answer(id: 2, answer: "Осел и Соловей", correctAnswer: false),
                           Answer(id: 3, answer: "Волк на псарне", correctAnswer: true)]),
    ]
    
    static let shared = QuestionsManager()
    private init() { }
    
    func getQuestionsForGame(count: Int = 5) -> [Question] {
        questions
    }
    
}
