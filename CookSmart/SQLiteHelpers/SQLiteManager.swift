//
//  SQLiteManager.swift
//  CookSmart
//
//  Created by Ricky Primayuda Putra on 25/11/24.
//

import Foundation
import SQLite3

class SQLiteManager {
    static let shared = SQLiteManager()
    private var db: OpaquePointer?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("CookSmart.sqlite3")
            
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("Failed to open database")
                return
            }
            
//            let dropTableQuery = "DROP TABLE IF EXISTS favorites;"
//            let dropTableQuery2 = "DROP TABLE IF EXISTS plan_food;"
//
//            let combinedQuery = dropTableQuery + dropTableQuery2
//
//            if sqlite3_exec(db, combinedQuery, nil, nil, nil) != SQLITE_OK {
//                let errorMessage = String(cString: sqlite3_errmsg(db))
//                print("Failed to drop tables: \(errorMessage)")
//            }
            
            createFavoritesTable()
            createPlanFoodTable()
        } catch {
            print("Failed to setup database: \(error)")
        }
    }
    
    private func createFavoritesTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS favorites (
            idRecipe INTEGER PRIMARY KEY,
            title VARCHAR(255),
            image VARCHAR(255)
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to create table: \(errorMessage)")
        } else {
            print("Table 'favorites' checked/created successfully.")
        }
    }
    
    private func createPlanFoodTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS plan_food (
            idRecipe INTEGER PRIMARY KEY,
            title VARCHAR(255),
            image VARCHAR(255),
            calories FLOAT,
            date VARCHAR(255)
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to create table: \(errorMessage)")
        } else {
            print("Table 'plan_food' checked/created successfully.")
        }
    }
    
    func addFavorite(id: Int, title: String, image: String) {
        guard !title.isEmpty, !image.isEmpty else {
            print("Error: Title or Image is empty.")
            return
        }
        
        let insertQuery = "INSERT INTO favorites (idRecipe, title, image) VALUES (\(id), '\(title)', '\(image)');"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully added favorite with idRecipe: \(id)")
                
                let favorites = getAllFavorites()
                for favorite in favorites {
                    print("Favorite: \(favorite.title ?? "No Title"), Image: \(favorite.image ?? "No Image")")
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to add favorite: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    
    func removeFavorite(id: Int) {
        let deleteQuery = "DELETE FROM favorites WHERE idRecipe = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            print("Attempting to remove favorite with idRecipe: \(id)")
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to remove favorite: \(errorMessage)")
            } else {
                print("Successfully removed favorite with idRecipe: \(id)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func isFavorite(id: Int) -> Bool {
        let selectQuery = "SELECT idRecipe FROM favorites WHERE idRecipe = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            print("Checking if idRecipe \(id) is in favorites.")
            
            if sqlite3_step(statement) == SQLITE_ROW {
                print("idRecipe \(id) is found in favorites.")
                sqlite3_finalize(statement)
                return true
            } else {
                print("idRecipe \(id) is NOT found in favorites.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func getAllFavorites() -> [FavoriteFood] {
        var favoriteFoods: [FavoriteFood] = []
        let selectQuery = "SELECT idRecipe, title, image FROM favorites;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let idRecipe = sqlite3_column_int(statement, 0)
                
                let rawTitle = sqlite3_column_text(statement, 1)
                let rawImage = sqlite3_column_text(statement, 2)
                
                print("Raw Title: \(rawTitle.map { String(cString: $0) } ?? "NULL")")
                print("Raw Image: \(rawImage.map { String(cString: $0) } ?? "NULL")")
                
                let title = rawTitle != nil ? String(cString: rawTitle!) : nil
                let image = rawImage != nil ? String(cString: rawImage!) : nil
                
                print("idRecipe: \(idRecipe), title: \(title ?? "No Title"), image: \(image ?? "No Image")")
                
                let favorite = FavoriteFood(idRecipe: Int(idRecipe), title: title, image: image)
                favoriteFoods.append(favorite)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        print("Total favorites fetched: \(favoriteFoods.count)")
        return favoriteFoods
    }
    
    func addPlanFood(id: Int, title: String, image: String, calories: Float, date: String) {
        guard !title.isEmpty, !image.isEmpty else {
            print("Error: Title or Image is empty.")
            return
        }
        
        let insertQuery = "INSERT INTO plan_food (idRecipe, title, image, calories, date) VALUES (\(id), '\(title)', '\(image)', \(calories), '\(date)');"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully added plan food with idRecipe: \(id)")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to add plan food: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func getAllPlanFood() -> [PlanFood] {
        var planFoods: [PlanFood] = []
        let selectQuery = "SELECT idRecipe, title, image, calories, date FROM plan_food;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let idRecipe = sqlite3_column_int(statement, 0)
                let rawTitle = sqlite3_column_text(statement, 1)
                let rawImage = sqlite3_column_text(statement, 2)
                let calories = sqlite3_column_double(statement, 3)
                let rawDate = sqlite3_column_text(statement, 4)
                
                let title = rawTitle != nil ? String(cString: rawTitle!) : nil
                let image = rawImage != nil ? String(cString: rawImage!) : nil
                let date = rawDate != nil ? String(cString: rawDate!) : nil
                
                let planFood = PlanFood(idRecipe: Int(idRecipe), title: title, image: image, calories: Float(calories), date: date)
                planFoods.append(planFood)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        print("Total plan foods fetched: \(planFoods.count)")
        return planFoods
    }
    
    func getPlanFoodByDateRange(startDate: Date, endDate: Date) -> [PlanFood] {
        var planFoods: [PlanFood] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        print("DEBUG: Start Date - \(startDateString), End Date - \(endDateString)")
        
        let selectQuery = """
        SELECT idRecipe, title, image, calories, date 
        FROM plan_food 
        WHERE date BETWEEN '\(startDateString)' AND '\(endDateString)';
        """
        print("DEBUG: SQL Query - \(selectQuery)")
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            print("DEBUG: Query prepared successfully.")
            while sqlite3_step(statement) == SQLITE_ROW {
                let idRecipe = sqlite3_column_int(statement, 0)
                let rawTitle = sqlite3_column_text(statement, 1)
                let rawImage = sqlite3_column_text(statement, 2)
                let calories = sqlite3_column_double(statement, 3)
                let rawDate = sqlite3_column_text(statement, 4)
                
                let title = rawTitle != nil ? String(cString: rawTitle!) : nil
                let image = rawImage != nil ? String(cString: rawImage!) : nil
                let date = rawDate != nil ? String(cString: rawDate!) : nil
                
                print("""
                DEBUG: Fetched Row - idRecipe: \(idRecipe),
                Title: \(title ?? "NULL"),
                Image: \(image ?? "NULL"),
                Calories: \(calories),
                Date: \(date ?? "NULL")
                """)
                
                let planFood = PlanFood(idRecipe: Int(idRecipe), title: title, image: image, calories: Float(calories), date: date)
                planFoods.append(planFood)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("DEBUG: Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        print("DEBUG: Total Plan Foods Fetched: \(planFoods.count)")
        return planFoods
    }

    
    
    deinit {
        sqlite3_close(db)
        print("Database connection closed.")
    }
}
