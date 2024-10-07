<?php

#use function PHPSTORM_META\type;

// require_once 'Permiso.php';
// $permiso = new Permiso();

class Module{
  private $activos=[];


  // public function __CONSTRUCT(){
  //   $this->crud['create']=$this->register;
  //   $this->crud['read']=$this->list;
  //   $this->crud['update']=$this->update;
  //   $this->crud['delete']=$this->delete;
  //   //array_push($this->crud, $this->register, $this->list, $this->update, $this->delete);
  // }

  public function getModules($permisos=[]):array{
    //var_dump($permisos);
    $submodules=[];
    $whithoutModules=[];
    foreach($permisos as $i=>$modulo){
      foreach($modulo as $x=>$value){
        $this->activos[$i][$x]=$value;#Muestra todo el array

        #separan a los que tiene submodulos y no submodulos
        // if(is_array($value)){
        //   $submodules[$i][$x]=$value;
        // }else{
        //   $whithoutModules[$i][$x]=$value;
        // }
      }
    }
    #$this->activos = $this->showModules($submodules);
    //$this->activos=$submodules+$whithoutModules;

    return $this->activos;
  }

  private function showModules($modules=[]):array{
    $valores=[];
    foreach($modules as $i=>$modulo){
      foreach($modulo as $j=>$value){
        foreach($value as $c=>$x){
          #Muestra solo los que estan en true
          if($x){
            $valores[$j][$c]=$x;
            
          }
        }
      }
    }
    return $valores;
  }

  private function showNoSubM($valores=[]):array{
    $data=[];
    //var_dump($valores);
    foreach($valores as $i=>$modulo){
      foreach($modulo as $x=>$value){
        #Muestra solo los que estan en true
        if($value){
          //$data[$i][$x]=$this->crud[$x];

          //var_dump($x);

        }
      }
    }
    return $data;
  }
}


