//
//  ViewController.swift
//  Project2
//
//  Created by Allen Whearry on 2/27/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var btn1 = FlagButton()
    var btn2 = FlagButton()
    var btn3 = FlagButton()
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var questionsToAsk = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        
        // connect button action
        btn1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        btn3.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // set button tag
        btn2.tag = 1
        btn3.tag = 2
        
        displayConstraints()
    }
    
    private func displayConstraints() {
        let btnWidth: CGFloat = 200
        let btnHeight: CGFloat = 100
        NSLayoutConstraint.activate([
            btn1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            btn1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            btn1.widthAnchor.constraint(equalToConstant: btnWidth),
            btn1.heightAnchor.constraint(equalToConstant: btnHeight),
            
            btn2.topAnchor.constraint(equalTo: btn1.bottomAnchor, constant: 30),
            btn2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            btn2.widthAnchor.constraint(equalToConstant: btnWidth),
            btn2.heightAnchor.constraint(equalToConstant: btnHeight),
            
            btn3.topAnchor.constraint(equalTo: btn2.bottomAnchor, constant: 30),
            btn3.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            btn3.widthAnchor.constraint(equalToConstant: btnWidth),
            btn3.heightAnchor.constraint(equalToConstant: btnHeight),
        ])
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = "\(countries[correctAnswer].uppercased()) | Score: \(score)"
        
        btn1.setImage(UIImage(named: countries[0]), for: .normal)
        btn2.setImage(UIImage(named: countries[1]), for: .normal)
        btn3.setImage(UIImage(named: countries[2]), for: .normal)
        questionsAsked += 1
    }
    
    func startOver(action: UIAlertAction! = nil) {
        score = 0
        questionsAsked = 0
        askQuestion()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong!\nThat's the flag of \(countries[sender.tag].capitalized)"
            score -= 1
        }
        
        if questionsAsked >= questionsToAsk {
            let ac = UIAlertController(title: "Congrats!", message: "Your Final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start Over?", style: .default, handler: startOver))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }


}

