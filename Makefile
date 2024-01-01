
SDK_INSTALL_PATH :=  /usr/local/cuda
NVCC=$(SDK_INSTALL_PATH)/bin/nvcc
LIB       :=  -L$(SDK_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/samples/common/lib/linux/x86_64
#INCLUDES  :=  -I$(SDK_INSTALL_PATH)/include -I$(SDK_INSTALL_PATH)/samples/common/inc
OPTIONS   :=  -O3 
#--maxrregcount=100 --ptxas-options -v 

TAR_FILE_NAME  := your-name.tar
EXECS :=  vecadd-without-coalesced vecadd-with-coalesced
all:$(EXECS)

#######################################################################
clean:
	rm -f $(EXECS) *.o

#######################################################################
tar:
	tar -cvf $(TAR_FILE_NAME) Makefile *.h *.cu *.pdf *.txt
#######################################################################

timer.o : timer.cu timer.h
	${NVCC} $< -c -o $@ $(OPTIONS) -w

#######################################################################
vecaddKernel-without-coalesced.o : vecaddKernel-without-coalesced.cu
	${NVCC} $< -c -o $@ $(OPTIONS) -w

vecadd-without-coalesced : vecadd.cu vecaddKernel.h vecaddKernel-without-coalesced.o timer.o
	${NVCC} $< vecaddKernel-without-coalesced.o -o $@ $(LIB) timer.o $(OPTIONS)


#######################################################################
vecaddKernel-with-coalesced.o : vecaddKernel-with-coalesced.cu
	${NVCC} $< -c -o $@ $(OPTIONS) -w

vecadd-with-coalesced : vecadd.cu vecaddKernel.h vecaddKernel-with-coalesced.o timer.o
	${NVCC} $< vecaddKernel-with-coalesced.o -o $@ $(LIB) timer.o $(OPTIONS) -w