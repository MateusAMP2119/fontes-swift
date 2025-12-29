//
//  MockData.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct MockData {
    static let shared = MockData()
    
    let items: [ReadingItem] = [
        ReadingItem(id: 1, title: "'I annoyed him a lot - I think that's why he was a little bit angry.", source: "Público", time: "2h", author: "Sarah Jane", tags: ["Celebrity", "News"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .blue),
        ReadingItem(id: 2, title: "Photoshop Troll Who Takes Photo Requests Too Literally Strikes Again, And The Result Is Hilarious", source: "RTP", time: "2h", author: "James Fridman", tags: ["Humor", "Viral"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .purple),
        ReadingItem(id: 3, title: "New iPhone 16 Pro Max Review: The Best Just Got Better", source: "Observador", time: "4h", author: "Nilay Patel", tags: ["Tech", "Review"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .indigo),
        ReadingItem(id: 4, title: "NASA's James Webb Space Telescope captures stunning new image of the Pillars of Creation", source: "Correio da Manhã", time: "8h", author: "Bill Nelson", tags: ["Space", "Science"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .orange),
        ReadingItem(id: 5, title: "Why the future of renewable energy depends on this one critical mineral found in the deep ocean", source: "Público", time: "5h", author: "Matt Simon", tags: ["Environment", "Future"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .teal),
        ReadingItem(id: 6, title: "Top 10 Places to Visit in Japan", source: "RTP", time: "6h", author: "Stacey Leasca", tags: ["Travel", "Japan"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .pink),
        ReadingItem(id: 7, title: "The Ultimate Guide to Homemade Pasta", source: "Observador", time: "1h", author: "Chris Morocco", tags: ["Food", "Cooking"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .yellow),
        ReadingItem(id: 8, title: "SpaceX successfully launches another batch of Starlink satellites", source: "Correio da Manhã", time: "3h", author: "Mike Wall", tags: ["SpaceX", "Tech"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .mint),
        ReadingItem(id: 9, title: "Understanding the basics of Quantum Computing", source: "Público", time: "7h", author: "Dr. Peter Shor", tags: ["Science", "Physics"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .cyan),
        ReadingItem(id: 10, title: "10 Hidden Gems in Europe You Must Visit", source: "RTP", time: "9h", author: "Tom Hall", tags: ["Travel", "Europe"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .green)
    ]
    
    let featuredItem = ReadingItem(
        id: 0,
        title: "Apple's cheapest iPad may be the star of Apple's October event",
        source: "Correio da Manhã",
        time: "3h",
        author: "Michael Simon",
        tags: ["Apple", "Tech", "Event"],
        sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f",
        mainColor: .red
    )

    
    // MARK: - For You Data
    let forYouItems: [ReadingItem] = [
        ReadingItem(id: 101, title: "The Art of Minimalist Living: Less is More", source: "Kinfolk", time: "1h", author: "Nathan Williams", tags: ["Lifestyle", "Design"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .gray),
        ReadingItem(id: 102, title: "Best Coffee Shops in Lisbon 2025", source: "TimeOut", time: "30m", author: "Maria Sousa", tags: ["Food", "Lisbon"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .brown),
        ReadingItem(id: 103, title: "Understanding SwiftUI Layout System", source: "Hacking within Swift", time: "5h", author: "Paul Hudson", tags: ["Code", "SwiftUI"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .orange),
        ReadingItem(id: 104, title: "The Rise of Electric Vehicles in Europe", source: "Bloomberg", time: "12h", author: "Tom Randall", tags: ["Auto", "Economy"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .blue),
        ReadingItem(id: 105, title: "Why sleep is your superpower", source: "TED", time: "1d", author: "Matt Walker", tags: ["Health", "Science"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .purple)
    ]
    
    let forYouFeaturedItem = ReadingItem(
        id: 100,
        title: "Discovering the Hidden Beaches of Algarve",
        source: "Travel & Leisure",
        time: "2h",
        author: "Joana Silva",
        tags: ["Travel", "Portugal"],
        sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f",
        mainColor: .teal
    )
    
    // MARK: - For Later Data
    let forLaterItems: [ReadingItem] = [
        ReadingItem(id: 201, title: "Deep Dive into Artificial Intelligence Ethics", source: "Wired", time: "Saved 2d ago", author: "Will Knight", tags: ["AI", "Tech"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .black),
        ReadingItem(id: 202, title: "The History of Modern Architecture", source: "ArchDaily", time: "Saved 1w ago", author: "David Basulto", tags: ["Design", "History"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .gray),
        ReadingItem(id: 203, title: "How to Bake the Perfect Sourdough Bread", source: "Bon Appétit", time: "Saved 3d ago", author: "Claire Saffitz", tags: ["Food", "Cooking"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .yellow),
        ReadingItem(id: 204, title: "Financial Freedom: A multiple step guide", source: "Forbes", time: "Saved 5d ago", author: "Rob Berger", tags: ["Finance", "Money"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .green),
        ReadingItem(id: 205, title: "Long Form: The Cold War Espionage", source: "The New Yorker", time: "Saved 2w ago", author: "Patrick Radden Keefe", tags: ["History", "Long Read"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .red),
        ReadingItem(id: 206, title: "Swift Concurrency: Behind the Scenes", source: "WWDC Notes", time: "Saved 1mo ago", author: "Apple", tags: ["Dev", "Swift"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .orange),
        ReadingItem(id: 207, title: "The Joy of Painting: Bob Ross Legacy", source: "PBS", time: "Saved 2mo ago", author: "Bob Ross", tags: ["Art", "Relax"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .blue),
        ReadingItem(id: 208, title: "Understanding Black Holes", source: "NASA", time: "Saved 3mo ago", author: "Stephen Hawking", tags: ["Space", "Science"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .black),
        ReadingItem(id: 209, title: "How to Build a Wood Cabin", source: "Outdoor Life", time: "Saved 1d ago", author: "Dick Proenneke", tags: ["DIY", "Nature"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .brown),
        ReadingItem(id: 210, title: "The Best Jazz Albums of 2024", source: "Pitchfork", time: "Saved 4h ago", author: "Evan Minsker", tags: ["Music", "Jazz"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .indigo),
        ReadingItem(id: 211, title: "Sustainable Gardening for Beginners", source: "Gardeners' World", time: "Saved 6d ago", author: "Monty Don", tags: ["Gardening", "Green"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .green),
        ReadingItem(id: 212, title: "Why We Dream: The Science of Sleep", source: "National Geographic", time: "Saved 1w ago", author: "Alice Park", tags: ["Health", "Science"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .purple),
        ReadingItem(id: 213, title: "Classic French Desserts to Master", source: "Saveur", time: "Saved 5h ago", author: "Julia Child", tags: ["Food", "Cooking"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .pink),
        ReadingItem(id: 214, title: "The Future of Public Transport", source: "CityLab", time: "Saved 2d ago", author: "Laura Bliss", tags: ["Urban", "Future"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .cyan)
    ]
}
