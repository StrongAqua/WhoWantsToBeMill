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
    
    var delegate: GameViewControllerDelegate?
    var userEventsDelegate: UserEventsDelegate?
    
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
        Game.shared.session?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = answersTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Game.shared.session?.getAnswerText(indexPath.row) ?? "(error)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userEventsDelegate?.onAnswerSelected(indexPath.row)
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
