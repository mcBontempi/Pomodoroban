//
//  NaturalLanguageViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 04/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class NaturalLanguageViewController: UIViewController {

    @IBOutlet weak var wordsAndQuestionsView: WordsAndQuestionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
      
        let pomodoroLengh = StringAndPredicateCollection(WIthStringAndPredicateArray: [
            StringAndPredicate(string: "25 minutes", predicate: 25),
            StringAndPredicate(string: "20 minutes", predicate: 20),
            StringAndPredicate(string: "15 minutes", predicate: 15),
            StringAndPredicate(string: "60 minutes", predicate: 60),
            StringAndPredicate(string: "55 minutes", predicate: 55),
            StringAndPredicate(string: "50 minutes", predicate: 50),
            StringAndPredicate(string: "45 minutes", predicate: 45),
            StringAndPredicate(string: "40 minutes", predicate: 40),
            StringAndPredicate(string: "35 minutes", predicate: 35),
            StringAndPredicate(string: "30 minutes", predicate: 30)])
        
        
        let shortBreakLength = StringAndPredicateCollection(WIthStringAndPredicateArray: [StringAndPredicate(string: "5 minutes", predicate: 2)])
        let shortBreakCount = StringAndPredicateCollection(WIthStringAndPredicateArray: [StringAndPredicate(string: "4th", predicate: 5)])
        let longBreakLength = StringAndPredicateCollection(WIthStringAndPredicateArray: [StringAndPredicate(string: "20 minutes", predicate: 2)])
        
        
        wordsAndQuestionsView.wordsAndQuestions = ["Pomodoroban", "will", "create","your","working","day","with","each","pomodoro","lasting",pomodoroLengh,"after","each","pomodoro","you","will","have","a","break","of",shortBreakLength,"and","after","every",shortBreakCount,"pomodoro","you","will","have","a","break","of",longBreakLength]
      
        
        print (wordsAndQuestionsView.frame)
        
        
    }


}
