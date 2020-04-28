#!/bin/bash

#declaring first two aliases

alias userGenerate="useradd -m -d"
alias permit="setfacl -m"
userGenerate /home/def/ChiefCommander ChiefCommander
permit o::--- /home/def/ChiefCommander

#declaring usefull arrays

declare -a nam_ar=( "ArmyGeneral" "NavyMarshal" "AirForceChief" )
declare -a man_ar=( "Army" "Navy" "Airforce" )

#Using userGenerate and permit

for ((i=0;i<3;i++))
do
 userGenerate /home/def/${nam_ar[$i]} ${nam_ar[$i]}
 permit u:ChiefCommander:rwx,o::--- /home/def/${nam_ar[$i]} 
done
for ((i=0;i<3;i++))
do
 if [[$i -eq 0]]
 then
  for ((j=1;j<=50;j++)
  do
   userGenerate /home/def/Army$j Army$j
   permit u:ChiefCommander,ArmyGeneral:rwx,o::--- /home/def/Army$j 
  done
 elif [[$i -eq 1]]
 then
  for ((j=1;j<=50;j++)
  do
   userGenerate /home/def/Navy$j Navy$j
   permit u:ChiefCommander,NavyMarshal:rwx,o::--- /home/def/Navy$j 
  done 
 elif [[$i -eq 2]]
 then
  for ((j=1;j<=50;j++)
  do
   userGenerate /home/def/Airforce$j Airforce$j
   permit u:ChiefCommander,AirForceChief:rwx,o::--- /home/def/Airforce$j 
  done 
 fi 
done

#Defining autoSchedule

function autoSchedule { 
  x=11 
  y=04
  for ((i=-1;i<0;i--)
  do 
   h= $(date +"%H")
   m= $(date +"%M")
   declare p
   let h=h*3600
   let m=m*60
   let h=h+m
   let p=86340-h # 23 hours 59 minutes 
   sleep $p
   for ((i=0;i<3;i++))
   do
    if [[$i -eq 0]]
    then
     for ((j=1;j<=50;j++)
     do
      cd /home/def/Army$j 
      touch post_alloted.txt
      grep -w Army$j /home/def/position.log | grep $y-$x >>post_alloted.txt
     done
    elif [[$i -eq 1]]
    then
     for ((j=1;j<=50;j++)
     do
      cd /home/def/Navy$j 
      touch post_alloted.txt
      grep -w Navy$j /home/def/position.log | grep $y-$x >>post_alloted.txt
     done 
    elif [[$i -eq 2]]
    then
     for ((j=1;j<=50;j++)
     do
      cd /home/def/Airforce$j 
      touch post_alloted.txt
      grep -w Airforce$j /home/def/position.log | grep $y-$x >>post_alloted.txt
     done 
    fi 
   done
 
 #For updating date
 if [[ ($x -eq 30)&&(($y -eq 4) || ($y -eq 6) || ($y -eq 9) || ($y -eq 11)) ]]
 then
  let y=y+1
  let x=1
 elif [[ $x -eq 31 ]]
 then
  if [[ $y -eq 12]]
  then
   let y=1
  fi
  let y=y+1
  let x=1
 elif [[ ($x -eq 28)&&( $y -eq 2) ]]
 then
  let x=1
  let y=y+1  
 else
  let x=x+1
 fi

 #For appending zeroes
 if [[ $x -lt 10 ]]
 then 
  x="0"$x 
 fi
 if [[ $y -lt 10]]
 then
  y="0"$y
 fi
 sleep 600 #To ensure that it don't start immediately
  done 
}  

#defining attendance

function attendance { 
  
  l=11 
  m=04
  for ((i=-1;i<0;i--)
  do 
   h= $(date +"%H")
   m= $(date +"%M")
   declare p
   let h=h*3600
   let m=m*60
   let h=h+m
   let p=21540-h # 5 hours 59 minutes 
   if [[ $p -lt 0]]
   then
    let p=-p
   fi
   sleep $p
   for ((i=0;i<3;i++))
   do
    cd /home/def/${nam_ar[$i]} ${nam_ar[$i]}
    touch attendance_record.txt
    grep ${man_arr[$i]} /home/def/attendance.log | grep $m-$l | grep YES >>attendance_record.txt
   done
   
   #For updating date
 if [[ ($l -eq 30)&&(($m -eq 4) || ($m -eq 6) || ($m -eq 9) || ($m -eq 11)) ]]
 then
  let m=m+1
  let l=1
 elif [[ $l -eq 31 ]]
 then
  if [[ $m -eq 12]]
  then
   let m=1
  fi
  let m=m+1
  let l=1
 elif [[ ($l -eq 28)&&( $m -eq 2) ]]
 then
  let l=1
  let m=m+1  
 else
  let l=l+1
 fi

 #For appending zeroes
 if [[ $l -lt 10 ]]
 then
  l="0"$l 
 fi
 if [[ $y -lt 10]]
 then
  m="0"$m
 fi
 sleep 600  #To ensure that it don't start immediately
  done 
}  

#defining record

function record {
 d=$(date +"%d")
 mo=$(date +"%m")
 declare e f i
 e=$(date +"%u")
 f=0
 #To find by how many steps to move back in date
 if [[ $1 -eq $e ]] #Main Cond 1
 then
  f=7
 elif [[ $1 -gt $e ]] #Main cond 2
 then
  for ((i=$e;i>0;i--))
  do
   if [[ $i -eq $1 ]]
   then
    break
   else
    let f=f+1
   fi
   if [[ $i -eq 1 ]]
   then
    i=8
   fi 
  done
 elif [[ $1 -lt $e ]] #Main cond 3
 then
  flag=0
  for ((i=$e;i>0;i++))
  do
   if [[ $i -eq $1 ]]
   then
    if [[ $flag -gt 0 ]]
    then
     break
    fi
    flag=1
    let f=f+1
   else
    let f=f+1
   fi
   if [[ $i -eq 1]]
   then
    i=8
   fi
  done
 fi
 
 #Move to the required date
 let d=d-f
 if [[ $d -lt 0 ]]
 then
  let mo=mo-1
  if [[($mo -eq 4) || ($mo -eq 6) || ($mo -eq 9) || ($mo -eq 11)]]
  then
   let d=d+30
  else
   if [[ $mo -eq 2]]
   then
    let d=d+28 
   fi
   let d=d+31 
  fi
 fi
 #For appending zeroes
 if [[ $d -lt 10 ]]
 then
  d="0"$d 
 fi
 if [[ $mo -lt 10]]
 then
  mo="0"$mo
 fi
 #Fetch the correct troops for correct chief
 declare use
 use=$USER
 for ((i=0;i<3;i++))
 do
  if [[ $USER == "${nam_ar[$i]}" ]]
  then
   grep ${man_arr[$i]} /home/def/attendance.log | grep $mo-$d
  elif [[ $i -eq 2]]
  then
   echo "Sorry You do not have access to this process"
  fi
 done
  
}
 



#added & to make it run in the background
autoSchedule &
attendance &





