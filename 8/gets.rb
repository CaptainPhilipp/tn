class WrongIndex < RuntimeError; end

module Gets
  ABORT_KEYS = ['q', 'й', nil].freeze

  class << self
    # return nil if recieved ABORT_KEY or empty string
    def nilable
      answer = gets.chomp.strip
      answer.empty? || ABORT_KEYS.include?(answer) ? nil : answer
    end

    # splited string
    def splited(delimeter = ' ')
      return unless answer = nilable
      answer.split(delimeter)
    end

    def index(max_index: nil)
      return unless answer = nilable
      index = answer.to_i
      raise WrongIndex unless max_index && (1..max_index).cover?(index)
      index - 1
    rescue WrongIndex
      puts 'Cancel (wrong index)'
      nil
    end

    def integer
      return unless answer = nilable
      answer.to_i
    end

    def object(collection)
      return unless i = index(max_index: collection.size)
      collection[i]
    end
  end
end
