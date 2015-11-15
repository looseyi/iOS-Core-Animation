//
//  MasterViewController.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 10/31/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

struct ContentModel {
    let title: String
    let desc: String
    let url: String
    let layer: String
    let identifity: String
    init(json: [String : String]) {
        self.layer = json["layer"] ?? ""
        self.title = json["title"] ?? ""
        self.desc = json["description"] ?? ""
        self.url = json["url"] ?? ""
        self.identifity = json["identifity"] ?? "DetailCell"
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [ContentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        _lgc_setupContent()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "showDrawing" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DrawViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objects[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(object.identifity, forIndexPath: indexPath) as! MasterCell
        if let titleLabel = cell.titleLabel {
            titleLabel.text = object.title
        }
        if let detailLabel = cell.detailLabel {
            detailLabel.text = object.desc
        }
        return cell
    }
    
    private func _lgc_setupContent() {
        do {
            if let path = NSBundle.mainBundle().pathForResource("content", ofType:"json") {
                let data = try NSData(contentsOfFile:path, options:.DataReadingMappedIfSafe)
                let items = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSArray
                for item in items {
                    if let json = item as? [String : String] {
                        objects.append(ContentModel(json:json))
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}

class MasterCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}