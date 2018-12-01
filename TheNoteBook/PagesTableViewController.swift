//
//  PagesTableViewController.swift
//  TheNoteBook
//
//  Created by Kenneth Uyabeme on 11/30/18.
//  Copyright © 2018 Kenneth Uyabeme. All rights reserved.
//

import UIKit
import CoreData
class PagesTableViewController: UITableViewController {
    var context:NSManagedObjectContext!
    
    var parentNotebook:Notebook!
    
    var pages:[Page]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Page> = Page.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notebook == %@", parentNotebook)
       
        do {
            pages = try self.context.fetch(fetchRequest) as [Page]
            self.parentNotebook.numberOfPages = Int16(pages.count )
            // Loop through the database results and output each "row" to the screen
            print("In pagesview controller- Number of items in database: \(pages.count)")
            
            // DEBUG CODE
            for x in pages {
                print("Stuff in db: \(x.title!)")
                
            }
            
        }
        catch {
            print("Error when fetching from database")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pagesCell", for: indexPath)
        
        cell.textLabel?.text = pages[indexPath.row].title
        cell.detailTextLabel?.text = "\(pages[indexPath.row].date!)"
        
        return cell
    }
    
    @IBAction func addPageButtonAction(_ sender: Any) {
        // alert box
        
        // MARK: Code for creating an alert Box
        //-----------------------------------------------
        let popup = UIAlertController(title: "Add a page", message: "Give your page a title", preferredStyle: .alert)
        
        popup.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)  // creating & configuring the button
        let saveButton = UIAlertAction(title: "Save", style: .default, handler: {
            // mandatory line for creating a closure in swift
            action in
            
            // code for what should happen when you click the button
            //let data = popup.textFields?[0].text
            
            // save page to the database
            let page = Page(context: self.context)
            page.title = popup.textFields?[0].text   // get whatever they wrote in the text box
            page.date = NSDate() as Date
            self.parentNotebook.numberOfPages = self.parentNotebook.numberOfPages + 1
            //relating the new page to the parent nootbook
            page.notebook = self.parentNotebook
            
            do  {
                try self.context.save()
                print("done saving page to the database")
                
                // update the ui
                self.pages.append(page)
                self.tableView.reloadData();
            }
            catch {
                print("Error while saving to the database")
            }
            
            
        })
        
        popup.addAction(saveButton)             // adds the button to your popup box
        popup.addAction(cancelButton)
        
        // 4. Show the alert box!
        present(popup, animated:true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    @IBAction func editNotebookButtonAction(_ sender: Any) {
        // alert box
        
        // MARK: Code for creating an alert Box
        //-----------------------------------------------
        let popup = UIAlertController(title: "Edit the notebook name", message: "Name:", preferredStyle: .alert)
        
        popup.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)  // creating & configuring the button
        let saveButton = UIAlertAction(title: "Save", style: .default, handler: {
            // mandatory line for creating a closure in swift
            action in
            
            // change parent notebook title to the database
            self.parentNotebook.title = popup.textFields?[0].text
            //relating the new page to the parent nootbook
            
        })
        
        popup.addAction(saveButton)             // adds the button to your popup box
        popup.addAction(cancelButton)
        
        // 4. Show the alert box!
        present(popup, animated:true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // condensed into 1 statement
            self.context.delete(pages[indexPath.row])
            self.parentNotebook.numberOfPages = self.parentNotebook.numberOfPages - 1
            do {
                try self.context.save()         // SEND YOUR DELETE TO THE DATABASE
                print("Deleted!")
            }
            catch {
                print("error while commiting delete")
            }
            
            // UI:  Delete the row from the USER INTEFACE!!!!
            // Reminder: This does NOT delete it from the database!!!
            pages.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let pageScreen = segue.destination as! PageScreenController
        
        let i = (self.tableView.indexPathForSelectedRow?.row)!
        pageScreen.page = pages[i]
        
        // 3. done!
    }
    

}
