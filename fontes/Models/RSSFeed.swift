//
//  RSSFeed.swift
//  fontes
//
//  Created by Mateus Costa on 12/01/2026.
//

import SwiftUI
import Foundation

struct RSSFeed: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let url: URL
    let logoURL: String
    let colorHex: String
    var isEnabled: Bool
    
    var defaultColor: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    init(id: String, name: String, url: URL, logoURL: String, defaultColor: Color, isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.url = url
        self.logoURL = logoURL
        self.colorHex = defaultColor.toHex() ?? "#0000FF"
        self.isEnabled = isEnabled
    }
    
    // Internal init for decoding
    private init(id: String, name: String, url: URL, logoURL: String, colorHex: String, isEnabled: Bool) {
        self.id = id
        self.name = name
        self.url = url
        self.logoURL = logoURL
        self.colorHex = colorHex
        self.isEnabled = isEnabled
    }
    
    static let defaultFeeds: [RSSFeed] = [
        RSSFeed(
            id: "publico",
            name: "Público",
            url: URL(string: "https://feeds.feedburner.com/PublicoRSS")!,
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Logo_publico.svg/250px-Logo_publico.svg.png",
            defaultColor: .blue
        ),
        RSSFeed(
            id: "observador",
            name: "Observador",
            url: URL(string: "https://observador.pt/feed/")!,
            logoURL: "https://www.empregoestagios.com/wp-content/uploads/2022/02/Observador-660x330.png",
            defaultColor: .indigo
        ),
        RSSFeed(
            id: "rtp",
            name: "RTP Notícias",
            url: URL(string: "https://www.rtp.pt/noticias/rss/")!,
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/RTP.svg/1024px-RTP.svg.png",
            defaultColor: .orange
        ),
        RSSFeed(
            id: "dn",
            name: "Diário de Notícias",
            url: URL(string: "https://www.dn.pt/rss/")!,
            logoURL: "https://static.globalnoticias.pt/dn/common/images/dn-logo-black.svg",
            defaultColor: .red
        ),
        RSSFeed(
            id: "expresso",
            name: "Expresso",
            url: URL(string: "https://expresso.pt/rss")!,
            logoURL: "https://static.globalnoticias.pt/expresso/common/images/logo.svg",
            defaultColor: .purple
        )
    ]
}
