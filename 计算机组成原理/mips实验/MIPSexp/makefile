assembler=mips-linux-gnu-as
linker=mips-linux-gnu-ld
src=sort.S
obj=ex.o
dest=ex



$(dest):$(obj)
	$(linker) -g $(obj) -e main -o ./$(dest)

$(obj):
	$(assembler) -g $(src) -o $(obj)



.PHONY : clean
clean :
	rm $(obj) $(dest)
