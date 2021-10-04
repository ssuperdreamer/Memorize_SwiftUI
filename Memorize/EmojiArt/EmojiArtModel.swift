//
//  EmojiArtModel.swift
//  Memorize
//
//  Created by Takeshi on 9/29/21.
//

import Foundation


struct EmojiArtModel: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Hashable, Codable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y:Int, size: Int, id: Int) {
            self.text = text
            self.x = x  //offset from the center
            self.y = y  //offset from the center
            self.size = size
            self.id = id
        }
    }
    
  
    
    init() {}
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArtModel(json: data)
    }
    
    func json() throws -> Data  {
        return try JSONEncoder().encode(self)
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location:(x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
    
    
}
