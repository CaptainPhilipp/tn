module Debug
  # переопределение метода
  def self.included(clas)
    clas.extend ClassMethods
    clas.include InstanceMethods
  end

  module ClassMethods
    def debug(*args)
      log = args.reject{ |a| a.is_a? Symbol }.first
      puts ' >> DEBUG: ' + (log.is_a?(String) ? log : log.inspect)

      gets                        if args.include? :pause
      puts eval(gets.chomp.strip) if args.include? :eval
    end
  end

  module InstanceMethods
    def debug(*args)
      self.class.debug(*args)
    end
  end

end
