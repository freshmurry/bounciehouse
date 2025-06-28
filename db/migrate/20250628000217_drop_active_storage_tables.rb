class DropActiveStorageTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :active_storage_attachments if table_exists?(:active_storage_attachments)
    drop_table :active_storage_blobs if table_exists?(:active_storage_blobs)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
