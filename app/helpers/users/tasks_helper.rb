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

  def task_state_link task
    case task.state 
    when 'new' 
      link_to 'start', user_task_start_path(task.user, task), method: :patch, class: 'btn btn-default'
    when 'started'
      link_to 'finish', user_task_finish_path(task.user, task), method: :patch, class: 'btn btn-default'
    else 
      link_to 'rewind', user_task_rewind_path(task.user, task), method: :patch, class: 'btn btn-default' 
    end
  end
end
