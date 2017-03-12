module Debug
  # переопределение метода
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def debug(*args)
      options = args.delete_if { |o| o.is_a? Symbol }
      log = args.first
      puts '>> DEBUG: ' + (log.is_a?(String) ? log : log.inspect)
      pause_or_eval if options.include?(:pause)
    end

    private

    def pause_or_eval
      puts ">> PAUSE. Input #{eval_keys} for call eval"
      recieved = gets.chomp.strip
      eval(recieved) unless recieved.empty?
    end
  end

  module InstanceMethods
    def debug(*args)
      self.class.debug(*args)
    end
  end

end
