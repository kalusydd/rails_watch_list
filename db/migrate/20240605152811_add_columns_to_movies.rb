class AddColumnsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :director, :string
    add_column :movies, :year, :integer
  end
end
