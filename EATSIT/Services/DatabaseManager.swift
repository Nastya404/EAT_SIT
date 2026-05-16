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
    private let databaseName = "eatsit.sqlite"
    private let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    // MARK: - Initialization

    private init() {
        copyDatabaseIfNeeded()
        openDatabase()
    }

    // MARK: - Database Path

    private var databasePath: String {

        let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documentsURL
            .appendingPathComponent(databaseName)
            .path
    }

    // MARK: - Copy Database

    private func copyDatabaseIfNeeded() {

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: databasePath) {
            return
        }

        guard let bundlePath = Bundle.main.path(
            forResource: "eatsit",
            ofType: "sqlite"
        ) else {
            print("Database file not found in bundle")
            return
        }

        do {
            try fileManager.copyItem(
                atPath: bundlePath,
                toPath: databasePath
            )
        } catch {
            print("Database copy error: \(error.localizedDescription)")
        }
    }

    // MARK: - Open Database

    private func openDatabase() {

        if sqlite3_open(databasePath, &database) != SQLITE_OK {
            print("Unable to open database")
        }
    }

    // MARK: - Fetch Restaurants

    func fetchRestaurants() -> [Restaurant] {

        let query = """
        SELECT
            r.id,
            r.name,
            r.image_name,
            r.rating,
            r.is_popular,
            r.category,
            l.latitude,
            l.longitude
        FROM restaurants r
        LEFT JOIN restaurant_locations l
        ON r.id = l.restaurant_id
        GROUP BY r.id;
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
                    deliveryTime: "20-35 min",
                    deliveryPrice: "2.99 BYN Delivery",
                    isPopular: sqlite3_column_int(statement, 4) == 1,
                    category: String(cString: sqlite3_column_text(statement, 5)),
                    latitude: sqlite3_column_double(statement, 6),
                    longitude: sqlite3_column_double(statement, 7)
                )

                restaurants.append(restaurant)
            }
        } else {
            print("Fetch restaurants query preparation failed")
        }

        sqlite3_finalize(statement)
        return restaurants
    }

    // MARK: - Fetch Restaurant Locations

    func fetchLocations(for restaurant: Restaurant) -> [RestaurantLocation] {

        let query = """
        SELECT id, restaurant_id, address, latitude, longitude
        FROM restaurant_locations
        WHERE restaurant_id = ?;
        """

        var locations: [RestaurantLocation] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {

            sqlite3_bind_text(statement, 1, restaurant.id, -1, transient)

            while sqlite3_step(statement) == SQLITE_ROW {

                let location = RestaurantLocation(
                    id: String(cString: sqlite3_column_text(statement, 0)),
                    restaurantId: String(cString: sqlite3_column_text(statement, 1)),
                    address: String(cString: sqlite3_column_text(statement, 2)),
                    latitude: sqlite3_column_double(statement, 3),
                    longitude: sqlite3_column_double(statement, 4)
                )

                locations.append(location)
            }
        } else {
            print("Fetch restaurant locations query preparation failed")
        }

        sqlite3_finalize(statement)
        return locations
    }

    // MARK: - Fetch Dishes

    func fetchDishes() -> [Dish] {

        let query = """
        SELECT
            d.id,
            d.restaurant_id,
            d.name,
            d.description,
            d.price,
            d.image_name,
            d.category,
            r.name
        FROM dishes d
        INNER JOIN restaurants r
        ON d.restaurant_id = r.id;
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
        } else {
            print("Fetch dishes query preparation failed")
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
        } else {
            print("Insert order query preparation failed")
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
        } else {
            print("Insert order item query preparation failed")
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
        } else {
            print("Fetch orders query preparation failed")
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
        } else {
            print("Fetch order items query preparation failed")
        }

        sqlite3_finalize(statement)
        return items
    }
}
