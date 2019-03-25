//
//  ViewController.swift
//  Project5
//
//  Created by Allen Whearry on 3/10/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellID = "CellID"
    var allWords = [String]()
    var usedWords = [String]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start Game", style: .plain, target: self, action: #selector(start))
        getStartWords()
        startGame()
    }
    
    func getStartWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    @objc func start() {
        startGame()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // Make sure our clousure does not capture our alert controller(ac) and our view controller(self) strongly
            // weak reference both.
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

//        if isPossible(word: lowerAnswer) {
//            if isOriginal(word: lowerAnswer) {
//                if isReal(word: lowerAnswer) {
//                    usedWords.insert(answer, at: 0)
//
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    // insert row less stressful than reloadData if only changing one cell
//                    tableView.insertRows(at: [indexPath], with: .automatic)
//
//                    return
//                } else {
//                    showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
//                }
//            } else {
//                showErrorMessage(title: "Word used already", message: "Be more Original!")
//            }
//        } else {
//            guard let title = title?.lowercased() else { return }
//            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
//        }

        guard isPossible(word: lowerAnswer) else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
            return
        }
        guard isOriginal(word: lowerAnswer) else {
            showErrorMessage(title: "Word used already", message: "Be more Original!")
            return
        }
        guard isReal(word: lowerAnswer) else {
            showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        usedWords.insert(answer, at: 0)

        let indexPath = IndexPath(row: 0, section: 0)
        // insert row less stressful than reloadData if only changing one cell
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return  false
            }
        }
        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        guard word.count > 3 else { return false }
        guard word != title else { return false }

        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
}

