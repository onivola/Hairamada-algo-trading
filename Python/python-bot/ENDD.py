numInput=16;
numHiddenA = 4;
numHiddenB = 5;
numOutput=3;

def WHiddenA():
	return numInput*numHiddenA

def WHiddenB():
	return numHiddenA*numHiddenB

def WOutput():
	return numHiddenB*numOutput

def BHiffenA():
	return numHiddenA

def BHiffenB():
	return numHiddenB

def BOutput():
	return numOutput

def TotalWinput():
	return WHiddenA()+WHiddenB()+WOutput()


for x in range(TotalWinput()):
	print("input double w"+str(x)+"=1.0;")

print("----------weight array----------")

for x in range(WHiddenA()):
	print("weight["+str(x)+"]=w"+str(x)+";")

print("----------B0-B3----------")

wa = WHiddenA()+4
for x in range(wa, wa+WHiddenB()):
	print("weight["+str(x)+"]=w"+str(x-4)+";")


print("----------B4-B8----------")



wa = WHiddenA()+WHiddenB()+5+4
for x in range(wa, wa+WOutput()):
	print("weight["+str(x)+"]=w"+str(x-5-4)+";")

print("----------B9-B11----------")