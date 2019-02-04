require_relative "commander"

class RemoteObject
  def set_turtle(turtle)
    @turtle = turtle
    nil
  end

  def exec(str = nil, &block)
    if @turtle
      @turtle.clear
      @turtle.reset
      commander = @turtle.new_commander
      if str
        commander.instance_eval str
      elsif block
        commander.instance_eval &block
      end
    end
  end

  def exec_bulk(str = nil, &block)
    if @turtle
      @turtle.clear
      @turtle.reset
      commander = Commander.new
      if str
        commander.instance_eval str
      elsif block
        commander.instance_eval &block
      end
      @turtle.exec_commands(commander.commands, wait: 0)
    end
  end
end
