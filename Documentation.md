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

repeating if 5 times

###Drivers control
Example dict

```python
{
'display_name': 'Auto Focus',
'unit': 'input_terminal', <- This is either 'input_terminal' or 'processing_unit' which one can be found in cuvc.pxd
,'control_id': uvc.UVC_CT_FOCUS_AUTO_CONTROL , <- you find this in libuvc.h
'bit_mask': 1<<17, <- you find this in cuvc.pxd
'offset': 0 , <-- found in the attached file look at p81-p100
'data_len': 1 , <- called size in the attache file same pages
'buffer_len': 1, <- usually the same as data-len, except when a control has an offset, then a multiple.
'min_val': 0, <- either defined in the attached file. (If the control supports a GET_MIN call this field is 'None')
'max_val': 1, <- same as above, but GET_MAX
'step':1, <- same as above, but GET_RES
'def_val':None, <- same as above but GET_DEF
'd_type': bool, <- either int, bool or a dict with menu entries.
'doc': 'Enable the Auto Focus' <- short description of what the control does.
}
```

####Doubts
The min_val and max_val is not specified in certain cases. What should be done with them in particular?
When the offset is a non zero value what should be the order followed for writing d_type?

### Results of Benchmarking

Timeit Function is used to find the time required for the functions to evaluate the answer


| Dist_pts_ellipse 	| Sample size 200  	| Speedup 	| Sample size 1000  	| Speedup 	|
|------------------	|------------------	|---------	|-------------------	|---------	|
| Time for numpy   	| 0.0010199546814  	| 1       	| 0.00103092193604  	| 1       	|
| Time for numexpr 	| 0.0524370670319  	| 0.019   	| 0.0629789829254   	| 0.0163  	|
| Time for cython  	| 0.00037693977356 	| 2.706   	| 0.000943183898926 	| 1.093    	|

| GetAnglesPolyline 	| Implemented 10 times 	| Speedup 	|
|-------------------	|----------------------	|---------	|
| Time for python   	| 0.000600099563599    	| 1       	|
| Time for cython   	| 0.00056004524231     	| 1.07    	|



| prune_quick_combine	| Implemented 10 times 	| Speedup 	|
|-------------------	|----------------------	|---------	|
| Time for python   	| 0.00080394744873    	| 1       	|
| Time for cython   	| 0.00055003166198     	| 1.46     	|


| filter            	| Implemented 1000 times| Speedup 	|
|-------------------	|----------------------	|---------	|
| Time for ctypes    	| 0.989124059677     	  | 1       	|
| Time for cython   	| 0.459467887878       	| 2.153    	|



| square_marker_detect     	| Implemented 100 times 	| Speedup 	|
|-------------------------	|-----------------------	|---------	|
| Time for python code      | 3.27636003494         	| 1       	|
| Time for cython code    	| 2.98566699028         	| 1.097   	|

=======

####Errors while writing dist_pts_ellipse
1. I had given the data type of the returned value of the function in the function definition itself. That throwed an error
2.  The dot product of pts and M_rot was modified since initially it showed error. Changed the syntax to this : ```python pts = pts.dot(M_rot) ```

### Filter function
1. The implementation of the filter function in cython is in the file filter.pyx .
2. Changed the arguments of area function to np.ndarray[np.float32_t, ndim=2] img .
3. To speed up the function changed the range() to xrange() in the for loops .
4. Also used local variables to store values used in the iterative nested for loop instead for accessing the value every iteration.

####Errors
1. The dimensions of the input array were not matching when i used the syntax np.float32_t(:,:). Changed the syntax to : ```python np.ndarray[np.float32_t, ndim=2] img```
2. Exception IndexError: 'index 6834 is out of bounds for axis 0 with size 101' in 'filter.area' ignored. The error was due to incorrect way of pointing to an element of an array. For C we considered a single dimensiom array
so we needed to multiply the rows with the column size to go to the next rown. In cython however we are directly using 2D arrays so no need for the multiplication

####Cython code
1. Using the -a switch to the cython command line program (or following a link from the Sage notebook) results in an HTML report of Cython code interleaved with the generated C code.
2.Lines are colored according to the level of “typedness” – white lines translate to pure C, while lines that require the Python C-API are yellow (darker as they translate to more C-API interaction).
3.Lines that translate to C code have a plus (+) in front and can be clicked to show the generated code.


####Profiling

1. Go to command line and type the following commands
```python
python -m cProfile -o profile.pstats main.py
gprof2dot -f pstats profile.pstats | dot -Tngg -o main.png
```
2. A main.png file will be created in your folder.Open it.
3. It has a graph of the profiling
4. If graph2dot is not installed use the foloowing command:
```
sudo pip install gprof2dot
```
