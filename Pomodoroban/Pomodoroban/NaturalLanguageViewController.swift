//
//  NaturalLanguageViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 04/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import LSRepeater

class NaturalLanguageViewController: UIViewController {
    
    @IBOutlet weak var estimateLabel: UILabel!
    
    var pomodoroLengh:StringAndPredicateCollection!
    var shortBreakLength:StringAndPredicateCollection!
    var shortBreakCount:StringAndPredicateCollection!
    var longBreakLength:StringAndPredicateCollection!
    
    @IBOutlet weak var wordsAndQuestionsView: WordsAndQuestionsView!
    
    
    let moc = CoreDataServices.sharedInstance.moc
    
    func updateEstimateLabel() {
    
        let childMoc = CoreDataServices.sharedInstance.childMoc()
        Runtime.removeAllEntities(childMoc)
        
        Runtime.createForToday(childMoc, pomodoroLength: self.pomodoroLengh.predicate() as! Int
        , shortBreakLength: (self.shortBreakLength.predicate() as! Int)
        , longBreakLength: (self.longBreakLength.predicate() as! Int) 
        , shortBreakCount: self.shortBreakCount.predicate() as! Int)
        
        let runtimes = Runtime.all(childMoc)
        
        var totalWork = 0
        var totalBreak = 0
        
        for runtime in runtimes {
            if runtime.type == 0 {
            totalWork = totalWork + Int(runtime.length)
            }
            else {
                totalBreak = totalBreak + Int(runtime.length)
            }
        }
        
        Runtime.removeAllEntities(childMoc)
        
        let finishTime = NSDate().dateByAddingTimeInterval(NSTimeInterval(totalBreak*60 + totalWork*60))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        let time = dateFormatter.stringFromDate(finishTime)
        
        self.estimateLabel.text = "\(totalWork + totalBreak) mins total time, \(totalWork) mins of work and \(totalBreak) mins of break, estimated finish time will be \(time)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordsAndQuestionsView.delegate = self
        
        
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
            
        }
    
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Natural Language")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.pomodoroLengh = StringAndPredicateCollection(WIthStringAndPredicateArray: [
            StringAndPredicate(string: "25 minutes", predicate: 25), //25
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
            StringAndPredicate(string: "5 minutes", predicate: 5), //5
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
            StringAndPredicate(string: "20 minutes", predicate: 20), //20
            StringAndPredicate(string: "25 minutes", predicate: 25),
            StringAndPredicate(string: "30 minutes", predicate: 30),
            StringAndPredicate(string: "10 minutes", predicate: 10),
            StringAndPredicate(string: "15 minutes", predicate: 15)])
        
        
        wordsAndQuestionsView.wordsAndQuestions = ["Pomodoroban", "will", "create","your","working","day","with","each","pomodoro","lasting",self.pomodoroLengh,"after","each","pomodoro","you","will","have","a","break","of",self.shortBreakLength,"and","after","every",self.shortBreakCount,"pomodoro","you","will","have","a","break","of",self.longBreakLength]
        
        print (wordsAndQuestionsView.frame)
        
        self.repeater = LSRepeater.repeater(1, fireOnceInstantly: true
            , execute: { 
                self.updateEstimateLabel()
                
                
        })
        
    }
    
    var repeater:LSRepeater!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.repeater.invalidate()
        
        let vc = segue.destinationViewController as! TimerViewController
        let length = self.pomodoroLengh.predicate() as! Int
        vc.pomodoroLength = length * 60
        vc.shortBreakLength = self.shortBreakLength.predicate() as! Int * 60
        vc.shortBreakCount = self.shortBreakCount.predicate() as! Int
        vc.longBreakLength = self.longBreakLength.predicate() as! Int * 60
    }
}

extension NaturalLanguageViewController : WordsAndQuestionsViewDelegate {
    func userChangedWordsAndQuestionsView(wordsAndQuestionsView: WordsAndQuestionsView!) {
        self.updateEstimateLabel()
    }
}
