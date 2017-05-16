class JobsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create, :destroy]
  def main
  end
  def create
    job = Job.new(job_params)

    if job.save
        render json: {status: 'Job created successfully'}, status: :created
      else
        render json: { errors: job.errors.full_messages }, status: :bad_request
      end
  end
  def index
    jobs=Job.all
    render json: {jobs: jobs}, status: :ok
  end
  def show
    job=Job.find(params[:id])
    render json: {job: job}, status: :ok
  end

  def update
  end

  def destroy
    job=Job.find(params[:id])
    job.is_deleted=true
    updated_count=job.save!
    render json: {is_updated: updated_count}, status: :ok
  end

  private

  def job_params
    params.require(:job).permit(:job_date, :notes, :job_time,:user_id)
  end
end
