if exist  "E:\questasim64_10.6c" ( start E:\questasim64_10.6c\win64\questasim -do sim.do 
) else if exist   "D:\questasim64_10.6c" ( start D:\questasim64_10.6c\win64\questasim -do sim.do 
) else (echo "wrong path"  pause)
