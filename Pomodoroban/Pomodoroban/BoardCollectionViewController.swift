//
//  BoardCollectionViewController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 30/01/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import CoreData

class BoardCollectionViewController: UICollectionViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource  {
  
  var selectedTicket: Ticket!
  
  let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAll(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
    tempFetchedResultsController.delegate = self
    return tempFetchedResultsController
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //   self.collectionView!.registerClass(self, forCellWithReuseIdentifier: reuseIdentifier)
    
    (self.collectionView!.collectionViewLayout as! RAReorderableLayout).scrollDirection = .Horizontal
    
    try! self.fetchedResultsController.performFetch()
    
    self.collectionView?.backgroundColor = UIColor.whiteColor()
    
    
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    let detailTabBarController = segue.destinationViewController as! DetailTabBarController
    
    detailTabBarController.ticket = self.selectedTicket
    
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if indexPath.row == 0 {
      self.selectedTicket = Ticket.createInMoc(self.moc)
      self.selectedTicket.section = Int32(indexPath.section)
      
      if let sections = self.fetchedResultsController.sections {
        let currentSection = sections[indexPath.section]
        self.selectedTicket.row = Int32(currentSection.numberOfObjects - 1)
       }
      
      self.selectedTicket.name = ""
      
      
    }
    else {
      self.selectedTicket = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ticket
    }
    
    self.performSegueWithIdentifier("UITabBarController", sender: self)
  }
  
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    if indexPath.row == 0 {
      return CGSizeMake(200,36)
    }
    
    return CGSizeMake(200, 36)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 10.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 10.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, 10.0, 10.0, 0)
  }
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    if let sections = self.fetchedResultsController.sections {
      return sections.count
    }
    return 0
  }
  
  
  
  func collectionView(collectionView: UICollectionView, allowMoveAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket
    let isDummy = ticket?.name == "dummy" || indexPath.row == 0
    return !isDummy
  }
  
  func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, canMoveToIndexPath: NSIndexPath) -> Bool {
    
    
    if canMoveToIndexPath.row == 1 {
      if let sections = self.fetchedResultsController.sections {
        let currentSection = sections[canMoveToIndexPath.section]
        if currentSection.numberOfObjects == 2 {
          return true
        }
      }
    }
    
    if atIndexPath.section == canMoveToIndexPath.section {
      
      let indexPathRowLessOne = NSIndexPath(forRow: canMoveToIndexPath.row, inSection: canMoveToIndexPath.section)
      
      let ticket = fetchedResultsController.objectAtIndexPath(indexPathRowLessOne) as? Ticket
      
      let isDummy = ticket?.name == "dummy" || canMoveToIndexPath.row == 0
      
      
      
      return !isDummy
    }
    else {
      
      if canMoveToIndexPath.row > 0 {
      
      let indexPathRowLessOne = NSIndexPath(forRow: canMoveToIndexPath.row-1, inSection: canMoveToIndexPath.section)
      
      let ticket = fetchedResultsController.objectAtIndexPath(indexPathRowLessOne) as? Ticket
      
      let isDummy = ticket?.name == "dummy" || canMoveToIndexPath.row == 0
      
      
      
      return !isDummy
      }
      else {
        return false
      }
    }
    
  }
  
  
  func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
    
    let ticket = fetchedResultsController.objectAtIndexPath(atIndexPath) as? Ticket
    
    Ticket.insertTicket(ticket!, toIndexPath: toIndexPath, moc:self.moc)
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let sections = self.fetchedResultsController.sections {
      let currentSection = sections[section]
      return currentSection.numberOfObjects
    }
    return 0
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket
    
    if indexPath.row == 0 {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HeaderTicketCell", forIndexPath: indexPath) as! HeaderCollectionViewCell
      
      cell.ticket = ticket
      
      return cell
      
    }
    
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TicketCell", forIndexPath: indexPath) as! TicketCollectionViewCell
    
    
    cell.ticket = ticket
    
    if indexPath.row == 0 {
      cell.backgroundColor = UIColor.lightGrayColor()
      cell.nameLabel.textColor = UIColor.darkGrayColor()
    }
    else {
      cell.backgroundColor = UIColor.yellowColor()
      cell.nameLabel.textColor = UIColor.blackColor()
    }
    
    if ticket!.name == "dummy" {
      cell.backgroundColor = UIColor.whiteColor()
      cell.nameLabel.textColor = UIColor.whiteColor()
    }
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
  // Uncomment this method to specify if the specified item should be highlighted during tracking
  override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment this method to specify if the specified item should be selected
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
  override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
  
  }
  */
  
}

extension BoardCollectionViewController : NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.collectionView?.reloadData()
  }
}
