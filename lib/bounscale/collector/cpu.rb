class Bounscale::Collector::Cpu < Bounscale::Collector::Base
  def pre
    @pre_user_time = Process.times.utime
    @pre_system_time = Process.times.stime
  end
  
  def post
    @post_user_time = Process.times.utime
    @post_system_time = Process.times.stime
    @elapsed_user_time =  @post_user_time - @pre_user_time
    @elapsed_system_time = @post_system_time - @pre_system_time
  end
  
  def name
    "cpu"
  end
  
  def value
    (@elapsed_user_time + @elapsed_system_time) * 1000
  end
end