<?php

require_once 'ExecQuery.php';

class SubCategoria extends ExecQuery
{
  public function getAll(): array
  {
    try {
      $query = "SELECT * FROM v_subcategoria";
      $cmd = parent::execQ($query);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getMarcasBySubcategoria($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_filter_marcas_by_subcategoria(?)");
      $cmd->execute(
        array(
          $params['idsubcategoria']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
      return [];
    }
  }

  public function getSubcategoriaById($params = []): array
  {
    try {
      $cmd = parent::execQ("SELECT subcategoria FROM subcategorias WHERE idsubcategoria=?");
      $cmd->execute(
        array(
          $params['idsubcategoria']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
      return [];
    }
  }

  public function getSubcategoriaByCategoria($params = []): array
  {
    try {
      $cmd = parent::execQ("SELECT * FROM subcategorias WHERE idcategoria = ?");
      $cmd->execute(
        array(
          $params['idcategoria']
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
      return [];
    }
  }
}

//  $sub = new SubCategoria();

//  echo json_encode($sub->getSubcategoriaById(['idsubcategoria'=>2]));

// echo json_encode($sub->getAll());