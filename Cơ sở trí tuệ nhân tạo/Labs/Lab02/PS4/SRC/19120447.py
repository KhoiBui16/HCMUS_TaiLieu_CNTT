import os

def GetFiles(path):
    file_list = []
    for dir, subdirs, files in os.walk(path):
        file_list.extend([f for f in files])
    return file_list

def Standardize(s):
    # Loại bỏ các literal trùng nhau trong s
    s = list(set(s))
    # Sắp xếp các literal trong s theo bảng chữ cái
    s = sorted(s, key = lambda x: x[-1])
    # Duyệt qua các literal để tìm ra có 2 literal đối ngẫu thì trả về 1 (True)
    for i in range(1, len(s)):
        if s[i - 1][-1] == s[i][-1]: return [1]
    # Trả về s được chuẩn hóa
    return s

def Union(c1, c2, c3):
    # Hợp c1 và c2
    res = list(set(c1) | set(c2))
    # Bỏ đi literal đối ngẫu
    res.remove(c3)
    res.remove("-"+c3)
    # Sắp xếp các literal theo bảng chữ cái
    res = sorted(res, key = lambda x: x[-1])
    # Trả kết quả hợp giải
    return res

def PL_Resolve(c1, c2):
    # Nếu c1 và c2 chứa từ 2 literal đối ngẫu nhau thì khi hợp giải sẽ ra True
    # cont là biến chứa các literal đối ngẫu trong c1 và c2 (lưu 1 biến dưới dạng dương)
    cont = []
    # Duyệt hết các cặp literal trong c1 và c2
    for i in c1:
        for j in c2:
            # Nếu i và j đối ngẫu thì thêm vào cont
            if len(i) != len(j) and i[-1] == j[-1]: cont.append(i[-1])
    # Nếu cont chứa từ 2 đối ngẫu thì trả về -1 đánh dấu là mệnh đề True không cần xét
    if len(cont) != 1: return [-1]
    # Ngược lại thì trả về hợp giải c1 và c2 bằng cách lấy c1 hợp c2 hiệu với các literal đối ngẫu
    else: return Union(c1, c2, cont[0])
    
def PL_Resolution(kb, a):
    global output
    # n là số mệnh đề trong KB
    n = len(kb)
    # clauses là tập chứa các mệnh đề có sẵn và phát sinh trong quá trình hợp giải
    clauses = set()
    # Chuẩn hóa a thành một list chứa các literal trong mệnh đề
    a = Standardize(a.replace(" ", "").replace("\n", "").split("OR"))
    # Nếu a là mệnh đề mang giá trị True thì trả về True
    if a[0] == 1: return True
    # Phủ định mệnh đề a và đưa vào clauses
    for i in a:
        if len(i) == 2: clauses.add(tuple([i[-1]]))
        else: clauses.add(tuple(["-" + i]))
    # Đưa các mệnh đề trong KB vào clauses
    for i in range(n):
        # Chuẩn hóa mệnh đề i thành một list chứa các literal
        kb[i] = Standardize(kb[i].replace(" ", "").replace("\n", "").split("OR"))
        # Đưa mệnh đề i vào clauses
        if kb[i][0] != 1: clauses.add(tuple(kb[i]))
    # n là số mệnh đề trong clauses và flag là biến đánh dấu kết quả trả về 
    n, flag = len(clauses), False
    while True:
        # new là tập các mệnh đề phát sinh trong vòng lặp này
        new = set()
        # Duyệt qua các cặp mệnh đề i, j trong clauses
        for i in clauses:
            for j in clauses:
                resolvents = PL_Resolve(i, j) # resolvents là kết quả i hợp giải j
                if len(resolvents) == 0: # nếu resolvents là rỗng
                    flag = True # đánh dấu flag = True (tức KB entails a)
                    new.add(tuple(['{}'])) # Thêm {} vào new
                # Nếu resolvents là mệnh đề True hoặc không nằm trong clauses thì thêm nó vào new
                elif(resolvents[0] != -1 and (tuple(resolvents) not in clauses)): new.add(tuple(resolvents))
        # Thêm new vào output
        output.append(new)
        # Nếu không phát sinh thêm mệnh đề nào sau lần lặp này thì trả về False
        if not(flag) and len(new) == 0: return False
        # Thêm new vào tập clauses
        clauses = clauses | new
        # Nếu flag == True thì trả về True
        if flag: return True

if __name__=="__main__":
    # Khai báo biến output là biến toàn cục để chứa các lần hợp giải
    global output
    # Lấy tên các file inputk.txt trong thư mục input và lưu vào file_list
    file_list = GetFiles(os.path.dirname(os.path.abspath(__file__)) + "\input")
    # Duyệt qua từng file input trong file_list
    for file in range(1, len(file_list) + 1):
        # Khởi tạo output là list rỗng
        output = []
        ####### Đọc dữ liệu đầu vào ###########################################
        inFile = open("input\\input" + str(file) + ".txt", "r")
        a = inFile.readline() # câu alpha
        n = int(inFile.readline()) # số mệnh đề trong KB
        kb = [] # KB
        # đọc các mệnh đề trong KB
        for i in range(n):
            kb.append(inFile.readline())
        inFile.close()
        ########################################################################
        ####### Gọi hàm PL_Resolution để thực hiện hợp giải ####################
        flag = PL_Resolution(kb, a)
        ########################################################################
        ####### Ghi dữ liệu đầu ra #############################################
        outFile = open("output\\output" + str(file) + ".txt", "w")
        for i in output: # i là tập các mệnh đề trong một vòng lặp
            outFile.write(str(len(i)) + "\n") # ghi số mệnh đề trong vòng lặp i
            # ghi ra các mệnh đề trong i
            for j in i: 
                tmp = " OR ".join(j)
                outFile.write(tmp + "\n")
        if flag: outFile.write("YES") # ghi "YES" nếu KB entails alpha
        else: outFile.write("NO") # ghi "NO" nếu ngược lại
        outFile.close()
        ########################################################################
        
