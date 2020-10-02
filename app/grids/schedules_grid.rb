class SchedulesGrid < BaseGrid

  scope do
    Subject
  end

  # Filters

  filter(:name, :string)
  filter(:details, :string)
  filter(:time, :string)

  # Columns

  column(:name, :mandatory => true)
  column(:details, :mandatory => true)
  column(:time, :mandatory => true)

end
