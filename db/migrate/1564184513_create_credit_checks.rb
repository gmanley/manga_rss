Sequel.migration do
  up do
    create_table(:credit_checks) do
      primary_key :id

      String :first_name
      String :last_name
      Date :date_of_birth
      String :phone_number
      String :street
      String :city
      String :state
      String :zipcode
      Integer :score
      String :request_parameters
      String :response_xml
      String :request_xml
      String :error
      String :external_id

      @db.create_enum(:credit_check_status, %w(success failure no_hit no_credit invalid))
      credit_check_status :status

      DateTime :created_at, null: false
      DateTime :updated_at
    end
  end

  down do
    drop_table :credit_checks
    drop_enum :credit_check_status
  end
end
