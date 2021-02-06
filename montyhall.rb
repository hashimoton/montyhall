# coding: utf-8
# 
# モンティ・ホール問題(Monty Hall Problem)
# https://ja.wikipedia.org/wiki/%E3%83%A2%E3%83%B3%E3%83%86%E3%82%A3%E3%83%BB%E3%83%9B%E3%83%BC%E3%83%AB%E5%95%8F%E9%A1%8C
# 


# 出演者
class Cast

  def initialize(name)
    @name = name
  end

  # 発言
  def say(message)
    puts "#{@name}: #{message}"
  end
  
end


# 司会者
class Host < Cast

  # 景品のあるドアを確認して開始
  def initialize(name)
    super(name)
    @doors = ['A','B','C']
    @prize = @doors[rand(3)]
    say "では、始めましょう"
  end

  # 選択肢を提示
  def show_doors
    say "ドアを選んでください #{@doors}"
    return @doors
  end
  
  # 不正解のドアを開けてみせる
  def open_hint(choice)
    hint = @doors.select{|door| door != @prize && door != choice}.sample
    @doors.delete(hint)
    say "ここでヒント、#{hint}はハズレです"
    say "違うドアに変えますか?"
    return @doors
  end

  # 選ばれたドアを開ける
  def unvail(choice)
    is_correct = (choice == @prize)
    if is_correct
      say "おめでとう! #{@prize}でしたね!"
    else
      say "残念... 正解は#{@prize}でした"
    end
    return is_correct
  end
  
end


# 挑戦者
class Challenger < Cast
  
  # 最初にドアを選択
  def choose_door(doors)
    @choice = doors.sample
    say @choice
    return @choice
  end
  
  # ヒントを見た後でドアを選択
  def choose_door_again(doors, strategy)
    if strategy[:switch]
      switch(doors)
    else
      stay
    end
    say @choice
    return @choice
  end
  
  # ドアを変更
  def switch(doors)
    say "変えます"
    @choice = doors.select{|door| door != @choice}.first
  end
  
  def stay
    say "このままで"
  end

end


# ゲームをやってみる
def play_game

  # 司会者と挑戦者
  host = Host.new("司会者")
  challenger = Challenger.new("挑戦者")
  
  # 挑戦者がドアを選ぶ
  doors = host.show_doors
  initial_choice = challenger.choose_door(doors)
  
  # 司会者がヒントとして不正解のドアを開ける
  new_doors = host.open_hint(initial_choice)
  
  # ヒントを見た挑戦者がドアを変えるか選ぶ
  second_choice = challenger.choose_door_again(new_doors, switch: true)
  
  # 選んだドアを開ける
  is_correct = host.unvail(second_choice)
  
  return is_correct
end


# ゲームを何度もやってみる

correct_count = 0
1000.times do |n|
  puts "#{n+1}回目"
  correct_count += play_game ? 1 : 0
  puts "累計正解#{correct_count}回"
end


# EOF

