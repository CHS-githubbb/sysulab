COMPILER=g++
ZIP=ziptxt
UNZIP=unziptxt
ADZIP=adziptxt
ADUNZIP=adunziptxt



.PHONY: all
all: zip unzip adzip adunzip

zip:
	$(COMPILER) huffman/Compresser.cpp -o $(ZIP)

unzip:	 
	$(COMPILER) huffman/Decompresser.cpp -o $(UNZIP)

adzip:
	$(COMPILER) adaptivehuffman/AdaptCompresser.cpp adaptivehuffman/AdaptiveHuffmanCoder.cpp adaptivehuffman/Node.cpp -o $(ADZIP)

adunzip:
	$(COMPILER) adaptivehuffman/AdaptDecompresser.cpp adaptivehuffman/AdaptiveHuffmanCoder.cpp adaptivehuffman/Node.cpp -o $(ADUNZIP)


.PHONY: clean
clean:
	rm $(ZIP) $(UNZIP) $(ADZIP) $(ADUNZIP)

