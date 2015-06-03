import  numpy as np
cimport numpy as np
cpdef pruning_quick_combine(l,fn,seed_idx=None,max_evals=1e20,max_depth=5):
    """
    l is a list of object to quick_combine.
    the evaluation fn should accept idecies to your list and the list
    it should return a binary result on wether this set is good

    this search finds all combinations but assumes:
        that a bad subset can not be bettered by adding more nodes
        that a good set may not always be improved by a 'passing' superset (purging subsets will revoke this)

    if all items and their combinations pass the evaluation fn you get n**2 -1 solutions
    which leads to (2**n - 1) calls of your evaluation fn

    it needs more evaluations than finding strongly connected components in a graph because:
    (1,5) and (1,6) and (5,6) may work but (1,5,6) may not pass evaluation, (n,m) being list idx's

    """
    if seed_idx:
        non_seed_idx = [i for i in range(len(l)) if i not in seed_idx]
    else:
        #start from every item
        seed_idx = range(len(l))
        non_seed_idx = []
    mapping =  seed_idx+non_seed_idx
    unknown = [[node] for node in range(len(seed_idx))]
    # print mapping
    results = []
    prune = []
    while unknown and max_evals:
        path = unknown.pop(0)
        max_evals -= 1
        # print '@idx',[mapping[i] for i in path]
        # print '@content',path
        if not len(path) > max_depth:
            # is this combination even viable, or did a subset fail already?
            if not any(m.issubset(set(path)) for m in prune):
                #we have not tested this and a subset of this was sucessfull before
                if fn([l[mapping[i]] for i in path]):
                    # yes this was good, keep as solution
                    results.append([mapping[i] for i in path])
                    # lets explore more by creating paths to each remaining node
                    decedents = [path+[i] for i in range(path[-1]+1,len(mapping)) ]
                    unknown.extend(decedents)
                else:
                    # print "pruning",path
                    prune.append(set(path))
    return results
