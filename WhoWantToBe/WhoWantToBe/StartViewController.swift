//
//  ViewController.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/9/20.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var gameResultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameResultLabel.text = "Начните Игру!"
    }
    
    @IBAction func onStartGame(_ sender: Any) {
        performSegue(withIdentifier: "StartGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "StartGame":
            guard let gameViewController = segue.destination as? GameViewController else {return}
            gameViewController.delegate = self
            Game.shared.session = GameSession(
                strategy: Game.shared.questionSelectStrategy
            )
        default:
            break
        }
    }
}

extension StartViewController: GameViewControllerDelegate {
    func onGameOver(_ result: Int, _ total: Int) {
        gameResultLabel.text = "Вы ответили на: \(result) из \(total) вопросов"
    }
}

