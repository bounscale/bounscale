class Bounscale::Collector::Memory < Bounscale::Collector::Base
  def pre
  end
  
  def post
    process = $$
    @post_memory = ps_value(process).split("\n")[1].to_f / 1024.0 rescue 0
  end
  
  def name
    "memory"
  end
  
  def value
    @post_memory
  end

  def ps_value(process)
    `ps -o rsz #{process}`
  end
end