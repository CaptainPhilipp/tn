module Debug
  # переопределение метода
  def self.included(klas)
    klas.extend ClassMethods
    klas.include InstanceMethods
  end

  module ClassMethods
    # with args:
    # :pause just for pause
    # String for puts String
    # binding for eval
    def debug(*args)
      
      # TODO: #find
      bind = args.select{ |a| a.is_a? Binding }.first
      log  = args.reject { |a|  a.is_a?(Symbol) || a.is_a?(Binding) }.first

      log = "EVAL: #{log}" if bind
      puts ' >> DEBUG ' + (log.is_a?(String) ? log : log.inspect)

      gets if args.include? :pause

      # тут какая-то фигня с присвоением в условии, когда юзается однострочный вариант цикла
      # так что обычный вариант. только кажется что-то я накосячил с самим условием, хотя работало как ожидал.
      # TODO: поправить условие
      until bind && (input = gets.chomp.strip).empty?
        run_eval 
      end
    end
    
    private
    
    def run_eval
      puts eval(input, bind)
    rescue => ex
      puts "ERROR: #{ex}\nEVAL: "
    end
  end

  module InstanceMethods
    def debug(*args)
      self.class.debug(*args)
    end
  end
end
