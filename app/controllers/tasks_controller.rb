class TasksController < ApplicationController
 before_action :require_user_logged_in
 before_action :correct_user, only: [:show,:edit,:update,:destroy,]

 def index
  if logged_in?
   @user = current_user
   @task = current_user.tasks.build  # form_for 用
   @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
  end
 end
 
 def show
   @task = current_user.tasks.find_by(id: params[:id])
 end
 
 def new
  @task = current_user.tasks.build
 end
 
 def create
  @task = current_user.tasks.build (task_params)
   if @task.save
      flash[:success] = "Task が送信されました"
      redirect_to root_url
   else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = "Task が送信されませんでした"
      render 'new'
   end
 end
 
 def edit
  @task = current_user.tasks.find_by(id: params[:id])
 end
 
 def update
  @task = Task.find(params[:id])
   if @task.update(task_params)
    flash[:success] = "Taskは更新されました"
    redirect_to @task
   else
    flash.now[:danger] = "Taskは更新されませんでした"
    render :edit
   end
 end
 
 def destroy
  @task.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
 end
 
 private
 
 def task_params
  params.require(:task).permit(:content, :status)
 end
 
 def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
 end
end
