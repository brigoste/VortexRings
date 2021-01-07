#=
Foil Shape equation - equal contour
1-1-2021
Author: Brigham Ostergaard
=#

#=
  foilShape(x, m)
  foilShape is used to determine the thickness of the foil at a given position
    along its lateral axis. x is the position along the foil and m is the value
    of maximum thickness

  t = 10m * (0.2969√(x) - 0.1260x -0.3537x^2 + 0.2843x^3 - 0.1015x^4)
=#

import Plots

function foilShape(x, m)
    #Determines foil thickness at length x from left side.

  a =  0.2969*sqrt(x);
  b = 0.1260*x;
  c = 0.3537*(x^2);
  d = 0.2843 * (x^3);
  e = 0.1015 * (x^4);

  t = (10*m) * (a - b - c + d - e)

  return t
end

function main()
  m = 0.1;                  #coefficient specific to wing shape.

  print("x   | y")          #title for table
  println()                 #formating

  for x = 0:0.1:1
    y = foilShape(x, m);
    print(x, " | ", y)
    #println()              #formating
  end

  #println()                #formating
end

Plots.plot([1,2,3], [1,6,2])
