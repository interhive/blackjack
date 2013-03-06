# encoding: utf-8

require 'pp'

MAX_INT = (2 ** (0.size * 8 - 1))

module Blackjack
  class Game
    attr_accessor :deck, :table

    def initialize(players = 1, decks = 1)
      self.deck = Deck.new(decks)
      self.table = Table.new(players)
    end

    def deal
      players = table.players
      dealer  = table.dealer

      2.times do
        players.each do |player|
          player.deal(self.deck.pop)
        end

        dealer.deal(self.deck.pop)
      end
    end

  end

  class Table
    attr_accessor :players, :dealer

    def initialize(player_count = 1)
      self.dealer       = Dealer.new
      self.players      = []

      # initialize Player objects for later use
      player_count.times  { self.players << Player.new }
    end
  end

  class Player
    attr_accessor :hand

    def initialize
      self.hand = Hand.new
    end

    def deal(card = {})
      self.hand.add card
    end
  end

  class Dealer < Player; end

  class Hand
    attr_accessor :cards

    def initalize
      self.cards = []
    end

    def add(card = {})
      self.cards << card
    end
  end

  class Deck
    attr_accessor :cards, :deck_count

    def initialize(decks = 1)
      self.deck_count = decks if decks >= 1

      if self.deck_count
        self.cards = shuffle(build_decks(decks), build_shuffler(decks))
      end
    end

  private

    def build_decks(deck_count = 1)
      arr = []
      for i in 1..deck_count
        deck_hash = {}
        ['♣', '♥', '♠', '♦'].each do |suit|
          val = 0
          ['A','2','3','4','5','6','7','8','9','T','J','Q','K'].each do |face|
            val += 1 unless val == 10
            deck_hash.merge!({"#{face}#{suit}".to_sym => val})
          end
        end
        arr << deck_hash
      end
      arr
    end

    def build_shuffler(deck_count = 1)
      arr = []

      for i in 1..deck_count
        for j in 1..52
          arr << rand(MAX_INT)
        end
      end
      arr
    end

    def shuffle(decks, shuffler)
      return nil if decks.count * 52 != shuffler.count

      hsh = {}
      index = 0
      shuffled_deck = []

      decks.each do |deck|
        deck.each do |k, v|
          # pp "#{k} => #{v}"
          hsh.merge!((shuffler[index]) => {k => v})
          index += 1
        end
      end

      hsh.sort.each do |ary|
        shuffled_deck << ary[1]
      end

      shuffled_deck
    end
  end
end



player_count  = 3
deck_count    = 4

game = Blackjack::Game.new(player_count, deck_count)

table = game.deal

dealer = table[table.count - 1]
p dealer