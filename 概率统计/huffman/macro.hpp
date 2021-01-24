#ifndef MACRO_HPP
#define MACRO_HPP


#define DISABLE_ALL(classname) \
            classname() = delete;\
            classname(const classname&) = delete;\
            ~classname() = delete;\
            classname operator = (const classname&) = delete;

#endif