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
            
            print("SQLite database location: \(fileURL.path)")
            
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("Failed to open database")
                return
            }
            
//            let dropTableQuery = "DROP TABLE IF EXISTS favorites;"
//            let dropTableQuery2 = "DROP TABLE IF EXISTS plan_food;"
//            let dropTableQuery3 = "DROP TABLE IF EXISTS shoping;"
//            
//            let combinedQuery = dropTableQuery + dropTableQuery2 + dropTableQuery3
//            
//            if sqlite3_exec(db, combinedQuery, nil, nil, nil) != SQLITE_OK {
//                let errorMessage = String(cString: sqlite3_errmsg(db))
//                print("Failed to drop tables: \(errorMessage)")
//            }
            
            createFavoritesTable()
            createPlanFoodTable()
            createShopingFoodTable()
        } catch {
            print("Failed to setup database: \(error)")
        }
    }
    
    private func createFavoritesTable() {
        let createTableQuery = """
                CREATE TABLE IF NOT EXISTS favorites (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idRecipe INTEGER,
                    user_id VARCHAR(255),
                    title VARCHAR(255),
                    image VARCHAR(255),
                    FOREIGN KEY (user_id) REFERENCES users(user_id)
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
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                idRecipe INTEGER,
                user_id VARCHAR(255),
                title VARCHAR(255),
                image VARCHAR(255),
                calories FLOAT,
                date VARCHAR(255),
                FOREIGN KEY (user_id) REFERENCES users(user_id)
            );
            """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to create table: \(errorMessage)")
        } else {
            print("Table 'plan_food' checked/created successfully.")
        }
    }
    
    private func createShopingFoodTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS shoping (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                idShoping INTEGER,
                user_id VARCHAR(255),
                name VARCHAR(255),
                original VARCHAR(255),
                FOREIGN KEY (user_id) REFERENCES users(user_id)
            );
            """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to create table: \(errorMessage)")
        } else {
            print("Table 'shoping' checked/created successfully.")
        }
    }
    
    func addFavorite(user_id: String, id: Int, title: String, image: String) {
        guard !title.isEmpty, !image.isEmpty else {
            print("Error: Title or Image is empty.")
            return
        }
        
        let insertQuery = "INSERT INTO favorites (idRecipe, user_id, title, image) VALUES (\(id), '\(user_id)', '\(title)', '\(image)');"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully added favorite with idRecipe: \(id) for user_id: \(user_id)")
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
    
    
    func removeFavorite(userId: String, id: Int) {
        let deleteQuery = "DELETE FROM favorites WHERE idRecipe = \(id) AND user_id = '\(userId)';"
        
        print("Preparing to remove favorite item with idRecipe: \(id) for user \(userId).")
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully removed favorite with idRecipe: \(id) for user \(userId)")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to remove favorite: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }

    
    func isFavorite(userId: String, id: Int) -> Bool {
        let selectQuery = "SELECT idRecipe FROM favorites WHERE idRecipe = \(id) AND user_id = '\(userId)';"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            print("Checking if idRecipe \(id) for user \(userId) is in favorites.")
            
            if sqlite3_step(statement) == SQLITE_ROW {
                print("idRecipe \(id) for user \(userId) is found in favorites.")
                sqlite3_finalize(statement)
                return true
            } else {
                print("idRecipe \(id) for user \(userId) is NOT found in favorites.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        return false
    }

    
    func getAllFavorites(user_id: String) -> [FavoriteFood] {
        var favoriteFoods: [FavoriteFood] = []
        
        let selectQuery = "SELECT idRecipe, title, image FROM favorites WHERE user_id = '\(user_id)';"
        var statement: OpaquePointer?
        
        print("Executing query to get all favorites for user_id: \(user_id)")
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            print("Query prepared successfully.")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let idRecipe = sqlite3_column_int(statement, 0)
                let rawTitle = sqlite3_column_text(statement, 1)
                let rawImage = sqlite3_column_text(statement, 2)
                
                let title = rawTitle != nil ? String(cString: rawTitle!) : nil
                let image = rawImage != nil ? String(cString: rawImage!) : nil
                
                let favorite = FavoriteFood(idRecipe: Int(idRecipe), title: title, image: image)
                favoriteFoods.append(favorite)
            }
            
            print("Total favorites fetched: \(favoriteFoods.count)")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        print("Returning \(favoriteFoods.count) favorite foods.")
        return favoriteFoods
    }

    
    func addPlanFood(user_id: String, id: Int, title: String, image: String, calories: Float, date: String) {
        guard !title.isEmpty, !image.isEmpty else {
            print("Error: Title or Image is empty.")
            return
        }
        
        print("Inserting plan food with the following data:")
        print("idRecipe: \(id), user_id: \(user_id), title: \(title), image: \(image), calories: \(calories), date: \(date)")
        
        let insertQuery = """
        INSERT INTO plan_food (idRecipe, user_id, title, image, calories, date)
        VALUES (\(id), '\(user_id)', '\(title)', '\(image)', \(calories), '\(date)');
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully added plan food with idRecipe: \(id) for user_id: \(user_id)")
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

    
    func getAllPlanFood(forUser userId: String) -> [PlanFood] {
        var planFoods: [PlanFood] = []
        
        let selectQuery = "SELECT idRecipe, title, image, calories, date FROM plan_food WHERE user_id = '\(userId)';"
        
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
        return planFoods
    }

    
    func getPlanFoodByDateRange(forUser userId: String, startDate: Date, endDate: Date) -> [PlanFood] {
        var planFoods: [PlanFood] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        // Format tanggal menjadi string
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        // Log informasi tanggal yang digunakan untuk query
        print("Fetching plan food for user \(userId) between \(startDateString) and \(endDateString).")
        
        let selectQuery = """
        SELECT idRecipe, title, image, calories, date
        FROM plan_food
        WHERE user_id = '\(userId)' AND date BETWEEN '\(startDateString)' AND '\(endDateString)';
        """
        
        // Log query yang dijalankan
        print("SQL Query: \(selectQuery)")
        
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            
            // Log jika statement berhasil dipersiapkan
            print("Statement prepared successfully.")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let idRecipe = sqlite3_column_int(statement, 0)
                let rawTitle = sqlite3_column_text(statement, 1)
                let rawImage = sqlite3_column_text(statement, 2)
                let calories = sqlite3_column_double(statement, 3)
                let rawDate = sqlite3_column_text(statement, 4)
                
                let title = rawTitle != nil ? String(cString: rawTitle!) : nil
                let image = rawImage != nil ? String(cString: rawImage!) : nil
                let date = rawDate != nil ? String(cString: rawDate!) : nil
                
                // Log hasil yang diambil dari query
                print("Found plan food: idRecipe = \(idRecipe), title = \(title ?? "N/A"), image = \(image ?? "N/A"), calories = \(calories), date = \(date ?? "N/A")")
                
                let planFood = PlanFood(idRecipe: Int(idRecipe), title: title, image: image, calories: Float(calories), date: date)
                planFoods.append(planFood)
            }
            
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }

        sqlite3_finalize(statement)
        
        // Log jumlah data yang ditemukan
        print("Total plan foods found: \(planFoods.count)")
        
        return planFoods
    }


    
    func deletePlanFood(forUser userId: String, byId id: Int) {
        let deleteQuery = "DELETE FROM plan_food WHERE idRecipe = ? AND user_id = ?;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            sqlite3_bind_text(statement, 2, userId, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted plan food with id \(id) for user \(userId).")
            } else {
                print("Failed to delete plan food. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prepare delete statement. Error: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(statement)
    }
    
    func addShoppingItem(userId: String, id: Int, name: String, original: String) {
        guard !name.isEmpty, !original.isEmpty else {
            print("Error: Name or Original is empty.")
            return
        }

        let insertQuery = "INSERT INTO shoping (idShoping, user_id, name, original) VALUES (\(id), '\(userId)', '\(name)', '\(original)');"

        print("Preparing to insert shopping item into database...")
        print("Data to insert - id: \(id), userId: \(userId), name: \(name), original: \(original)")

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully added shopping item: \(name) for user \(userId).")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to add shopping item: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }

        sqlite3_finalize(statement)
    }

    
    func getAllShoppingItems(forUser userId: String) -> [Shoping] {
        var shoppingItems: [Shoping] = []
        let selectQuery = "SELECT id, name, original FROM shoping WHERE user_id = '\(userId)';"
        var statement: OpaquePointer?

        print("Executing query for user_id: \(userId)")

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let rawName = sqlite3_column_text(statement, 1)
                let rawOriginal = sqlite3_column_text(statement, 2)

                let name = rawName != nil ? String(cString: rawName!) : "Unknown"
                let original = rawOriginal != nil ? String(cString: rawOriginal!) : "Unknown"
                
                print("Found item - ID: \(id), Name: \(name), Original: \(original)")

                let shoppingItem = Shoping(id: Int(id), name: name, original: original)
                shoppingItems.append(shoppingItem)
            }

            print("Found \(shoppingItems.count) shopping items.")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to prepare statement: \(errorMessage)")
        }

        sqlite3_finalize(statement)
        return shoppingItems
    }


    
    func deleteShoppingItem(byId id: Int) {
        let deleteQuery = "DELETE FROM shoping WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted shopping item with id \(id).")
            } else {
                print("Failed to delete shopping item. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prepare delete statement. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(statement)
    }

    
    deinit {
        sqlite3_close(db)
        print("Database connection closed.")
    }
}
