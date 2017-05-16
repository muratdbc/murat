class ExternalCalendar
  require 'icalendar'
  def self.convert_to_array_of_events(calendar)
    cals = Icalendar::Calendar.parse(calendar)
    cal = cals.first
    events = cal.events
    events_array=[]
    events.each do |event|
      events_array.push(to_hash(event))
    end
    return events_array
  end
  def self.to_hash(event)
    calendar_hash={}
    calendar_hash["start_date"]=event.dtstart.to_date
    calendar_hash["end_date"]=event.dtend.to_date
    calendar_hash["summary"]=event.summary
    calendar_hash["location"]=event.location
    calendar_hash["description"]=event.description
    calendar_hash["back_to_back"]=event.comment.length==1 ? true : false
    calendar_hash["external_key"]= event.description.match(/KEY: \S{8}/)[0].split(":")[1].strip rescue "XXXXXXXX"
    return calendar_hash
  end
  def self.future_events(events)
      t = Time.now
      events.inject([]) {|future,e| e["start_date"] > t ? future.push(e) : future}
  end
  def self.process_events(events)
    Job.where(:external_source => 'RENTLEVER').where("job_date > ?",Time.now).update_all('is_deleted=true')
    # Find all the jobs that are in the future from this calendar and make them is_active=false
    events.each do  |e|
      job=Job.where(:external_key => e["external_key"])[0]
      p job.nil?
      if(job.nil?)
        Job.create({:job_date=>e["start_date"],:notes =>e["summary"],
          :back_to_back =>e["back_to_back"] ? true : false,
        :location =>e["location"],:access_code =>e["description"],
        :external_key =>e["external_key"],:external_source =>"RENTLEVER"})
      else
        p "there"
        job["back_to_back"]=e["back_to_back"] ? true : false
        job["is_deleted"]=false
        job["updated_at"]=Time.now
        job["job_date"]=e["start_date"]
        job["notes"]= e["summary"]
        job["location"] = e["location"]
        job["access_code"] = e["description"]
        job.save!
        # update is_deleted and updated_at
      end
    end
  end
end
