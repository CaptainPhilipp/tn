class PassengerTrain < Train
  alias switch_doors wagons_action

  protected

  def wagon_class
    PassengerWagon
  end
end
