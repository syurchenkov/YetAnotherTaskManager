module Users::TasksHelper
  def correct_task_user?
    current_user?(@user) || current_user.admin?
  end

  def task_state_to_css_class state
    case state
    when 'new' then 'danger'
    when 'started' then 'warning'
    when 'finished' then 'success'
    end
  end

  def task_state_path task
    case task.state 
    when 'new' 
      start_user_task_path(task.user, task)
    when 'started'
      finish_user_task_path(task.user, task)
    else 
      rewind_user_task_path(task.user, task)
    end
  end

  def task_state_action task 
    case task.state
    when 'new'
      'start'
    when 'started' 
      'finish'
    else 
      'rewind'
    end
  end
end
