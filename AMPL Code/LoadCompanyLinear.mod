param MaxCargo;
param MaxComm;

set Comm:= 1..MaxComm;  
set Cargo:= 1..MaxCargo; 

#parameters of the commodities
param Avail {Comm} >=0;  
param Volume{Comm} >=0;
param Profit{Comm} >=0;

#percetage used for the balance constraint
param pct1 :=0.90;
param pct2 :=1.10;
param pct3 :=0.60;
param pct4 :=0.40;

#paramenters of the cargos
param MaxWeight{Cargo} >=0;
param MaxVolume{Cargo} >=0;

#our decision variable
var Activation{Comm,Cargo} binary;  
var QtyShip{Comm,Cargo}>=0 integer;

#check
#one-per link provides one commodities for cargo, so we have max 3 commodities to allocate
check: MaxComm >= 3; 


#objective_function
maximize Total_Profit : sum{Commodity in Comm}(Profit[Commodity]*sum{Link in Cargo} QtyShip[Commodity,Link]); 

#Linking constraint
subject to  Linking{Link in Cargo,Commodity in Comm}: 10000000 *Activation[Commodity, Link] >= QtyShip[Commodity,Link] ;

#One-per-link
subject to One_per_link{Link in Cargo}: sum{Commodity in Comm}Activation[Commodity,Link] == 1;

#Weight-Contraint
subject to Capacity_Weight{Link in Cargo}: sum{Commodity in Comm} QtyShip[Commodity,Link]<= MaxWeight[Link];

#Volume-Constraint
subject to Capacity_Volume{Link in Cargo}: sum {Commodity in Comm}(QtyShip[Commodity,Link]* Volume[Commodity]) <= MaxVolume[Link];

#Availability Constraint
subject to Availability{Commodity in Comm}:sum {Link in Cargo} QtyShip[Commodity,Link]<= Avail[Commodity];

#Balance Constraint
subject to Balance1: pct1 * sum {Commodity in Comm} QtyShip[Commodity,3] <= sum {Commodity in Comm} QtyShip[Commodity,1];
subject to Banace1Bis: sum {Commodity in Comm} QtyShip[Commodity,1] <=pct2 * sum {Commodity in Comm} QtyShip[Commodity,3]; 

subject to Balance2: pct4 * sum {Commodity in Comm,Link in Cargo} QtyShip[Commodity,Link] <= sum {Commodity in Comm} QtyShip[Commodity,2];
subject to Banace2Bis: sum {Commodity in Comm} QtyShip[Commodity,2] <=pct3 * sum {Commodity in Comm,Link in Cargo} QtyShip[Commodity,Link]; 

#Additional Constraint,draft the marks for implement it
#subject to Additional:sum{Link in Cargo} Activation[2,Link] >= sum{Link in Cargo}Activation[1,Link];

