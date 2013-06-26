# -*- encoding: utf-8 -*-
class Bounscale::Collector::Busyness < Bounscale::Collector::Base
  HISTORY_HOLDING_SEC = 10
  
  class << self
    def clear_history!
      Thread.current[:bounscale_busyness_history] = []
    end
  end
  
  def pre
    @pre_time = Time.now
  end
  
  def post
    @post_time = Time.now
    history << [@pre_time, @post_time]
    fix_history
  end
  
  def name
    "busyness"
  end
  
  def value
    #2つ以上のアクセスがないと測定不能なので0を返す
    return 0 if history.length < 2
    
    #積算値 / 全体の秒数 がビジー率(%なので100をかける)
    (estimate_sec / whole_sec) * 100
  end
  
  private
  def history
    Thread.current[:bounscale_busyness_history] ||= []
    Thread.current[:bounscale_busyness_history]
  end
  
  def fix_history
    history.delete_if do |h|
      (@post_time.to_f - h[1].to_f) > HISTORY_HOLDING_SEC
    end
  end
  
  def whole_sec
    #履歴の最初から最後までの秒数を算出
    oldest_pre  = history[0][0].to_f
    newest_post = history[-1][1].to_f
    whole_sec = newest_post - oldest_pre
  end
  
  def estimate_sec
    #各履歴の所要時間の積算値を算出
    result = 0.0
    history.each do |h|
      pre_time  = h[0].to_f
      post_time = h[1].to_f
      result += (post_time - pre_time)
    end
    result
  end
end