//
//  GameViewController.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/10/20.
//

import UIKit

protocol GameViewControllerDelegate: class {
    func onGameOver(_ result: Int, _ total: Int)
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    
    @IBOutlet weak var fiftyFifty: UIButton!
    @IBOutlet weak var askAudience: UIButton!
    
    var delegate: GameViewControllerDelegate?
    var userEventsDelegate: UserEventsDelegate?
    
    var defaultTextColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        answersTable.delegate = self
        answersTable.dataSource = self
        answersTable.separatorColor = UIColor.clear
        
        // TODO: select one of these methods
        // Game.shared.session?.gameOverEvent = gameViewController.onGameOverEvent
        Game.shared.session?.gameSessionDelegate = self
        Game.shared.session?.nextQuestion()
        
        userEventsDelegate = Game.shared.session
    }
    
    func onGameOverEvent(_ result: Int, _ total: Int) -> Void {
        // delegate?.onGameOver(result, total)
        // dismiss(animated: true)
    }
        
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Game.shared.session?.getCurrentQuestion()?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = answersTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let question = Game.shared.session?.getCurrentQuestion() {
            let answer = question.answers[indexPath.row]
            if (defaultTextColor == nil) {
                defaultTextColor = cell.textLabel?.textColor ?? nil
            }
            var strProbability = ""
            if let probability = answer.probability {
                var p = probability * 100.0
                p.round()
                strProbability = " \(Int(p))%"
            }
            cell.textLabel?.text = answer.answer + strProbability
            cell.textLabel?.textColor = answer.disabled ? UIColor.gray : defaultTextColor
        } else {
            cell.textLabel?.text = "(error)"
            cell.textLabel?.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userEventsDelegate?.onAnswerSelected(indexPath.row)
    }
    @IBAction func fiftyFifty(_ sender: UIButton) {
        fiftyFifty.isHidden = true
        if let question = Game.shared.session?.getCurrentQuestion() {
            question.fiftyFifty()
            answersTable.reloadData()
        }
    }
    @IBAction func askAudience(_ sender: UIButton) {
        askAudience.isHidden = true
        guard let session = Game.shared.session else {return}
        if let question = session.getCurrentQuestion()
        {
            question.auditoryHelp(session)
            answersTable.reloadData()
        }
    }
    
}

extension GameViewController: GameSessionDelegate {
    
    func onGameOver(_ result: Int, _ total: Int) {
        delegate?.onGameOver(result, total)
        dismiss(animated: true)
    }
    
    func onNextQuestion(question: Question) {
        guard let gameSession = Game.shared.session,
              let questionText = gameSession.currentQuestion?.question
        else {return}

        let questionNumber = gameSession.answersCount
        questionLabel.text = "Вопрос \(questionNumber)/5: \(questionText))"
        
        answersTable.reloadData()
    }
}
