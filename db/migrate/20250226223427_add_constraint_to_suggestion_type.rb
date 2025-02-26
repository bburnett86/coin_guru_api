class AddConstraintToSuggestionType < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      ALTER TABLE suggestions
      ADD CONSTRAINT suggestion_type_check
      CHECK (suggestion_type IN ('public', 'custom'));
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE suggestions
      DROP CONSTRAINT suggestion_type_check;
    SQL
  end
end
