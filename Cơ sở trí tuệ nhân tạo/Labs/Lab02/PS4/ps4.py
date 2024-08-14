def Standardize(s):
    s = list(set(s))
    s = sorted(s, key = lambda x: x[-1])
    for i in range(1, len(s)):
        if s[i - 1][-1] == s[i][-1]:
            return [1]
    return s

def Union(c1, c2, c3):
    res = list(set(c1) | set(c2))
    res.remove(c3)
    res.remove("-"+c3)
    res = sorted(res, key = lambda x: x[-1])
    return res

def PL_resolve(c1, c2):
    cont = []
    for i in c1:
        for j in c2:
            if len(i) != len(j) and i[-1] == j[-1]:
                cont.append(i[-1])
    if len(cont) != 1:
        return [-1]
    else:
        return Union(c1, c2, cont[0])
    
def PL_resolution(kb, a):
    global output
    n = len(kb)
    clauses = set()
    a = a.replace(" ", "")
    a = a.replace("\n", "")
    a = a.split("OR")
    a = Standardize(a)
    if a[0] == 1: return True
    for i in a:
        if len(i) == 2:
            clauses.add(tuple([i[-1]]))
        else:
            clauses.add(tuple(["-" + i]))
    for i in range(n):
        kb[i] = kb[i].replace(" ", "")
        kb[i] = kb[i].replace("\n", "")
        kb[i] = kb[i].split("OR")
        kb[i] = Standardize(kb[i])
        if kb[i][0] != 1: clauses.add(tuple(kb[i]))
        
    n = len(clauses)
    while True:
        res = set()
        i = 0
        for i in clauses:
            for j in clauses:
                resolvents = PL_resolve(i, j)
                if len(resolvents) == 0:
                    output.append(res)
                    return True
                if(resolvents[0] != -1 and (tuple(resolvents) not in clauses)): res.add(tuple(resolvents))
        if len(res) == 0: return False
        clauses = clauses | res
        output.append(res)

if __name__=="__main__":
    global output
    output = []
    inFile = open("input.txt", "r")
    a = inFile.readline()
    n = int(inFile.readline())
    kb = []
    for i in range(n):
        kb.append(inFile.readline())
    inFile.close()
    flag = PL_resolution(kb, a)
    outFile = open("output.txt", "w")
    for i in output:
        outFile.write(str(len(i)) + "\n")
        for j in i:
            tmp = " OR ".join(j)
            outFile.write(tmp + "\n")
    if flag: outFile.write("{}\nYES")
    else: outFile.write("0\nNO")
    outFile.close()
        
