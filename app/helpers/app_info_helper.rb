module AppInfoHelper
  def check_mongo_db
    begin
      Mongoid.default_client.database_names.present?
    rescue StandardError => e
      "error: #{e}"
    end
  end
end
