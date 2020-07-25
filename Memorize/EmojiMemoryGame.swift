import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var game = EmojiMemoryGame.createGame()
    
    private static func createGame() -> MemoryGame<String> {
        let emojis = ["👻", "🤖", "👽", "🧛", "🧟‍♀️", "🧞‍♂️", "🐶", "🐱", "🐹"]
        return MemoryGame<String>(cardPairCount: emojis.count) { pairIndex in emojis[pairIndex] }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        game.cards
    }
    
    func chooseCard(card: MemoryGame<String>.Card) {
        game.choose(card: card)
    }
    
    func reset() {
        game = EmojiMemoryGame.createGame()
    }
}
