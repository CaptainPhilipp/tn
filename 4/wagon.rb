class Wagon
  # метод для переопределения
  # будет вызываться другими классами
  def action
    raise NotImplementedError, 'Wagon class is not defined!'
  end
end
