def fractal(size, depth=0)
  if depth <= 0
    forward(size)
  else
    fractal(size/3, depth-1); turn_left(60)
    fractal(size/3, depth-1); turn_left(-120)
    fractal(size/3, depth-1); turn_left(60)
    fractal(size/3, depth-1)
  end
end

turn_right(90)
backward(200)
pen_down
fractal(400, 3)
