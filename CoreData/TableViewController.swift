//
//  ViewController.swift
//  CoreData
//
//  Created by Justin Hill on 6/7/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager?
    var moc: NSManagedObjectContext?
    var addButton: UIButton?
    var eventsArray = Event[]()
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.eventsArray = Array<Event>()
        self.locationManager = CLLocationManager()
        self.locationManager!.desiredAccuracy = CLLocationAccuracy.convertFromIntegerLiteral(10)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.locationManager!.delegate = self
    }
    
    init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locations"
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addAction")
        
        self.locationManager!.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor.whiteColor()

        var err: NSError?
        var fetch = NSFetchRequest(entityName: "Event")
        fetch.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
        var result = self.moc!.executeFetchRequest(fetch, error: &err) as Event[]
        
        self.eventsArray = result
    }
    
    func addAction() {
        var loc = self.locationManager!.location
        var model = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.moc!) as Event
        
        model.creationDate = NSDate()
        model.latitude = loc.coordinate.latitude
        model.longitude = loc.coordinate.longitude
        
        self.eventsArray.insert(model, atIndex: 0)
    
        self.tableView!.insertRowsAtIndexPaths([ NSIndexPath(forRow: 0, inSection: 0) ], withRowAnimation: UITableViewRowAnimation.Fade)
        
        println(self.eventsArray)
        
        var err: NSError?
        self.moc!.save(&err)
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var event = self.eventsArray[indexPath.row]
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuse")
        
        cell.textLabel.text = "\(event.creationDate)"
        cell.detailTextLabel.text = "\(event.latitude), \(event.longitude)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.moc!.deleteObject(self.eventsArray[indexPath.row])
            self.eventsArray.removeAtIndex(indexPath.row)
            self.moc!.save(nil)
            
            tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

