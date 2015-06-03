from prune import pruning_quick_combine
from timeit import Timer

def metric(l):
    """
    example metric for search
    """
    # print 'evaluating', idecies
    global evals
    evals +=1
    return sum(l) < 3

l = [1,2,1,0,1,0]
evals = 0
#r = pruning_quick_combine(l,metric,[2])
#print "r"
#print r
t = Timer(lambda:pruning_quick_combine(l,metric,[2]))
print "Time required for pruning_quick_combine"
print t.timeit(number=10)
