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
Time required for numpy :0.0010199546814

On increasing the sample size to 1000 the time required for cython implementation was:0.00103092193604


##
Time required for numexpr:0.0524370670319

On increasing the sample size to 1000 the time required for cython implementation was: 0.0629789829254


##
Time required for cython implementation: 0.00037693977356

On increasing the sample size to 1000 the time required for cython implementation was: 0.000943183898926

##Cython Implementation of GetAnglesPolyline function
Time required for GetAnglesPolyline(implemented 10 times):0.000600099563599.

Time required for cython implemetation :0.00056004524231

###Cython implementation of prune_quick_combine function
Time required for prune_quick_combine(10 times):0.00080394744873.

Time required for cython implemetation :0.000550031661987.

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


| Dist_pts_ellipse 	| Sample size 200  	| Speedup 	| Sample size 1000  	| Speedup 	|
|------------------	|------------------	|---------	|-------------------	|---------	|
| Time for numpy   	| 0.0010199546814  	| 1       	| 0.00103092193604  	| 1       	|
| Time for numexpr 	| 0.0524370670319  	| 0.019   	| 0.0629789829254   	| 0.0163  	|
| Time for cython  	| 0.00037693977356 	| 2.706   	| 0.000943183898926 	|         	|

|**GetAnglesPolyline**   | **Implemented 10 times** | **Speedup** |
|Time for python code    |  0.000600099563599       |     1       |
|Time for cython         |  0.00056004524231        |    1.07     |


|**prune_quick_combine**   |  **Implemented 10 times**  | **Speedup**  |
| Time for python code     |  0.00080394744873.         |     1        |
| Time for cython          |  0.000550031661987         |    1.46      |
