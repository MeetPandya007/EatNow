//
//  DBmanager.swift
//  Eat Now
//
//  Created by Meet on 07/07/22.
//

import Foundation
import SQLite3


class DBManager
{
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    init()
    {
        db = openDatabase()
        createTable(tableName: "Food")
        
        // Data addeded manually from here
        insertInFoodTable(id: 1, image: "https://tinyurl.com/3cwdavhr~https://tinyurl.com/22a75n37~https://tinyurl.com/3zjjk9e8", name: "Dabeli", shortDescription: "Dabeli, kutchi dabeli or double roti is a popular snack ", description: "Dabeli literally means pressed in Gujarati language. The dish is said to have been invented by Keshavji Gabha Chudasama (also known as Kesha Malam), a resident of Mandvi, Kutch, in the 1960s. When he started business he sold dabeli at the price of one anna or six paisa.", price: "20")
        insertInFoodTable(id: 2, image: "https://tinyurl.com/muedv4wz~https://tinyurl.com/2p95ynv4", name: "Puff", shortDescription: "Puff pastry, also known as pâte feuilletée, is a flaky light pastry made from a laminated dough", description: "Puff pastry seems to be related to the Greek phyllo, and is used in a similar manner to create layered pastries. Puff pastry appears to have evolved from thin sheets of dough spread with olive oil to laminated dough with layers of butter.", price: "30")
        insertInFoodTable(id: 3, image: "https://tinyurl.com/yckpmfzt~https://tinyurl.com/5cnur64c~https://tinyurl.com/bdk7k4ey", name: "Vadapav", shortDescription: "Vada pav, alternatively spelt wada pao, ( listen) is a vegetarian fast food dish native to the state of Maharashtra.", description: "Vada pav, alternatively spelt wada pao, ( listen) is a vegetarian fast food dish native to the state of Maharashtra. The dish consists of a deep fried potato dumpling placed inside a bread bun (pav) sliced almost in half through the middle. It is generally accompanied with one or more chutneys and a green chili pepper.", price: "40")
        createTable(tableName: "Cart")
        createOrdersTable()
    }
    
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
    
    //MARK: - Create queries
    func createOrdersTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Orders (Id INTEGER PRIMARY KEY AUTOINCREMENT, CustomerName TEXT,OrderedItems TEXT,Price TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
                
            } else {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createTable(tableName: String) {
        let createTableString = "CREATE TABLE IF NOT EXISTS '\(tableName)'(Id INTEGER PRIMARY KEY, Image TEXT,Name TEXT,ShortDescription TEXT,Description TEXT,Price TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
                
            } else {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK: - Insert Queries
    func insertInFoodTable(id: Int, image: String, name: String, shortDescription: String, description: String, price: String)
    {
        let item = read(tablename: "Food")
        for p in item
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO Food (Id, Image,Name,ShortDescription,Description,Price) VALUES ('\(id)', '\(image)', '\(name)', '\(shortDescription)', '\(description)', '\(price)');"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (image as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (shortDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (price as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertInCartTable(id: Int, image: String, name: String, shortDescription: String, description: String, price: String)
    {
        
        let insertStatementString = "INSERT INTO Cart (Id, Image,Name,ShortDescription,Description,Price) VALUES ('\(id)', '\(image)', '\(name)', '\(shortDescription)', '\(description)', '\(price)');"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (image as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (shortDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (price as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertInOrders(customerName: String, orderedItems: String, price: String)
    {
        
        let insertStatementString = "INSERT INTO Orders (CustomerName,OrderedItems,Price) VALUES ('\(customerName)', '\(orderedItems)', '\(price)');"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (customerName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (orderedItems as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (price as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK: - Read Queries
    func read(tablename : String) -> [Food] {
        let queryStatementString = "SELECT * FROM '\(tablename)';"
        var queryStatement: OpaquePointer? = nil
        var food : [Food] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let shortDescription = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let price = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                food.append(Food(id:Int(id), image: image, name: name, description: description, shortDescription: shortDescription, price: price))
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return food
    }
    
    func retrieveSingleItem(tablename : String, id: Int) -> [Food] {
        let queryStatementString = "SELECT * FROM '\(tablename)' where Id = '\(id)';"
        var queryStatement: OpaquePointer? = nil
        var food : [Food] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let shortDescription = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let price = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                food.append(Food(id:Int(id), image: image, name: name, description: description, shortDescription: shortDescription, price: price))
                print("Success read retriveSingleItem")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return food
    }
    
    //MARK: - Delete Queries
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM Cart WHERE Id = '\(id)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteByTableName(tableName:String) {
        let deleteStatementStirng = "DELETE FROM Cart;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
