//
//  MasterTableViewController.swift
//  VimeoProject
//
//  Created by David Nadri on 9/18/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    var objects = [NSDictionary?]()
    
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    func getStaffPicks() {
        print("getStaffPicks called")
        
        activityIndicatorView.startAnimating()
        
        let endpoint = "https://api.vimeo.com/channels/staffpicks/videos"
        guard let url = NSURL(string: endpoint) else {
            print("Error: Unable to create URL endpoint.")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("bearer b8e31bd89ba1ee093dc6ab0f863db1bd", forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "GET"
        request.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        
        // Synchronous Request
        //        do {
        //
        //            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        //            do {
        //                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        //
        //                if let data = json["data"] as? [[String: AnyObject]] {
        //                    //print("data: \(data)")
        //                    for object in data {
        //                        print("object: \(object)")
        //                        self.objects.append(object)
        //                    }
        //                }
        //            } catch let error as NSError {
        //                print("Error: \(error)")
        //            }
        //
        //        } catch let error as NSError {
        //            print(error.localizedDescription)
        //        }
        
        
        // Asynchronous Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in

            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                
                if let data = json["data"] as? [[String: AnyObject]] {
                    for object in data {
                        print("object: \(object)")
                        self.objects.append(object)
                    }
                    // Reload the rows and sections of the tableview asynchronously because data task may take some time to retrieve contents from API request
                    // Otherwise, data would not be loaded into the tableview since numberOfRowsInSection and thus cellForRowAtIndexPath would not be called again later
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicatorView.startAnimating()
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                //self.activityIndicatorView.startAnimating()
                print("Error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStaffPicks()
        
        navigationItem.title = "Vimeo Staff Picks"
        
        tableView.backgroundView = activityIndicatorView
        
        // Removes extra cell separators below tableview (of empty/unused cells: no more videos)
        tableView.tableFooterView = UIView()
        
        // Self-sizing cells (layout constraints must be set for cell)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    // MARK: UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! VimeoCell
        
        // Set UITableViewCell selection style color
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.selectedBackgroundView = customColorView
        
        if let object = self.objects[indexPath.row] {
            
            let url = object["pictures"]?["sizes"]??[0]["link"] as? String
            cell.pictureImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: url!)!)!)
            
            cell.videoTitleLabel.text = object["name"] as? String
            
            cell.usernameLabel.text = object["user"]?["name"] as? String
            
            if let createdTime = object["created_time"] as? String {
                let dateFormatter = NSDateFormatter()
                // - TODO: Confirm created_time string matches date format otherwise will return nil
                // curl -i -H "Authorization: bearer b8e31bd89ba1ee093dc6ab0f863db1bd" https://api.vimeo.com/channels/staffpicks/videos
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
                let date = dateFormatter.dateFromString(createdTime)
                cell.timestampLabel.text = NSDate().offsetFrom(date!)
            }
            
            if let numberOfPlays = object["stats"]?["plays"] as? Int {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                let formattedNumberString = numberFormatter.stringFromNumber(numberOfPlays)!
                cell.numberOfPlaysLabel.text = "\(formattedNumberString) plays"
                
            }
            
            if let seconds = object["duration"] as? Int {
                let duration = secondsToMinutesSeconds(seconds)
                let formattedSeconds = NSString(format: "%02d", duration.seconds)
                cell.durationLabel.text = "\(duration.minutes):\(formattedSeconds)"
            }
            
        } else {
            print("NO OBJECTS")
        }
        
        
        return cell
    }
    
    func secondsToMinutesSeconds(seconds: Int) -> (minutes: Int, seconds: Int) {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return (minutes, seconds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
