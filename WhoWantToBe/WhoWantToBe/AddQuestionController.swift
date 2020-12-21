//
//  AddQuestionController.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/21/20.
//

import UIKit

class AddQuestionController: UIViewController {

    @IBOutlet weak var textQuestion: UITextView!

    @IBOutlet weak var textAnswer1: UITextField!
    @IBOutlet weak var textAnswer2: UITextField!
    @IBOutlet weak var textAnswer3: UITextField!
    @IBOutlet weak var textAnswer4: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addQuestion(_ sender: Any) {
        
        guard let question = textQuestion.text,
              let answer1 = textAnswer1.text,
              let answer2 = textAnswer2.text,
              let answer3 = textAnswer3.text,
              let answer4 = textAnswer4.text
        else {return}

        QuestionsManager.shared.addQuestion(
            QuestionBuilder()
                .setQuestionText(question)
                .addAnswer(answer1, isCorrect: true)
                .addAnswer(answer2, isCorrect: false)
                .addAnswer(answer3, isCorrect: false)
                .addAnswer(answer4, isCorrect: false)
                .build()
        )

    }

}
