#Documentation:
Installation of necessary modules:
Cython

## Implementation of timeit function
Added timeit functionality to check the time required for the function to run
###Code:

```python
from timeit import Timer
t = Timer(lambda: dist_pts_ellipse(ellipse,pts))
print t.timeit(number=5)
```

## Benchmarking:
created a random 1000 points  whose distance need to be calculated from the ellipse.
### Results of Benchmarking

Timeit Function is used to find the time required for the functions to evaluate the answer repeating if 5 times
##
Time required for numpy :
0.0010199546814

##
Time required for numexpr:
0.0524370670319

##
Time reuired for cython implementation:
0.00037693977356

