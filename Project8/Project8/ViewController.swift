//
//  ViewController.swift
//  Project8
//
//  Created by Allen Whearry on 4/6/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "CLUES"
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return label
    }()
    var answersLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "ANSWERS"
        label.numberOfLines = 0
        label.textAlignment = .right
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        return label
    }()
    var currentAnswer: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tap letters to guess"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 44)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    var scoreLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Scrore: 0"
        return label
    }()
    var letterButtons = [UIButton]()

    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var numberOfClues: Int!
    var correctAnswers: Int!
    var level = 1

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)

        let submitBtn = UIButton(type: .system)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.setTitle("SUBMIT", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        view.addSubview(submitBtn)

        let clearBtn = UIButton(type: .system)
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.setTitle("CLEAR", for: .normal)
        clearBtn.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)
        view.addSubview(clearBtn)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)


        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

            submitBtn.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitBtn.heightAnchor.constraint(equalToConstant: 44),

            clearBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearBtn.centerYAnchor.constraint(equalTo: submitBtn.centerYAnchor),
            clearBtn.heightAnchor.constraint(equalToConstant: 44),

            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])

        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterBtn = UIButton(type: .system)
                letterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterBtn.layer.borderColor = UIColor.lightGray.cgColor
                letterBtn.layer.borderWidth = 1
                letterBtn.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)

                // give button some temporary text
                letterBtn.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterBtn.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterBtn)

                // and also to our letterButtons array
                letterButtons.append(letterBtn)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }



    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1
            correctAnswers += 1


            if correctAnswers == numberOfClues {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true, completion: nil)
            }
        } else {
            let ac = UIAlertController(title: "Sorry!", message: "You've submitted a wrong answer!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.clearActivatedButtons()
                self.currentAnswer.text = ""
            }))
            present(ac, animated: true, completion: nil)
            score -= 1
        }
    }

    func clearActivatedButtons() {
        for btn in activatedButtons {
            btn.isHidden = false
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        clearActivatedButtons()
        activatedButtons.removeAll()
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for btn in letterButtons {
            btn.isHidden = false
        }
    }

    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        correctAnswers = 0

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                numberOfClues = lines.count

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterButtons.shuffle()

        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

}

