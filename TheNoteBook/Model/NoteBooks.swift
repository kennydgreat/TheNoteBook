//
//  NoteBooks.swift
//  TheNoteBook
//
//  Created by Kenneth Uyabeme on 11/30/18.
//  Copyright © 2018 Kenneth Uyabeme. All rights reserved.
//

import UIKit
import CoreData
class NoteBooks: NSObject {
    var context:NSManagedObjectContext!
    //var pages:[Page] = []       // make an empty array of Page objects
    override init() {
        // 1. Mandatory - copy and paste this
        // Explanation: try to create/initalize the appDelegate variable.
        // If creation fails, then quit the app
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func getNotebookPagesFromDatabase(notebook:String) -> Array<Page>{
        //Array for pages
        var results: Array <Page> = []
        let fetchRequest:NSFetchRequest<Page> = Page.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notebook == %@", notebook)
        
        do {
            // Send the "SELECT *" to the database
            //  results = variable that stores any "rows" that come back from the db
            // Note: The database will send back an array of User objects
            // (this is why I explicilty cast results as [User]
            results = try self.context.fetch(fetchRequest) as [Page]
            
            // Loop through the database results and output each "row" to the screen
            print("Number of items in database: \(results.count)")
            
            
            // DEBUG CODE
            for x in results {
                print("Stuff in db: \(x.title!)")
                
            }
            
        }
        catch {
            print("Error when fetching from database")
        }
        return results
    }
    
    
}
