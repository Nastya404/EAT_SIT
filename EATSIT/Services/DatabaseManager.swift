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
        
        let createOrdersTable = """
        CREATE TABLE IF NOT EXISTS orders (
            id TEXT PRIMARY KEY,
            delivery_address TEXT NOT NULL,
            comment TEXT,
            payment_method TEXT NOT NULL,
            total_price REAL NOT NULL,
            status TEXT NOT NULL,
            created_at REAL NOT NULL
        );
        """

        let createOrderItemsTable = """
        CREATE TABLE IF NOT EXISTS order_items (
            id TEXT PRIMARY KEY,
            order_id TEXT NOT NULL,
            dish_id TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            total_price REAL NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders(id),
            FOREIGN KEY (dish_id) REFERENCES dishes(id)
        );
        """

        execute(createRestaurantsTable)
        execute(createDishesTable)
        execute(createOrdersTable)
        execute(createOrderItemsTable)
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
    
    // MARK: - Insert Order

    func insertOrder(_ order: Order) {

        let query = """
        INSERT OR REPLACE INTO orders
        (id, delivery_address, comment, payment_method, total_price, status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, order.id.uuidString, -1, transient)
            sqlite3_bind_text(statement, 2, order.deliveryAddress, -1, transient)
            sqlite3_bind_text(statement, 3, order.comment, -1, transient)
            sqlite3_bind_text(statement, 4, order.paymentMethod.rawValue, -1, transient)
            sqlite3_bind_double(statement, 5, order.totalPrice)
            sqlite3_bind_text(statement, 6, order.status, -1, transient)
            sqlite3_bind_double(statement, 7, order.createdAt.timeIntervalSince1970)

            sqlite3_step(statement)
        }

        sqlite3_finalize(statement)

        order.items.forEach {
            insertOrderItem($0, orderId: order.id.uuidString)
        }
    }

    // MARK: - Insert Order Item

    private func insertOrderItem(_ item: CartItem, orderId: String) {

        let query = """
        INSERT OR REPLACE INTO order_items
        (id, order_id, dish_id, quantity, total_price)
        VALUES (?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, item.id.uuidString, -1, transient)
            sqlite3_bind_text(statement, 2, orderId, -1, transient)
            sqlite3_bind_text(statement, 3, item.dish.id, -1, transient)
            sqlite3_bind_int(statement, 4, Int32(item.quantity))
            sqlite3_bind_double(statement, 5, item.totalPrice)

            sqlite3_step(statement)
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Fetch Orders

    func fetchOrders() -> [Order] {

        let query = """
        SELECT id, delivery_address, comment, payment_method, total_price, status, created_at
        FROM orders
        ORDER BY created_at DESC;
        """

        var orders: [Order] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {

                let orderId = String(cString: sqlite3_column_text(statement, 0))
                let deliveryAddress = String(cString: sqlite3_column_text(statement, 1))
                let comment = String(cString: sqlite3_column_text(statement, 2))
                let paymentMethodRaw = String(cString: sqlite3_column_text(statement, 3))
                let totalPrice = sqlite3_column_double(statement, 4)
                let status = String(cString: sqlite3_column_text(statement, 5))
                let createdAt = Date(
                    timeIntervalSince1970: sqlite3_column_double(statement, 6)
                )

                let paymentMethod = PaymentMethod(rawValue: paymentMethodRaw) ?? .cash
                let items = fetchOrderItems(orderId: orderId)

                let order = Order(
                    items: items,
                    deliveryAddress: deliveryAddress,
                    comment: comment,
                    paymentMethod: paymentMethod,
                    totalPrice: totalPrice,
                    status: status,
                    createdAt: createdAt
                )

                orders.append(order)
            }
        }

        sqlite3_finalize(statement)
        return orders
    }

    // MARK: - Fetch Order Items

    private func fetchOrderItems(orderId: String) -> [CartItem] {

        let query = """
        SELECT dish_id, quantity
        FROM order_items
        WHERE order_id = ?;
        """

        var items: [CartItem] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, orderId, -1, transient)

            while sqlite3_step(statement) == SQLITE_ROW {

                let dishId = String(cString: sqlite3_column_text(statement, 0))
                let quantity = Int(sqlite3_column_int(statement, 1))

                if let dish = fetchDishes().first(where: { $0.id == dishId }) {

                    let item = CartItem(
                        dish: dish,
                        quantity: quantity,
                        selectedToppings: []
                    )

                    items.append(item)
                }
            }
        }

        sqlite3_finalize(statement)
        return items
    }
}
