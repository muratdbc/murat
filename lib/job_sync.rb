class JobSync
  require 'open-uri'
  def self.get_icalendar
    open(Rails.application.config.rentlever_job_snyc_domain)
  end
end
