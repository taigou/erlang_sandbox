-module(shape).
-export([area/1, perimeter/1]).

-record(circle,    { radius }).
-record(rectangle, { length, width }).
-record(triangle,  { a,b,c }).

perimeter(#circle   { radius=Radius })              -> (Radius * 2) * math:pi();
perimeter(#rectangle{ length=Length, width=Width }) -> (Length + Width) * 2;
perimeter(#triangle { a=A, b=B, c=C })              -> A+B+C.

area(#circle   { radius=Radius })              -> Radius * Radius * math:pi();
area(#rectangle{ length=Length, width=Width }) -> Length * Width;
area(#triangle { a=A, b=B, c=C })              -> S=(A+B+C)/2, math:sqrt(S*(S-A)*(S-B)*(S-C)).
