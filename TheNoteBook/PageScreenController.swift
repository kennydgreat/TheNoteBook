//
//  ViewController.swift
//  TheNoteBook
//
//  Created by Kenneth Uyabeme on 11/30/18.
//  Copyright © 2018 Kenneth Uyabeme. All rights reserved.
//

import UIKit
import CoreData
class PageScreenController: UIViewController {
    var page:Page!
    var context:NSManagedObjectContext!
    @IBOutlet weak var pageText: UITextView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navBar.title = page.title
        if self.page.content == nil  {
            // page.content == nil usually happens when you create a brand new page
            self.pageText.text = ""
        }
        else {
            self.pageText.text = page.content
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        self.page.content = pageText.text!
        
        // 3. Save to the databse
        do {
            try self.context.save();
            print("saved to database!")
        }
        catch {
            print("error while saving note to database")
        }
    }
    
    
}

