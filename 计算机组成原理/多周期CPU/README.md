# 多周期CPU实验作业文件说明

## MulticycleCPU.srcs
多周期CPU的vivado实现中的srcs文件夹，在运行时需要在vivado实现中的**RegisterFile**模块中将读取文件的路径更换成运行环境下**test_ins.txt**文件的**绝对路径**(这一步对仿真无影响，但是烧板时使用相对路径会产生无法读取文件的情况)。
## mips_compiler.cpp
该文件是mips代码的编译器，可通过命令**g++ mips_compiler.cpp -o prog** 编译，为方便观察结果，该程序编译mips代码的结果将直接输出，而非保存到文件中。
## mips.txt
实验要求的测试指令，用于**mips_compiler.cpp**编译mips代码。
## test_ins.txt
实验要求的测试指令对应的机器码
## report.pdf
多周期CPU实验报告
