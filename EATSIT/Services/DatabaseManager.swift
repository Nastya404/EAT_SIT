//
//  DatabaseManager.swift
//  EATSIT
//
//  Created by Shamruk_Polina on 15.05.2026.
//

import Foundation
import SQLite3

final class DatabaseManager {

    // MARK: - Properties

    static let shared = DatabaseManager()

    private var database: OpaquePointer?
    private let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    // MARK: - Initialization

    private init() {
        openDatabase()
        createTables()
        seedInitialDataIfNeeded()
    }

    // MARK: - Database Path

    private var databasePath: String {
        let fileManager = FileManager.default

        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documentsURL
            .appendingPathComponent("eatsit.sqlite")
            .path
    }

    // MARK: - Open Database

    private func openDatabase() {

        if sqlite3_open(databasePath, &database) != SQLITE_OK {
            print("Unable to open database")
        }
    }

    // MARK: - Create Tables

    private func createTables() {

        let createRestaurantsTable = """
        CREATE TABLE IF NOT EXISTS restaurants (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            image_name TEXT NOT NULL,
            rating REAL NOT NULL,
            delivery_time TEXT NOT NULL,
            delivery_price TEXT NOT NULL,
            is_popular INTEGER NOT NULL,
            category TEXT NOT NULL,
            latitude REAL,
            longitude REAL
        );
        """

        let createDishesTable = """
        CREATE TABLE IF NOT EXISTS dishes (
            id TEXT PRIMARY KEY,
            restaurant_id TEXT NOT NULL,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            image_name TEXT NOT NULL,
            category TEXT NOT NULL,
            restaurant_name TEXT NOT NULL,
            FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
        );
        """

        execute(createRestaurantsTable)
        execute(createDishesTable)
    }

    // MARK: - Execute Query

    private func execute(_ query: String) {

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
        } else {
            print("Query preparation failed")
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Seed Initial Data

    private func seedInitialDataIfNeeded() {

        if !fetchRestaurants().isEmpty {
            return
        }

        MockData.restaurants.forEach {
            insertRestaurant($0)
        }

        MockData.dishes.forEach {
            insertDish($0)
        }
    }

    // MARK: - Insert Restaurant

    func insertRestaurant(_ restaurant: Restaurant) {

        let query = """
        INSERT OR REPLACE INTO restaurants
        (id, name, image_name, rating, delivery_time, delivery_price, is_popular, category, latitude, longitude)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, restaurant.id, -1, transient)
            sqlite3_bind_text(statement, 2, restaurant.name, -1, transient)
            sqlite3_bind_text(statement, 3, restaurant.imageName, -1, transient)
            sqlite3_bind_double(statement, 4, restaurant.rating)
            sqlite3_bind_text(statement, 5, restaurant.deliveryTime, -1, transient)
            sqlite3_bind_text(statement, 6, restaurant.deliveryPrice, -1, transient)
            sqlite3_bind_int(statement, 7, restaurant.isPopular ? 1 : 0)
            sqlite3_bind_text(statement, 8, restaurant.category, -1, transient)
            sqlite3_bind_double(statement, 9, restaurant.latitude)
            sqlite3_bind_double(statement, 10, restaurant.longitude)

            sqlite3_step(statement)
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Insert Dish

    func insertDish(_ dish: Dish) {

        let query = """
        INSERT OR REPLACE INTO dishes
        (id, restaurant_id, name, description, price, image_name, category, restaurant_name)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, dish.id, -1, transient)
            sqlite3_bind_text(statement, 2, dish.restaurantId, -1, transient)
            sqlite3_bind_text(statement, 3, dish.name, -1, transient)
            sqlite3_bind_text(statement, 4, dish.description, -1, transient)
            sqlite3_bind_double(statement, 5, dish.price)
            sqlite3_bind_text(statement, 6, dish.imageName, -1, transient)
            sqlite3_bind_text(statement, 7, dish.category, -1, transient)
            sqlite3_bind_text(statement, 8, dish.restaurantName, -1, transient)

            sqlite3_step(statement)
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Fetch Restaurants

    func fetchRestaurants() -> [Restaurant] {

        let query = """
        SELECT id, name, image_name, rating, delivery_time, delivery_price, is_popular, category, latitude, longitude
        FROM restaurants;
        """

        var restaurants: [Restaurant] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {

                let restaurant = Restaurant(
                    id: String(cString: sqlite3_column_text(statement, 0)),
                    name: String(cString: sqlite3_column_text(statement, 1)),
                    imageName: String(cString: sqlite3_column_text(statement, 2)),
                    rating: sqlite3_column_double(statement, 3),
                    deliveryTime: String(cString: sqlite3_column_text(statement, 4)),
                    deliveryPrice: String(cString: sqlite3_column_text(statement, 5)),
                    isPopular: sqlite3_column_int(statement, 6) == 1,
                    category: String(cString: sqlite3_column_text(statement, 7)),
                    latitude: sqlite3_column_double(statement, 8),
                    longitude: sqlite3_column_double(statement, 9)
                )

                restaurants.append(restaurant)
            }
        }

        sqlite3_finalize(statement)
        return restaurants
    }

    // MARK: - Fetch Dishes

    func fetchDishes() -> [Dish] {

        let query = """
        SELECT id, restaurant_id, name, description, price, image_name, category, restaurant_name
        FROM dishes;
        """

        var dishes: [Dish] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {

                let dish = Dish(
                    id: String(cString: sqlite3_column_text(statement, 0)),
                    restaurantId: String(cString: sqlite3_column_text(statement, 1)),
                    name: String(cString: sqlite3_column_text(statement, 2)),
                    description: String(cString: sqlite3_column_text(statement, 3)),
                    price: sqlite3_column_double(statement, 4),
                    imageName: String(cString: sqlite3_column_text(statement, 5)),
                    category: String(cString: sqlite3_column_text(statement, 6)),
                    restaurantName: String(cString: sqlite3_column_text(statement, 7))
                )

                dishes.append(dish)
            }
        }

        sqlite3_finalize(statement)
        return dishes
    }

    // MARK: - Fetch Dishes For Restaurant

    func fetchDishes(for restaurant: Restaurant) -> [Dish] {

        fetchDishes().filter {
            $0.restaurantId == restaurant.id
        }
    }
}
