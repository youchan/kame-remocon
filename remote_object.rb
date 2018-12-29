require_relative "app/commander"

class RemoteObject
  def set_turtle(turtle)
    @turtle = turtle
    nil
  end

  def exec(&block)
    if @turtle
      @turtle.clear
      @turtle.reset
      commander = @turtle.new_commander
      commander.instance_eval &block
    end
  end

  def exec_bulk(&block)
    if @turtle
      @turtle.clear
      @turtle.reset
      commander = Commander.new
      commander.instance_eval &block
      @turtle.exec_commands(commander.commands, wait: 0)
    end
  end
end
