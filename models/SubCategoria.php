<?php

require_once 'ExecQuery.php';

class SubCategoria extends ExecQuery{
  public function getAll():array{
    try{
      $query = "SELECT * FROM v_subcategoria";
      $cmd = parent::execQ($query);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getMarcasBySubcategoria($params=[]):array{
    try{
      $cmd = parent::execQ("CALL sp_filter_marcas_by_subcategoria(?)");
      $cmd->execute(
        array(
          $params['idsubcategoria']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
      return [];
    }
  }
}

// $sub = new SubCategoria();

// echo json_encode($sub->getAll());