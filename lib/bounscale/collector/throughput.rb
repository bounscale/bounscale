# -*- encoding: utf-8 -*-
class Bounscale::Collector::Throughput < Bounscale::Collector::Busyness
  def pre
  end
  
  def post
  end
  
  def name
    "throughput"
  end
  
  def value
    #2つ以上のアクセスがないと測定不能なので0を返す
    return 0 if history.length < 2
    
    #リクエスト数 / 全体の時間 がスループット(分あたり換算なので60をかける)
    (history.length.to_f / whole_sec) * 60
  end
end