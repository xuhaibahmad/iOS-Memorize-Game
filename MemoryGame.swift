import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var indexOfOnlyFaceUpCard: Int? {
        get {
            let faceUpIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpIndices.count == 1 ? faceUpIndices.first : nil
        }
        set {
            cards.indices.forEach { i in cards[i].isFaceUp = i == newValue }
        }
    }
    
    init(cardPairCount: Int, cardFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for index in 0..<cardPairCount {
            let content = cardFactory(index)
            cards.append(Card(content: content, id: index * 2))
            cards.append(Card(content: content, id: index * 2 + 1))
        }
    }
    
    mutating func choose(card: Card) {
        let chosenIndex = self.cards.firstIndex{ $0.id == card.id }!
        if !self.cards[chosenIndex].isFaceUp && !self.cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfOnlyFaceUpCard {
                if self.cards[chosenIndex].content == self.cards[potentialMatchIndex].content {
                    self.cards[chosenIndex].isMatched = true
                    self.cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
            } else {
                indexOfOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
