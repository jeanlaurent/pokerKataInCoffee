should = require('chai').should()

class Game
  constructor: (@blackHand, @whiteHand) ->

  winning: () ->
    if @blackHand.isFlush() or @whiteHand.isFlush()
      if @blackHand.isFlush() and not @whiteHand.isFlush()
        return @display "black", "flush", @whiteHand.cards[0].color
      if @whiteHand.isFlush() and not @blackHand.isFlush()
        return @display "white", "flush", @whiteHand.cards[0].color
      if @whiteHand.isFlush() and @blackHand.isFlush()
        return @highestCard("flush and")
    return @highestCard()

  highestCard: (superKind) ->
    kind = "high card"
    kind = "#{superKind} #{kind}" if superKind?
    if @blackHand.highestCard.value > @whiteHand.highestCard.value
      return @display "black", kind, @blackHand.highestCard.name
    else
      return @display "white", kind, @whiteHand.highestCard.name

  display: (color, kind, cardName) ->
    "#{color} wins with #{kind}: #{cardName}"

class Hand
  constructor: (string) ->
    @highestCard = ""
    @cards = []
    strings = string.split(" ")
    @cards.push new Card(string) for string in strings
    highestValue = 0
    for card in @cards
      if card.value > highestValue
        highestValue = card.value
        @highestCard = card

  isFlush: () ->
    for card in @cards[1..]
      return false if @cards[0].color != card.color
    true

class Card
  constructor: (string) ->
    @name = string[0]
    @color = string[1]
    @value=+@name
    @value = 10 if @name == 'T'
    @value = 11 if @name == 'J'
    @value = 12 if @name == 'Q'
    @value = 13 if @name == 'K'
    @value = 14 if @name == 'A'

describe 'Poker Hand Tests', () ->

  it 'should read the value of a card', () ->
    new Card("2C").value.should.equal 2

  it 'should read value of a Ten', () ->
    new Card("TC").value.should.equal 10

  it 'should read value of a Jack', () ->
    new Card("JC").value.should.equal 11

  it 'should read value of a Queen', () ->
    new Card("QC").value.should.equal 12

  it 'should read value of a King', () ->
    new Card("KC").value.should.equal 13

  it 'should read value of a Ace', () ->
    new Card("AC").value.should.equal 14

  it 'should read the color of a card', () ->
    new Card("AC").color.should.equal 'C'

  it 'should read the color of a card', () ->
    new Card("AD").color.should.equal 'D'

  it 'should create a hand with some cards', () ->
    hand = new Hand("AC QC")
    hand.cards.should.contain new Card("AC")
    hand.cards.should.contain new Card("QC")

  it 'should find the highest card of a hand', () ->
    new Hand("AC QC").highestCard.should.eql new Card("AC")

  it 'should find the winning hand using High Card', () ->
    blackHand = new Hand("AC QC 3H 6D 7D")
    whiteHand = new Hand("2C 2H 4D 5D TS")
    new Game(blackHand, whiteHand).winning().should.equal "black wins with high card: A"

  it 'should find flush', () ->
    new Hand("AC QC 3H 6D 7D").isFlush().should.be.false
    new Hand("8D 3D 4D 5D AD").isFlush().should.be.true

  it 'should find flush is better than highestCard', () ->
    blackHand = new Hand("AC QD 3H 6D 7D")
    whiteHand = new Hand("2C 4C 5C TC JC")
    new Game(blackHand, whiteHand).winning().should.equal "white wins with flush: C"

  it 'should find flush is better than highestCard', () ->
    blackHand = new Hand("2C 4C 5C TC JC")
    whiteHand = new Hand("AC QD 3H 6D 7D")
    new Game(blackHand, whiteHand).winning().should.equal "black wins with flush: C"

  it 'should find 2 flush and fall back to highestCard', () ->
    blackHand = new Hand("2D 4D 5D TD QD")
    whiteHand = new Hand("2C 4C 5C TC AC")
    new Game(blackHand, whiteHand).winning().should.equal "white wins with flush and high card: A"
