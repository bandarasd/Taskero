//
//  MockData.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import Foundation
import SwiftUI

struct MockData {
    
    // MARK: - Workers
    static let workers: [Worker] = [
        Worker(name: "Andrew Sirolin", rating: 4.9, reviewCount: 890, profileImage: "worker_1"),
        Worker(name: "Jenny Wilson", rating: 4.8, reviewCount: 756, profileImage: "worker_2"),
        Worker(name: "Wade Warren", rating: 4.6, reviewCount: 520, profileImage: "worker_3"),
        Worker(name: "Guy Hawkins", rating: 4.8, reviewCount: 650, profileImage: "worker_4"),
        Worker(name: "Robert Fox", rating: 4.5, reviewCount: 380, profileImage: "worker_5"),
        Worker(name: "Albert Flores", rating: 4.7, reviewCount: 420, profileImage: "worker_6"),
        Worker(name: "Kristin Watson", rating: 4.9, reviewCount: 1120, profileImage: "worker_7"),
        Worker(name: "Devon Lane", rating: 4.4, reviewCount: 290, profileImage: "worker_8"),
        Worker(name: "Marvin McKinney", rating: 4.7, reviewCount: 610, profileImage: "worker_9"),
        Worker(name: "Eleanor Pena", rating: 4.8, reviewCount: 840, profileImage: "worker_10"),
        Worker(name: "Cameron Williamson", rating: 4.6, reviewCount: 470, profileImage: "worker_11"),
        Worker(name: "Savannah Nguyen", rating: 4.9, reviewCount: 950, profileImage: "worker_12")
    ]
    
    // MARK: - Bookings
    static let bookings: [Booking] = [
        // ONGOING (4 bookings)
        Booking(serviceName: "Plumbing", category: "Plumbing", providerName: "Wade Warren", date: Date(), time: "03:00 PM", status: .ongoing, price: 95.00, imageName: "plumbing_service", imageColor: .cyan, providerImage: "worker_3"),
        Booking(serviceName: "Electrician", category: "Electrical", providerName: "Marvin McKinney", date: Date().addingTimeInterval(-3600), time: "01:00 PM", status: .ongoing, price: 110.00, imageName: "ac_repair_service", imageColor: .yellow, providerImage: "worker_9"),
        Booking(serviceName: "Appliance Repair", category: "Repairing", providerName: "Cameron Williamson", date: Date().addingTimeInterval(-7200), time: "11:00 AM", status: .ongoing, price: 85.00, imageName: "ac_repair_service", imageColor: .orange, providerImage: "worker_11"),
        Booking(serviceName: "Carpet Cleaning", category: "Cleaning", providerName: "Savannah Nguyen", date: Date().addingTimeInterval(-1800), time: "02:30 PM", status: .ongoing, price: 120.00, imageName: "cleaning_service", imageColor: .brandGreen, providerImage: "worker_12"),
        
        // UPCOMING (5 bookings)
        Booking(serviceName: "House Cleaning", category: "Cleaning", providerName: "Jenny Wilson", date: Date().addingTimeInterval(86400), time: "10:00 AM", status: .upcoming, price: 87.50, imageName: "cleaning_service", imageColor: .brandGreen, providerImage: "worker_2"),
        Booking(serviceName: "Laundry", category: "Laundry", providerName: "Albert Flores", date: Date().addingTimeInterval(86400 * 3), time: "11:00 AM", status: .upcoming, price: 45.00, imageName: "cleaning_service", imageColor: .purple, providerImage: "worker_6"),
        Booking(serviceName: "Furniture Assembly", category: "Assembly", providerName: "Devon Lane", date: Date().addingTimeInterval(86400 * 2), time: "04:00 PM", status: .upcoming, price: 75.00, imageName: "painting_service", imageColor: .brown, providerImage: "worker_8"),
        Booking(serviceName: "Gardening", category: "Outdoor", providerName: "Eleanor Pena", date: Date().addingTimeInterval(86400 * 5), time: "08:00 AM", status: .upcoming, price: 130.00, imageName: "cleaning_service", imageColor: .green, providerImage: "worker_10"),
        Booking(serviceName: "Window Cleaning", category: "Cleaning", providerName: "Kristin Watson", date: Date().addingTimeInterval(86400 * 7), time: "09:30 AM", status: .upcoming, price: 65.00, imageName: "cleaning_service", imageColor: .cyan, providerImage: "worker_7"),
        
        // COMPLETED (4 bookings)
        Booking(serviceName: "AC Repair", category: "Repairing", providerName: "Guy Hawkins", date: Date().addingTimeInterval(-86400 * 2), time: "02:00 PM", status: .completed, price: 120.00, imageName: "ac_repair_service", imageColor: .orange, userRating: 5, providerImage: "worker_4"),
        Booking(serviceName: "Deep Cleaning", category: "Cleaning", providerName: "Andrew Sirolin", date: Date().addingTimeInterval(-86400 * 7), time: "09:00 AM", status: .completed, price: 150.00, imageName: "cleaning_service", imageColor: .brandGreen, userRating: 5, providerImage: "worker_1"),
        Booking(serviceName: "Pest Control", category: "Pest Control", providerName: "Marvin McKinney", date: Date().addingTimeInterval(-86400 * 14), time: "10:00 AM", status: .completed, price: 95.00, imageName: "ac_repair_service", imageColor: .red, userRating: 4, providerImage: "worker_9"),
        Booking(serviceName: "Handyman Service", category: "Repair", providerName: "Wade Warren", date: Date().addingTimeInterval(-86400 * 4), time: "03:00 PM", status: .completed, price: 80.00, imageName: "ac_repair_service", imageColor: .gray, providerImage: "worker_3"), // Not reviewed
        
        // CANCELLED (2 bookings)
        Booking(serviceName: "Painting", category: "Painting", providerName: "Robert Fox", date: Date().addingTimeInterval(-86400 * 5), time: "09:00 AM", status: .canceled, price: 250.00, imageName: "painting_service", imageColor: .blue, providerImage: "worker_5"),
        Booking(serviceName: "Moving Service", category: "Moving", providerName: "Devon Lane", date: Date().addingTimeInterval(-86400 * 10), time: "07:00 AM", status: .canceled, price: 300.00, imageName: "painting_service", imageColor: .orange, providerImage: "worker_8")
    ]
    
    // MARK: - Current User
    static let currentUser = (
        name: "Mark Robinson",
        phone: "(201) 555-0123",
        address: "Washington Ave, Manchester, Kentucky 39495"
    )
    
    // MARK: - Categories
    static let categories: [CategoryItem] = [
        CategoryItem(name: "Carpenter", icon: "ic_carpenter", isSystemImage: false, color: .white, backgroundColor: .orange),
        CategoryItem(name: "Cleaner", icon: "ic_cleaner", isSystemImage: false, color: .white, backgroundColor: .blue),
        CategoryItem(name: "Painter", icon: "ic_painter", isSystemImage: false, color: .white, backgroundColor: .green),
        CategoryItem(name: "Electrician", icon: "ic_electrician", isSystemImage: false, color: .white, backgroundColor: .yellow),
        CategoryItem(name: "Mover", icon: "ic_mover", isSystemImage: false, color: .white, backgroundColor: .pink),
        CategoryItem(name: "AC Repair", icon: "ic_ac_repair", isSystemImage: false, color: .white, backgroundColor: .cyan),
        CategoryItem(name: "Plumber", icon: "ic_plumber", isSystemImage: false, color: .white, backgroundColor: .red),
        CategoryItem(name: "Gardener", icon: "ic_gardener", isSystemImage: false, color: .white, backgroundColor: .purple)
    ]
    
    // MARK: - Services Sections
    static let bestServices: [ServiceItem] = [
        ServiceItem(title: "Complete Kitchen Cleaning", price: "$150", originalPrice: "$180", rating: "(130 Reviews)", provider: "Mark Willions", imageColor: .orange, imageName: "cleaning_service", images: ["cleaning_service", "living_room_service", "ac_repair_service"], type: .cleaning),
        ServiceItem(title: "Living Room Cleaning", price: "$200", originalPrice: "$230", rating: "(240 Reviews)", provider: "Ronald Mark", imageColor: .blue, imageName: "living_room_service", images: ["living_room_service", "cleaning_service"], type: .cleaning),
        ServiceItem(title: "AC Service & Repair", price: "$50", originalPrice: "$120", rating: "(100 Reviews)", provider: "James", imageColor: .cyan, imageName: "ac_repair_service", images: ["ac_repair_service", "electrician_service"], type: .repairing)
    ]
    
    static let kitchenCleaningServices: [ServiceItem] = [
        ServiceItem(title: "Deep Kitchen Clean", price: "$120", originalPrice: "$150", rating: "(80 Reviews)", provider: "Sarah Jones", imageColor: .orange, imageName: "cleaning_service", images: ["cleaning_service", "living_room_service"], type: .cleaning),
        ServiceItem(title: "Sink Repair & Clean", price: "$90", originalPrice: "$110", rating: "(45 Reviews)", provider: "Mike Ross", imageColor: .purple, imageName: "plumbing_service", images: ["plumbing_service", "cleaning_service"], type: .plumbing),
        ServiceItem(title: "Cabinet Degreasing", price: "$200", originalPrice: "$250", rating: "(20 Reviews)", provider: "CleanCo", imageColor: .green, imageName: "cleaning_service", images: ["cleaning_service", "painting_service"], type: .cleaning)
    ]
    
    static let plumbingServices: [ServiceItem] = [
        ServiceItem(title: "Pipe Leak Fix", price: "$60", originalPrice: "$90", rating: "(200 Reviews)", provider: "Mario Bros", imageColor: .red, imageName: "plumbing_service", images: ["plumbing_service", "ac_repair_service"], type: .plumbing),
        ServiceItem(title: "Water Heater Install", price: "$300", originalPrice: "$350", rating: "(15 Reviews)", provider: "HotWater Inc", imageColor: .orange, imageName: "plumbing_service", images: ["plumbing_service"], type: .plumbing),
        ServiceItem(title: "Drain Unclogging", price: "$80", originalPrice: "$100", rating: "(330 Reviews)", provider: "FastPlumb", imageColor: .blue, imageName: "plumbing_service", images: ["plumbing_service"], type: .plumbing)
    ]
    
    static let homeMaintenanceServices: [ServiceItem] = [
        ServiceItem(title: "Wall Painting", price: "$500", originalPrice: "$600", rating: "(50 Reviews)", provider: "ColorWorld", imageColor: .green, imageName: "painting_service", images: ["painting_service", "cleaning_service"], type: .painting),
        ServiceItem(title: "Furniture Assembly", price: "$100", originalPrice: "$120", rating: "(90 Reviews)", provider: "FixItAll", imageColor: .yellow, imageName: "living_room_service", images: ["living_room_service", "painting_service"], type: .assembly),
        ServiceItem(title: "Electric Wiring", price: "$150", originalPrice: "$180", rating: "(110 Reviews)", provider: "Sparky", imageColor: .orange, imageName: "electrician_service", images: ["electrician_service", "ac_repair_service"], type: .electrician)
    ]
    
    // MARK: - Reviews
    struct ReviewModel: Identifiable {
        let id = UUID()
        let reviewerName: String
        let comment: String
        let rating: Int
        let likes: Int
        let timeAgo: String
        let reviewerImage: String?
        let reviewImages: [String]?
    }
    
    static let reviews: [ReviewModel] = [
        ReviewModel(reviewerName: "Lauralee Quintero", comment: "Awesome! this is what i was looking for, i recommend to everyone ❤️❤️❤️", rating: 5, likes: 724, timeAgo: "3 weeks ago", reviewerImage: "reviewer_1", reviewImages: ["cleaning_service", "ac_repair_service"]),
        ReviewModel(reviewerName: "John Doe", comment: "Great service, very professional and on time.", rating: 5, likes: 124, timeAgo: "1 month ago", reviewerImage: "reviewer_2", reviewImages: nil),
        ReviewModel(reviewerName: "Annabel Rohan", comment: "Good job but arrived a bit late.", rating: 4, likes: 45, timeAgo: "2 months ago", reviewerImage: "reviewer_3", reviewImages: ["plumbing_service"]),
        ReviewModel(reviewerName: "Sarah Miller", comment: "The kitchen cleaning was deep and thorough. Very satisfied!", rating: 5, likes: 89, timeAgo: "1 week ago", reviewerImage: "reviewer_1", reviewImages: ["cleaning_service", "painting_service"])
    ]

    // MARK: - Order Details
    static let orderDetails: [OrderDetail] = [
        // ONGOING Orders
        OrderDetail(
            orderId: "HOV01203454",
            booking: bookings[0], // Plumbing
            status: .inProgress,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[2], // Wade Warren
            subtotal: 94.00,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date(),
            paymentDateTime: Date(),
            duration: "2 hours, 03:00 to 05:00 PM",
            workload: "Kitchen sink repair",
            addOnService: nil,
            houseWithPet: nil,
            taskerGender: "Male",
            noteForWorker: "Kitchen sink is leaking, please fix as soon as possible"
        ),
        OrderDetail(
            orderId: "HOV01203460",
            booking: bookings[1], // Electrician
            status: .inProgress,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[8], // Marvin McKinney
            subtotal: 109.00,
            serviceFee: 1.00,
            paymentMethod: "Visa",
            orderDateTime: Date().addingTimeInterval(-3600),
            paymentDateTime: Date().addingTimeInterval(-3600),
            duration: "3 hours, 01:00 to 04:00 PM",
            workload: "Electrical panel upgrade",
            addOnService: "Circuit testing",
            houseWithPet: "Cat",
            taskerGender: "Male",
            noteForWorker: "Need to upgrade main electrical panel"
        ),
        OrderDetail(
            orderId: "HOV01203461",
            booking: bookings[2], // Appliance Repair
            status: .inProgress,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[10], // Cameron Williamson
            subtotal: 84.00,
            serviceFee: 1.00,
            paymentMethod: "Apple Pay",
            orderDateTime: Date().addingTimeInterval(-7200),
            paymentDateTime: Date().addingTimeInterval(-7200),
            duration: "1.5 hours, 11:00 AM to 12:30 PM",
            workload: "Washing machine repair",
            addOnService: nil,
            houseWithPet: nil,
            taskerGender: nil,
            noteForWorker: nil
        ),
        OrderDetail(
            orderId: "HOV01203462",
            booking: bookings[3], // Carpet Cleaning
            status: .inProgress,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[11], // Savannah Nguyen
            subtotal: 119.00,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(-1800),
            paymentDateTime: Date().addingTimeInterval(-1800),
            duration: "2 hours, 02:30 to 04:30 PM",
            workload: "3 rooms, 800 sq ft",
            addOnService: "Stain removal",
            houseWithPet: "Dog",
            taskerGender: "Female",
            noteForWorker: "Please be careful with Persian rug in living room"
        ),
        
        // UPCOMING Orders
        OrderDetail(
            orderId: "HOV01203450",
            booking: bookings[4], // House Cleaning
            status: .created,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[1], // Jenny Wilson
            subtotal: 86.50,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(86400),
            paymentDateTime: Date().addingTimeInterval(86400),
            duration: "2 hours, 10:00 AM to 12:00 PM",
            workload: "55m²/2100ft²",
            addOnService: "Ironing",
            houseWithPet: "Dog",
            taskerGender: "Female",
            noteForWorker: "Clean 3 room, 2 bedroom, 1 kitchen, be careful while cleaning wooden floor"
        ),
        OrderDetail(
            orderId: "HOV01203453",
            booking: bookings[5], // Laundry
            status: .readyForService,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[5], // Albert Flores
            subtotal: 44.00,
            serviceFee: 1.00,
            paymentMethod: "Visa",
            orderDateTime: Date().addingTimeInterval(86400 * 3),
            paymentDateTime: Date().addingTimeInterval(86400 * 3),
            duration: "1 hour, 11:00 AM to 12:00 PM",
            workload: "15kg",
            addOnService: "Ironing",
            houseWithPet: nil,
            taskerGender: "Male",
            noteForWorker: nil
        ),
        OrderDetail(
            orderId: "HOV01203455",
            booking: bookings[6], // Furniture Assembly
            status: .created,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[7], // Devon Lane
            subtotal: 74.00,
            serviceFee: 1.00,
            paymentMethod: "Google Pay",
            orderDateTime: Date().addingTimeInterval(86400 * 2),
            paymentDateTime: Date().addingTimeInterval(86400 * 2),
            duration: "3 hours, 04:00 to 07:00 PM",
            workload: "IKEA wardrobe + desk",
            addOnService: nil,
            houseWithPet: "Cat",
            taskerGender: "Male",
            noteForWorker: "Assembly instructions are in the boxes"
        ),
        OrderDetail(
            orderId: "HOV01203456",
            booking: bookings[7], // Gardening
            status: .created,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[9], // Eleanor Pena
            subtotal: 129.00,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(86400 * 5),
            paymentDateTime: Date().addingTimeInterval(86400 * 5),
            duration: "4 hours, 08:00 AM to 12:00 PM",
            workload: "Front and back yard",
            addOnService: "Hedge trimming",
            houseWithPet: nil,
            taskerGender: "Female",
            noteForWorker: "Please water the plants after trimming"
        ),
        OrderDetail(
            orderId: "HOV01203457",
            booking: bookings[8], // Window Cleaning
            status: .readyForService,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[6], // Kristin Watson
            subtotal: 64.00,
            serviceFee: 1.00,
            paymentMethod: "Visa",
            orderDateTime: Date().addingTimeInterval(86400 * 7),
            paymentDateTime: Date().addingTimeInterval(86400 * 7),
            duration: "1.5 hours, 09:30 to 11:00 AM",
            workload: "12 windows",
            addOnService: nil,
            houseWithPet: nil,
            taskerGender: "Female",
            noteForWorker: nil
        ),
        
        // COMPLETED Orders
        OrderDetail(
            orderId: "HOV01203451",
            booking: bookings[9], // AC Repair
            status: .done,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[3], // Guy Hawkins
            subtotal: 119.00,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(-86400 * 2),
            paymentDateTime: Date().addingTimeInterval(-86400 * 2),
            duration: "3 hours, 02:00 to 05:00 PM",
            workload: "1 AC unit",
            addOnService: nil,
            houseWithPet: nil,
            taskerGender: "Male",
            noteForWorker: "Please check the cooling system thoroughly"
        ),
        OrderDetail(
            orderId: "HOV01203458",
            booking: bookings[10], // Deep Cleaning
            status: .done,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[0], // Andrew Sirolin
            subtotal: 149.00,
            serviceFee: 1.00,
            paymentMethod: "Apple Pay",
            orderDateTime: Date().addingTimeInterval(-86400 * 7),
            paymentDateTime: Date().addingTimeInterval(-86400 * 7),
            duration: "4 hours, 09:00 AM to 01:00 PM",
            workload: "120m²/4500ft²",
            addOnService: "Window cleaning",
            houseWithPet: "Dog",
            taskerGender: "Male",
            noteForWorker: "Deep clean kitchen and bathrooms"
        ),
        OrderDetail(
            orderId: "HOV01203459",
            booking: bookings[11], // Pest Control
            status: .done,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[8], // Marvin McKinney
            subtotal: 94.00,
            serviceFee: 1.00,
            paymentMethod: "Visa",
            orderDateTime: Date().addingTimeInterval(-86400 * 14),
            paymentDateTime: Date().addingTimeInterval(-86400 * 14),
            duration: "2 hours, 10:00 AM to 12:00 PM",
            workload: "Whole house treatment",
            addOnService: "Follow-up inspection",
            houseWithPet: "Cat",
            taskerGender: "Male",
            noteForWorker: "Focus on kitchen and basement areas"
        ),
        OrderDetail(
            orderId: "HOV01203463",
            booking: bookings[12], // Handyman Service
            status: .done,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: workers[2], // Wade Warren
            subtotal: 79.00,
            serviceFee: 1.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(-86400 * 4),
            paymentDateTime: Date().addingTimeInterval(-86400 * 4),
            duration: "2 hours, 03:00 to 05:00 PM",
            workload: "Fix door, install shelf",
            addOnService: nil,
            houseWithPet: nil,
            taskerGender: nil,
            noteForWorker: nil
        ),
        
        // CANCELLED Orders
        OrderDetail(
            orderId: "HOV01203452",
            booking: bookings[13], // Painting
            status: .created,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: nil, // No worker assigned (cancelled before assignment)
            subtotal: 248.00,
            serviceFee: 2.00,
            paymentMethod: "Mastercard",
            orderDateTime: Date().addingTimeInterval(-86400 * 5),
            paymentDateTime: Date().addingTimeInterval(-86400 * 5),
            duration: "5 hours, 09:00 AM to 02:00 PM",
            workload: "2 rooms",
            addOnService: "Wall preparation",
            houseWithPet: nil,
            taskerGender: nil,
            noteForWorker: "Need to paint living room and bedroom"
        ),
        OrderDetail(
            orderId: "HOV01203464",
            booking: bookings[14], // Moving Service
            status: .created,
            customerName: currentUser.name,
            customerPhone: currentUser.phone,
            customerAddress: currentUser.address,
            worker: nil, // No worker assigned (cancelled early)
            subtotal: 298.00,
            serviceFee: 2.00,
            paymentMethod: "Visa",
            orderDateTime: Date().addingTimeInterval(-86400 * 10),
            paymentDateTime: Date().addingTimeInterval(-86400 * 10),
            duration: "6 hours, 07:00 AM to 01:00 PM",
            workload: "2 bedroom apartment",
            addOnService: "Packing service",
            houseWithPet: "Dog",
            taskerGender: nil,
            noteForWorker: "Moving to new apartment across town"
        )
    ]

    // MARK: - Current Worker Profile
    static let currentWorker = Worker(
        name: "Mickey Doe",
        rating: 4.8,
        reviewCount: 154,
        profileImage: "worker_1"
    )
    
    // MARK: - Worker Earnings
    static let workerEarnings: [WorkerEarning] = [
        WorkerEarning(date: Date(), amount: 150.00, type: .payout, jobReference: "HOV01203454", status: "Completed"),
        WorkerEarning(date: Date().addingTimeInterval(-86400), amount: 85.00, type: .payout, jobReference: "HOV01203461", status: "Completed"),
        WorkerEarning(date: Date().addingTimeInterval(-86400 * 2), amount: -500.00, type: .withdrawal, jobReference: nil, status: "Completed"),
        WorkerEarning(date: Date().addingTimeInterval(-86400 * 5), amount: 200.00, type: .payout, jobReference: "HOV01203451", status: "Completed"),
        WorkerEarning(date: Date().addingTimeInterval(-86400 * 7), amount: 50.00, type: .bonus, jobReference: nil, status: "Completed")
    ]
    
    // MARK: - Worker Jobs (Requests & Active)
    static let workerJobs: [WorkerJob] = [
        // NEW REQUESTS
        WorkerJob(serviceName: "Kitchen Cleaning", category: "Cleaning", customerName: "Sarah Connor", customerAddress: "123 Main St, Apt 4B", customerPhone: "(555) 123-4567", date: Date().addingTimeInterval(86400), time: "09:00 AM", duration: "2 hours", status: .pending, payout: 120.00, workload: "Deep clean oven and fridge", addOnService: nil, houseWithPet: "Cat", customerNote: "Key is under the mat", mapImagePlaceholder: "map_placeholder_1", customerProfileImage: "reviewer_1"),
        WorkerJob(serviceName: "Pipe Leak Fix", category: "Plumbing", customerName: "John Smith", customerAddress: "456 Oak Ave", customerPhone: "(555) 987-6543", date: Date().addingTimeInterval(86400 * 2), time: "02:00 PM", duration: "1 hour", status: .pending, payout: 80.00, workload: "Fix leaking sink in bathroom", addOnService: nil, houseWithPet: nil, customerNote: "Please call when you arrive", mapImagePlaceholder: "map_placeholder_2", customerProfileImage: "reviewer_2"),
        
        // ACTIVE / ACCEPTED
        WorkerJob(serviceName: "AC Service", category: "Repairing", customerName: "Emily Davis", customerAddress: "789 Pine Ln", customerPhone: "(555) 456-7890", date: Date(), time: "03:00 PM", duration: "1.5 hours", status: .accepted, payout: 95.00, workload: "Regular maintenance", addOnService: "Filter replacement", houseWithPet: "Dog", customerNote: "Dog is friendly", mapImagePlaceholder: "map_placeholder_3", customerProfileImage: "reviewer_3"),
        WorkerJob(serviceName: "Wall Painting", category: "Painting", customerName: "Michael Brown", customerAddress: "321 Elm St", customerPhone: "(555) 234-5678", date: Date().addingTimeInterval(3600), time: "04:00 PM", duration: "4 hours", status: .inProgress, payout: 250.00, workload: "Paint living room walls", addOnService: nil, houseWithPet: nil, customerNote: "Paint is already purchased", mapImagePlaceholder: "map_placeholder_1", customerProfileImage: "reviewer_1"),
        
        // COMPLETED
        WorkerJob(serviceName: "Furniture Assembly", category: "Assembly", customerName: "Jessica Wilson", customerAddress: "654 Cedar Blvd", customerPhone: "(555) 345-6789", date: Date().addingTimeInterval(-86400), time: "10:00 AM", duration: "3 hours", status: .completed, payout: 150.00, workload: "Assemble IKEA wardrobe", addOnService: nil, houseWithPet: nil, customerNote: nil, mapImagePlaceholder: nil, customerProfileImage: "reviewer_2")
    ]
}
