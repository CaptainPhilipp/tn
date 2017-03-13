module Debug
  # переопределение метода
  def self.included(clas)
    clas.extend ClassMethods
    clas.include InstanceMethods
  end

  module ClassMethods
    # with args:
    # :pause just for pause
    # String for puts String
    # binding for eval
    def debug(*args)
      bind = args.select{ |a| a.is_a? Binding }.first
      log  = args.reject { |a|  a.is_a?(Symbol) || a.is_a?(Binding) }.first

      log = "EVAL: #{log}" if bind
      puts ' >> DEBUG ' + (log.is_a?(String) ? log : log.inspect)

      gets if args.include? :pause

      until bind && (input = gets.chomp.strip).empty?
        begin
          puts eval(input, bind)
        rescue => ex
          puts "ERROR: #{ex}\nEVAL: "
        end
      end
    end
  end

  module InstanceMethods
    def debug(*args)
      self.class.debug(*args)
    end
  end
end
