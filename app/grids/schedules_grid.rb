class SchedulesGrid < BaseGrid

  scope do
    Subject
  end

  # Filters
  filter(:name, :string)
  filter(:code, :string)
  filter(:time, :string)

  # Columns
  column(:name, :mandatory => true)
  column(:code, :mandatory => true)
  column(:time, :mandatory => true)

end
