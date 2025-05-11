class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  def new
    @task = Task.new
  end


  def edit
    # Render the edit form in the task_form turbo frame
    respond_to do |format|
      format.html # Regular edit page fallback
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "task_form",
          partial: "form",
          locals: { task: @task }
        )
      }
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Task was successfully updated."
          # After update, replace the form with a new task form
          render turbo_stream: [
            turbo_stream.replace(
              "task_form",
              partial: "form",
              locals: { task: Task.new }
            ),
            turbo_stream.replace(
              @task,
              partial: "task",
              locals: { task: @task }
            )
          ]
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream {
          # On error, keep the edit form with errors
          render turbo_stream: turbo_stream.replace(
            "task_form",
            partial: "form",
            locals: { task: @task }
          )
        }
      end
    end
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Task was successfully created." }
      else
        format.html { render partial: "form", locals: { task: @task }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "task_form",
            partial: "form",
            locals: { task: @task }
          )
        }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully deleted." }
      format.turbo_stream {
        flash.now[:notice] = "Task was successfully deleted."
        render turbo_stream: [
          turbo_stream.remove(@task),
          turbo_stream.replace("task_stats", partial: "tasks/stats", locals: { tasks: Task.all })
        ]
      }
    end
  end

  def new_form
    @task = Task.new
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "task_form",
          partial: "form",
          locals: { task: @task }
        )
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :completed)
    end
end
