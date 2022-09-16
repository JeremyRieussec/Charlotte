# How to create online Documentation

1) In code create documentation above struct, function, ... as follow:

WARNING: No spaces between last quotes and declaration of function, struct,...
```
"""
    my_function

This function does blablabla...
"""
function my_function()
    ...blablabla...
end
```

2) In /docs/src/index.md

Declare the struct, function name you want to appear in the documentation as follow in teh @docs bloc:

```
 ```@docs   
 Charlotte.my_function```
 
```
(if the function/struct name is exported, you don't need ```Charlotte.```)

3) You can add sections, sub-sections, ... like in every markdown file.

4) Run ```docs/make.jl```

5) Open ```docs/build/index.html```
