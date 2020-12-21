//
//  Questions.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/10/20.
//

import Foundation

class Answer: Codable {
    
    let answer: String
    let correctAnswer: Bool

    var disabled = false
    var probability: Double?
    
    init(answer: String, correctAnswer: Bool) {
        self.answer = answer
        self.correctAnswer = correctAnswer
    }
    
}

class QuestionBuilder {

    var question: String = ""
    var answers: [Answer] = []
    
    func build() -> Question {
        return Question(question: question, answers: answers)
    }
    
    func setQuestionText(_ text: String) -> QuestionBuilder {
        question = text
        return self
    }
    
    func addAnswer(_ text: String, isCorrect: Bool) -> QuestionBuilder {
        guard answers.count < 5 else {return self}
        answers.append(Answer(answer: text, correctAnswer: isCorrect))
        return self
    }
}

class Question: Codable {
    
    var question: String = ""
    var answers: [Answer] = []
    
    init() { }
    
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
        let reduceProbability = 1.0 - (Double(session.answersCount.value)/Double(session.questions.count))
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
    
    func shuffleAnswers() {
        answers.shuffle()
    }
}

class QuestionsManager {
    
    private var questions: [Question] = []
    
    static let shared = QuestionsManager()
    private init() {
        questions = QuestionsCaretaker().retrieveQuestions()

        if questions.isEmpty {
            questions.append(
                QuestionBuilder()
                    .setQuestionText("Как правильно продолжить припев детской песни: \"Тили-тили...\"?")
                    .addAnswer("хали-гали", isCorrect: false)
                    .addAnswer("трали-вали", isCorrect: true)
                    .addAnswer("жили-были", isCorrect: false)
                    .addAnswer("ели-пили", isCorrect: false)
                    .build()
            )
            
            questions.append(
                QuestionBuilder()
                    .setQuestionText("Что понадобится, чтобы взрыхлить землю на грядке?")
                    .addAnswer("тяпка", isCorrect: true)
                    .addAnswer("бабка", isCorrect: false)
                    .addAnswer("скобка", isCorrect: false)
                    .addAnswer("тряпка", isCorrect: false)
                    .build()
            )
            
            questions.append(
                QuestionBuilder()
                    .setQuestionText("Как называется экзотическое животное из Южной Америки?")
                    .addAnswer("пчеложор", isCorrect: false)
                    .addAnswer("термитоглот", isCorrect: false)
                    .addAnswer("муравьед", isCorrect: true)
                    .addAnswer("комаролов", isCorrect: false)
                    .build()
            )
            
            questions.append(
                QuestionBuilder()
                    .setQuestionText("Во что превращается гусеница?")
                    .addAnswer("в мячик", isCorrect: false)
                    .addAnswer("в пирамидку", isCorrect: false)
                    .addAnswer("в машинку", isCorrect: false)
                    .addAnswer("в куколку", isCorrect: true)
                    .build()
            )
            
            questions.append(
                QuestionBuilder()
                    .setQuestionText("В какой басне Крылова среди действующих лиц есть человек?")
                    .addAnswer("Лягушка и Вол", isCorrect: false)
                    .addAnswer("Свинья под Дубом", isCorrect: false)
                    .addAnswer("Осел и Соловей", isCorrect: false)
                    .addAnswer("Волк на псарне", isCorrect: true)
                    .build()
            )
        }
    }
    
    func getQuestionsForGame(strategy: QuestionsSequenceStrategy = .ordered, amountToSelect: Int = 5) -> [Question] {
        switch strategy {
            case .ordered:
                return SelectOrderedStrategy()
                    .prepareQuestionsList(allQuestions: questions, amountToSelect: amountToSelect)
            case .random:
                return SelectRandomStrategy()
                    .prepareQuestionsList(allQuestions: questions, amountToSelect: amountToSelect)
        }
    }
    
    func addQuestion(_ question: Question) {
        questions.append(question)
        QuestionsCaretaker().save(questions: questions)
    }
    
}
