//
//  MockData.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct MockData {
    static let shared = MockData()
    
    let items: [ArticleItem] = [
        ArticleItem(id: 1, title: "'I annoyed him a lot - I think that's why he was a little bit angry.", source: "dailymail.co.uk", time: "2h", author: "Sarah Jane", tags: ["Celebrity", "News"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .blue),
        ArticleItem(id: 2, title: "Photoshop Troll Who Takes Photo Requests Too Literally Strikes Again, And The Result Is Hilarious", source: "boredpanda.com", time: "2h", author: "James Fridman", tags: ["Humor", "Viral"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .purple),
        ArticleItem(id: 3, title: "New iPhone 16 Pro Max Review: The Best Just Got Better", source: "theverge.com", time: "4h", author: "Nilay Patel", tags: ["Tech", "Review"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .indigo),
        ArticleItem(id: 4, title: "NASA's James Webb Space Telescope captures stunning new image of the Pillars of Creation", source: "nasa.gov", time: "8h", author: "Bill Nelson", tags: ["Space", "Science"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .orange),
        ArticleItem(id: 5, title: "Why the future of renewable energy depends on this one critical mineral found in the deep ocean", source: "wired.com", time: "5h", author: "Matt Simon", tags: ["Environment", "Future"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .teal),
        ArticleItem(id: 6, title: "Top 10 Places to Visit in Japan", source: "travelandleisure.com", time: "6h", author: "Stacey Leasca", tags: ["Travel", "Japan"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .pink),
        ArticleItem(id: 7, title: "The Ultimate Guide to Homemade Pasta", source: "bonappetit.com", time: "1h", author: "Chris Morocco", tags: ["Food", "Cooking"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.empregoestagios.com%2Fwp-content%2Fuploads%2F2022%2F02%2FObservador-660x330.png&f=1&nofb=1&ipt=6ce4e74a3dcc0cf828b8f6ae8283bbdcdfbeb71a6871e61fd5990a04c804a8b6", mainColor: .yellow),
        ArticleItem(id: 8, title: "SpaceX successfully launches another batch of Starlink satellites", source: "space.com", time: "3h", author: "Mike Wall", tags: ["SpaceX", "Tech"], sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f", mainColor: .mint),
        ArticleItem(id: 9, title: "Understanding the basics of Quantum Computing", source: "mit.edu", time: "7h", author: "Dr. Peter Shor", tags: ["Science", "Physics"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png?20171009220824", mainColor: .cyan),
        ArticleItem(id: 10, title: "10 Hidden Gems in Europe You Must Visit", source: "lonelyplanet.com", time: "9h", author: "Tom Hall", tags: ["Travel", "Europe"], sourceLogo: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png?20211101150043", mainColor: .green)
    ]
    
    let featuredItem = ArticleItem(
        id: 0,
        title: "Apple's cheapest iPad may be the star of Apple's October event",
        source: "Macworld",
        time: "3h",
        author: "Michael Simon",
        tags: ["Apple", "Tech", "Event"],
        sourceLogo: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvectorseek.com%2Fwp-content%2Fuploads%2F2023%2F10%2FCorreio-da-Manha-Logo-Vector.svg-.png&f=1&nofb=1&ipt=fc21ec43bf88a94dabfedc06efe86762663499facfcd48710bd6332161dae90f",
        mainColor: .red
    )
}
