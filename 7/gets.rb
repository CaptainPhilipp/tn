class WrongIndex < Exception; end

module Gets
  ABORT_KEYS = ['q', 'й', nil].freeze

  class << self
    # return nil if recieved ABORT_KEY or empty string
    def nilable
      answer = gets.chomp.strip
      answer.empty? || ABORT_KEYS.include?(answer) ? nil : answer
    end

    def object(collection)
      return unless i = index
      collection[i]
    end

    # splited string
    def splited(delimeter = ' ')
      return unless answer = nilable
      answer.split(delimeter)
    end

    def index(correction: -1, max_size: nil)
      return unless answer = nilable
      index  = answer.to_i
      result = index + correction
      raise WrongIndex if index && index > max_size
      result
    rescue WrongIndex
      puts 'Wrong row number! retry'
      retry
    end
  end
end
