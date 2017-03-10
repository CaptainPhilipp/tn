class PassenegerTrain < Train

  # без других действий - просто для говорящего имени
  # куцая, нефункциональная обертка.
  #
  #   def switch_doors
  #     wagons_action
  #   end
  #
  # стоит юзать её или алиас?
  #
  # с одной стороны - её действие слишком малофункционально, и подошел бы алиас
  # с другой стороны, метод как-то очевиднее воспринимается, нет?

  alias switch_doors wagons_action

  protected

  def wagon_class
    PassenegerWagon
  end
end
