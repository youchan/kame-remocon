def koch(length, depth)
  if depth <= 0
    forward(length)
    return
  end

  koch(length / 3, depth - 1)
  turn_left(60)

  koch(length / 3, depth - 1)
  turn_right(120)

  koch(length / 3, depth - 1)
  turn_left(60)

  koch(length / 3, depth - 1)
end

depth = 3
length = 200
forward(100)
pen_down
4.times do
  turn_right(90)
  koch(length, depth)
end

