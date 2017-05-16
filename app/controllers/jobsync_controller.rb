class JobsyncController < ApplicationController
  require 'job_sync'
  require 'external_calendar'
  def sync
    icalendar=JobSync.get_icalendar
    events_array=ExternalCalendar.convert_to_array_of_events(icalendar)
    future_events=ExternalCalendar.future_events(events_array)
    ExternalCalendar.process_events(future_events)
    external_jobs=Job.where(:external_source => 'RENTLEVER')
    render json: {externalJobs: external_jobs}, status: :ok
  end
end
