Sequel.migration do
    up do
      create_table(:users) do
        primary_key   :id
        String        :name
        String        :password
    #    DateTime      :created_at,   default: Sequel::CURRENT_TIMESTAMP
    #    DateTime      :updated_at,   default: Sequel::CURRENT_TIMESTAMP
      end
    end
  
    down do
      drop_table(:users)
    end
  end
  