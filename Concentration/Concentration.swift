import Foundation


class Concentration {
    private(set) var cards =  [Card]()
    var score = 0
    var cardLog = [Card: Set<Int>]() // identifier -> [index]
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen index not in the cards")
        
        let id = cards[index]
        if let logOfId = cardLog[id] {
            cardLog[id] = logOfId.union([index])
        } else {
            cardLog[id] = [index]
        }
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if card match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                else {
                    if cardLog[id]!.count == 2 {
                        score -= 1
                    }
                    if cardLog[cards[matchIndex]]?.count == 2 {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        for _ in 1...numberOfPairsOfCards * 2 {
            let randomCardIndex = (numberOfPairsOfCards * 2).arc4random
            let cardIndexToSwap = (numberOfPairsOfCards * 2).arc4random
            
            let tempCard = cards[randomCardIndex]
            cards[randomCardIndex] = cards[cardIndexToSwap]
            cards[cardIndexToSwap] = tempCard
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
