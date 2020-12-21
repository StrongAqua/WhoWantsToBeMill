//
//  SelectSequenceStrategy.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/17/20.
//

import Foundation

enum QuestionsSequenceStrategy {
    case ordered, random
}

protocol SelectSequenceStrategy {
    func prepareQuestionsList(allQuestions: [Question], amountToSelect: Int) -> [Question]
}

class SelectOrderedStrategy: SelectSequenceStrategy {
    func prepareQuestionsList(allQuestions: [Question], amountToSelect: Int)
    -> [Question] {
        
        var result: [Question] = []
        for i in 0..<amountToSelect {
            guard i < allQuestions.count else {break}
            allQuestions[i].shuffleAnswers()
            result.append(allQuestions[i])
        }
        
        return result
    }
}

class SelectRandomStrategy: SelectSequenceStrategy {
    func prepareQuestionsList(allQuestions: [Question], amountToSelect: Int)
    -> [Question] {

        var reduceQuestionsList = allQuestions
        var result: [Question] = []
        
        for _ in 0..<amountToSelect {
            let index = Int.random(in: 0..<reduceQuestionsList.count)
            let q = reduceQuestionsList[index]
            reduceQuestionsList.remove(at: index)
            q.shuffleAnswers()
            result.append(q)
        }
        
        return result

    }
}
