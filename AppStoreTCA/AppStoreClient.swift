//
//  AppStoreClient.swift
//  AppStoreTCA
//
//  Created by Rimesh Jotaniya on 04/11/24.
//
import ComposableArchitecture
import Foundation

// MARK: - API client interface

@DependencyClient
struct AppStoreClient {
    var search: @Sendable (_ query: String) async throws -> [AppModel]
}

extension AppStoreClient: TestDependencyKey {
    static let previewValue = Self(
        search: { _ in .mock }
    )

    static let testValue = Self()
}

extension DependencyValues {
    var appStoreClient: AppStoreClient {
        get { self[AppStoreClient.self] }
        set { self[AppStoreClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension AppStoreClient: DependencyKey {
    static let liveValue = AppStoreClient(
        search: { query in
            var components = URLComponents(string: "https://itunes.apple.com/search")!
            components.queryItems = [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "media", value: "software"),
            ]
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            let searchResults = try JSONDecoder().decode(SearchResponse.self, from: data)
            return searchResults.results
        }
    )
}

// MARK: - Mock data

extension Array where Element == AppModel {
    static let mock = [
        AppModel.mock,
        AppModel.mock,
        AppModel.mock,
    ]
}

extension AppModel {
    static let mock = AppModel(
        trackId: 368_677_368,
        trackName: "Uber - Request a ride",
        artistId: 368_677_371,
        artistName: "Uber Technologies, Inc.",
        bundleId: "com.ubercab.UberClient",
        releaseDate: "2010-05-21T03:11:23Z",
        releaseNotes: "We update the Uber app as often as possible to make it faster and more reliable for you. Here are a couple of the enhancements you'll find in the latest update:\n\n- Updates to improve localization across the app\n- Various bug fixes & improvements\n  \nLove the app? Rate us! Your feedback keeps the Uber engine running.\nHave a question? Tap Help in the Uber app or visit help.uber.com.",
        sellerName: "Uber Technologies, Inc.",
        version: "3.639.10000",
        currentVersionReleaseDate: "2024-10-28T15:51:04Z",
        description: "Join the millions of riders who trust Uber for their everyday travel needs. Whether you’re running an errand across town or exploring a city far from home, getting there should be easy.\n\nFIND THE RIDE YOU WANT\nFind the perfect ride right at your fingertips! Uber is here to make your journey stress-free and enjoyable.\n\nPick from a wide range of products that the Uber app has to offer including: \n- UberX: Affordable rides, all to yourself\n- Uber Green: Eco-Friendly\n- UberXL: Affordable rides for groups up to 6\n- Comfort: Newer cars with extra legroom\n- Comfort Electric: Premium zero-emission cars\n- Uber Pet: Affordable rides for you and your pet\n- Black: Luxury rides with professional drivers\n- Taxi: You now have the option to request a cab or a taxi on demand using Uber in select cities\n- 2-wheels: Find a scooter to start riding roday \n\nUPFRONT PRICING\nWith Uber, you no longer need to worry about hidden costs or unexpected surprises. As you enter your destination in the app, you get upfront pricing and the estimated time of arrival.\n\nSAFETY TOGETHER\nSafety is a top priority at Uber. We have established comprehensive safety features to help ensure every rider and driver feels secure and comfortable.\n\nAFFORDABLE PRICING\nWe’re doing all we can to make our pricing as transparent as possible.\n\n- UberX Share: UberX Share connects you to other riders headed in the same direction. \n- Group Rides: Share the journey with friends.\n- Split Fare: Don’t worry about doing the math later—split the cost evenly while you’re still on the ride. \n\nJOIN UBER ONE FOR EXCLUSIVE PERKS\nBenefit from $0 Delivery Fee and up to 10% off eligible delivery and pickup orders, 6% Uber Cash back on eligible rides and a $5 credit if our Latest Arrival Estimate on your order is off. Other fees & terms apply. For more details see uber.com/uberone.\n\nRESERVE RIDES IN ADVANCE\nNeed a ride at a specific time? No problem! Uber allows you to reserve rides in advance, so you can plan your day with confidence. \n\nGO GREEN\nUber is committed to building a sustainable future for our cities. With a growing fleet of electric and hybrid vehicles, you can choose eco-friendly rides to reduce your carbon footprint.\n\nRENT CARS AND HAVE THEM DELIVERED TO YOU\nWhether you need a car today or later, the online booking experience will help you find the right vehicle for a family vacation, a weekend getaway, airport travel, and more. You can have a rental car delivered to your door at the time and location of your choice with Valet, currently available in select cities.\n\nMORE FEATURES\nDelivery: Order food from your favorite restaurants through Uber Eats. Stock up on groceries, shop pharmacy, convenience and pet supplies and get them all delivered. \n\nUber Connect: an easy, same-day, no-contact delivery solution that allows people to send items whether it’s a care package for a loved one or an item you sold online.\n\nTransit: Say goodbye to complicated time schedules, hectic transfers, and unexpected waits while reducing your trip’s emissions.\n\nUber Charter: Book high-capacity group rides in vehicles seating 14-55 passengers, such as limo buses, luxury vans, and coach buses.\n\n2-Wheels: Did you know you can also bike or ride a scooter with the Uber app?\n\nUber for Business: Manage and track business travel, meal programs, and more on one dashboard.\n\nUber Hourly: Keep a car and driver with you for hours. \n\nUber Car Seat: Uber Car Seat provides one forward-facing car seat for a child who is at least 2 years old, 22 pounds, and 31 inches tall.\n\nGet Started Now! Download the Uber app and create an account today. Uber is available in the following cities: Boston, DC, LA, New York, San Francisco, Vegas, Orlando, Chicago and more. Check if Uber is available in your city at https://www.uber.com/cities. Stay updated on the latest news, promotions, and offers by following us on Twitter at https://twitter.com/uber and liking us on Facebook at https://www.facebook.com/uber.",
        fileSizeBytes: "501245952",
        formattedPrice: "Free",
        contentAdvisoryRating: "4+",
        trackContentRating: "4+",
        averageUserRating: 4.8917500000000000426325641456060111522674560546875,
        userRatingCount: 11_357_398,
        artworkUrl512: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/2f/86/ae/2f86ae72-73c5-2dbe-8c13-635532853802/AppIcon-0-0-1x_U007emarketing-0-8-0-sRGB-85-220.png/512x512bb.jpg")!,
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/2f/86/ae/2f86ae72-73c5-2dbe-8c13-635532853802/AppIcon-0-0-1x_U007emarketing-0-8-0-sRGB-85-220.png/100x100bb.jpg")!,
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/2f/86/ae/2f86ae72-73c5-2dbe-8c13-635532853802/AppIcon-0-0-1x_U007emarketing-0-8-0-sRGB-85-220.png/60x60bb.jpg")!,
        primaryGenreName: "Travel",
        screenshotUrls: [
            URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/c0/c8/98/c0c8984c-fef4-3175-48c0-8e0dc815e6f8/6cf2abb7-d8c1-49e0-96f5-88dc3b1bdc20_SS01.png/392x696bb.png")!,
            URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/ec/b2/82/ecb282c0-b466-7cef-55ab-c5c222365266/5921dcb5-b558-4369-b72c-85c22f89742d_SS02.png/392x696bb.png")!,
            URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/71/fa/0c/71fa0cf9-d2e1-705a-89b2-49f28ea926c5/ca2de83c-8c8e-4887-94f4-3ae11c83d7cc_SS03.png/392x696bb.png")!,
        ]
    )
}
