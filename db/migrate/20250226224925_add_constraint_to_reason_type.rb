class AddConstraintToReasonType < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      ALTER TABLE reasons
      ADD CONSTRAINT reason_type_check
      CHECK (type IN ('transaction_data', 'rug_pull', 'token_supply', 'social_media_presence', 'black_list', 'summary'));
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE reasons
      DROP CONSTRAINT reason_type_check;
    SQL
  end
end