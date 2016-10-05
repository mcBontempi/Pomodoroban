//
//  TicketViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 05/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

protocol TicketViewControllerDelegate {
    func ticketViewControllerSave(ticketViewController:TicketViewController)
    func ticketViewControllerCancel(ticketViewController:TicketViewController)
}


class TicketViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!

    @IBOutlet weak var notes: UIView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var pomodoroCountPicker: UIPickerView!
    
    
    
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        
        self.delegate.ticketViewControllerCancel(self)
        
    }
    @IBAction func rightButtonPressed(sender: AnyObject) {
        self.save()
    }
    
    var delegate: TicketViewControllerDelegate!
    var ticket:Ticket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleField.text = self.ticket.name
        
        self.setupPomodoroCountPicker()
    }
    
    
    
    func setupPomodoroCountPicker() {
        self.pomodoroCountPicker.dataSource = self
        self.pomodoroCountPicker.delegate = self
    }
    
    
    func save() {
        
        if self.titleField.text != "" {
            self.ticket.name = self.titleField.text
            self.delegate.ticketViewControllerSave(self)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please Enter a Name for the Ticket", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    var colorHidden = true
    var pomodoroCountHidden = true
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
           colorHidden = !colorHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            pomodoroCountHidden = !pomodoroCountHidden
        
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if (self.pomodoroCountHidden && indexPath.section == 2 && indexPath.row == 1) ||
        (self.colorHidden && indexPath.section == 1 && indexPath.row == 1)
        {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension TicketViewController : UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}


extension TicketViewController : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.greenColor()
        return view
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
     
    }
}

