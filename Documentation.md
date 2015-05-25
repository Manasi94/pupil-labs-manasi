#Documentation:
Installation of necessary modules:
Cython

## Implementation of timeit function
Added timeit functionality to check the time required for the function to run
###Code:

from timeit import Timer
t = Timer(lambda: dist_pts_ellipse(ellipse,pts))
print t.timeit(number=5)

## Benchmarking:
created a random 1000 points  whose distance need to be calculated from the ellipse.
