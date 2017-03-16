module Validation
  # принимает в качестве параметров имя проверяемого атрибута,
  # а также тип валидации и при необходимости дополнительные параметры
  #
  # presence - требует, чтобы значение атрибута было не nil и не пустой строкой.
  #   validate :name, :presence
  # format - треубет соответствия значения атрибута заданной регулярке.
  #   validate :number, :format, /A-Z{0,3}/
  # type - требует соответствия значения атрибута заданному классу.
  #   validate :station, :type, RailwayStation
  def validate(name, type, *args)
    # class
  end

  # запускает все проверки (валидации),
  # указанные в классе через метод класса validate
  #  В случае ошибки валидации выбрасывает исключение с сообщением о том,
  # какая именно валидация не прошла
  def validate!
    # instance
  end

  # возвращает true, если все проверки валидации прошли успешно
  # false, если есть ошибки валидации.
  def valid?
    # instance
  end
end
