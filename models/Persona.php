<?php

require_once 'ExecQuery.php';

class Persona extends ExecQuery
{

  public function getPersona(): array
  {
    try {
      $sp = parent::execQ("SELECT * FROM v_personas");
      $sp->execute();
      return $sp->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function add($params = []): array
  {
    try {

      $cmd = parent::execQ("CALL sp_register_person(?,?,?,?,?,?)");
      $cmd->execute(
        array(
          $params['idtipodoc'],
          $params['num_doc'],
          $params['apellidos'],
          $params['nombres'],
          $params['genero'],
          $params['telefono'],
        )
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getByNumDoc($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_persona_by_numdoc(?)");
      $cmd->execute(
        array($params['num_doc'])
      );

      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function searchTelf($params = []): array
  {
    try {
      $cmd = parent::execQ("CALL sp_search_telefono(?)");
      $cmd->execute(
        array($params['telefono'])
      );
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function updatePersona($params = []): bool
  {
    try {
      $status = false;
      $cmd = parent::execQ("CALL sp_update_persona(?,?,?,?,?,?,?)");
      $status = $cmd->execute(
        array(
          $params['idpersona'],
          $params['idtipodoc'],
          $params['num_doc'],
          $params['apellidos'],
          $params['nombres'],
          $params['genero'],
          $params['telefono']
        )
      );
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}

// $person = new Persona();

// echo json_encode(
//   $person->updatePersona([

//     'idpersona' => 8,
//     'idtipodoc' => 1,
//     'num_doc' => '78323044',
//     'apellidos' => 'Cervantes Espinoza',
//     'nombres' => 'Juan',
//     'genero' => 'M',
//     'telefono' => '923932423',
//     'nacionalidad' => 'Peruana'

//   ])
// );

// $data=[
//   'idtipodoc'=>1,
//   'num_doc'=>'345993456',
//   'apellidos'=>'Arenales Pereira',
//   'nombres'=>'Arturo',
//   'genero'=>'M',
//   'telefono'=>'934859346',
//   'nacionalidad'=>'Peruana'
// ];
// echo json_encode($person->add($data));

//echo json_encode($person->getByNumDoc(['num_doc'=>'74840779']));

//echo json_encode($person->searchTelf(['telefono'=>'928483244']));