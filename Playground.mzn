enum P; 
array[P] of int: hour;
set of int: T = 1..24;
array[P,T] of bool: free;
array[P,T] of var int: assign;

constraint forall (t in T, p in P) (
  assign[p,t] in (0..1)
);

constraint forall (t in T) (
  1 >= sum (p in P)(assign[p,t])
);

constraint forall (p in P) (
  hour[p] = sum (t in T)(assign[p,t])
);

constraint forall (p in P, t in T) (
  (assign[p,t] = 1) -> free[p,t]
);

var int: t_max;

constraint forall (p in P, t in T) (
    (assign[p,t] = 1) -> (t <= t_max)
);

constraint exists (p in P) (
  assign[p,t_max] = 1
);

solve minimize t_max;

output [ "LAST HOUR:  " ++ show(t_max) ++ "\n"];
output [ "SOLUTION:  \n" ++ format_justify_string(10,"") ++ "\t"];
output [  format_justify_string(2,show(j)) ++ 
          if j == 24 then "\n" else " " endif |
          j in T
];
output [ if j == 1 then format_justify_string(10,show(P[i])) ++ "\t" else "" endif ++
         format_justify_string(2,show(assign[i,j])) ++
         if j == 24 then "\n" else " " endif |
         i in P, j in T
];