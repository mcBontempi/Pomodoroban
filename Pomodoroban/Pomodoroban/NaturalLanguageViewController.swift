//
//  NaturalLanguageViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 04/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class NaturalLanguageViewController: UIViewController {
    
    var pomodoroLengh:StringAndPredicateCollection!
    var shortBreakLength:StringAndPredicateCollection!
    var shortBreakCount:StringAndPredicateCollection!
    var longBreakLength:StringAndPredicateCollection!
    
    @IBOutlet weak var wordsAndQuestionsView: WordsAndQuestionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
            
        }
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.pomodoroLengh = StringAndPredicateCollection(WIthStringAndPredicateArray: [
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
        
        self.shortBreakLength = StringAndPredicateCollection(WIthStringAndPredicateArray: [
            StringAndPredicate(string: "5 minutes", predicate: 5),
            StringAndPredicate(string: "6 minutes", predicate: 6),
            StringAndPredicate(string: "7 minutes", predicate: 7),
            StringAndPredicate(string: "8 minutes", predicate: 8),
            StringAndPredicate(string: "9 minutes", predicate: 9),
            StringAndPredicate(string: "10 minutes", predicate: 10)])
        
        self.shortBreakCount = StringAndPredicateCollection(WIthStringAndPredicateArray: [
            StringAndPredicate(string: "2nd", predicate: 2),
            StringAndPredicate(string: "3rd", predicate: 3),
            StringAndPredicate(string: "4th", predicate: 4)])
        
        self.longBreakLength = StringAndPredicateCollection(WIthStringAndPredicateArray: [
            StringAndPredicate(string: "20 minutes", predicate: 20),
            StringAndPredicate(string: "25 minutes", predicate: 25),
            StringAndPredicate(string: "30 minutes", predicate: 30),
            StringAndPredicate(string: "10 minutes", predicate: 10),
            StringAndPredicate(string: "15 minutes", predicate: 15)])
        
        
        wordsAndQuestionsView.wordsAndQuestions = ["Pomodoroban", "will", "create","your","working","day","with","each","pomodoro","lasting",self.pomodoroLengh,"after","each","pomodoro","you","will","have","a","break","of",self.shortBreakLength,"and","after","every",self.shortBreakCount,"pomodoro","you","will","have","a","break","of",self.longBreakLength]
        
        print (wordsAndQuestionsView.frame)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! TimerViewController
        
        let length = self.pomodoroLengh.predicate() as! Int
        vc.pomodoroLength = length
        vc.shortBreakLength = self.shortBreakLength.predicate() as! Int
        vc.shortBreakCount = self.shortBreakCount.predicate() as! Int
        vc.longBreakLength = self.longBreakLength.predicate() as! Int
        
    }
}
