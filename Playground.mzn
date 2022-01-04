% Peoples in the office
enum Person; 
% job for each person
array[Person] of int: job;
% starting and end office time
int: start;
int: end;
set of int: HOURS = start..end;

array[Person,HOURS] of bool: free;

array[Person,HOURS] of var int: assign;

constraint forall (h in HOURS) (
  forall (p in Person) (
    assign[p,h] in (0..1)
  )
);

constraint forall (h in HOURS) (
  1 >= sum (p in Person)(assign[p,h])
);

constraint forall (p in Person) (
  job[p] = sum (h in HOURS)(assign[p,h])
);

constraint forall (p in Person) (
  forall (h in HOURS) (
    (assign[p,h] = 1) -> free[p,h]
  )
);

var int: max;

constraint forall (p in Person) (
  forall (h in HOURS) (
    (assign[p,h] = 1) -> (h <= max)
  )
);

constraint exists (p in Person) (
  assign[p,max] = 1
);

solve minimize max;

output [ "MAX:  " ++ show(max) ++ "\n"];
output [ "SOLUTION:  \n" ++ format_justify_string(10,"") ++ "\t"];
output [  format_justify_string(2,show(j)) ++ 
          if j == end then "\n" else " " endif |
          j in HOURS
];
output [ if j == start then format_justify_string(10,show(Person[i])) ++ "\t" else "" endif ++
         format_justify_string(2,show(assign[i,j])) ++
         if j == end then "\n" else " " endif |
         i in Person, j in HOURS
];