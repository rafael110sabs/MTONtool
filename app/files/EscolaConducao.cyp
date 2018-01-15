// https://neo4j.com/developer/guide-importing-data-and-etl/
// Currently, Cypher supports the following basic types:
//    Boolean, Integer, Float, String, List and Map.



// ---------------------------------------------------------------------
//                              How to Run                             |
// ---------------------------------------------------------------------
// sudo rm -rf /var/lib/neo4j/data/databases/graph.db/*                |
// sudo service neo4j start                                            |
// cypher-shell -u neo4j -p intruso < EscolaConducao.cyp               |
// ---------------------------------------------------------------------


// Aluno
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Aluno.csv" AS row
FIELDTERMINATOR ','
      CREATE (:Aluno {
                  NrCartaoCidadao: toInteger(row.NrCartaoCidadao),
                  Nome: row.Nome,
                  DataNascimento: row.DataNascimento,
                  Morada: row.Morada,
                  eMail: row.eMail,
                  DataInscricao: row.DataInscricao});


CREATE INDEX ON :Aluno(NrCartaoCidadao);
// ---------------------------------------------------------------------







// Veiculo
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Veiculo.csv" AS row
FIELDTERMINATOR ','
CREATE (:Veiculo {
      idVeiculo: toInteger(row.idVeiculo),
      Categoria: row.Categoria});

CREATE INDEX ON :Veiculo(idVeiculo);
// ---------------------------------------------------------------------






// Instrutor
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Instrutor.csv" AS row
FIELDTERMINATOR ','
CREATE (:Instrutor {
      NrCartaoCidadao: toInteger(row.NrCartaoCidadao),
      Nome: row.Nome,
      DataNascimento: row.DataNascimento,
      Morada: row.Morada,
      eMail: row.eMail});

CREATE INDEX ON :Instrutor(NrCartaoCidadao);
// ---------------------------------------------------------------------




// Aula
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Aula.csv" AS row
FIELDTERMINATOR ','
MATCH (i:Instrutor {NrCartaoCidadao: toInteger(row.Instrutor)})
  CREATE (a:Aula {
        idAula: toInteger(row.idAula),
        Data: row.Data,
        HoraInicio: row.HoraInicio,
        HoraFim: row.HoraFim,
        Duracao: toInteger(row.Duracao),
        TipoAula: row.TipoAula})
  CREATE (i)-[:Leciona]->(a)
WITH a, row
MATCH (v:Veiculo {idVeiculo: toInteger(row.Veiculo)})
  CREATE (a)-[:Associada]->(v);


CREATE INDEX ON :Aula(idAula);
// ---------------------------------------------------------------------




// AlunoMarcaAula
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///AlunoMarcaAula.csv" AS row
FIELDTERMINATOR ','
MATCH (al:Aula),(a:Aluno)
      WHERE al.idAula = toInteger(row.Aula)
            AND a.NrCartaoCidadao = toInteger(row.Aluno)
      CREATE (a)-[m:Marca{DataMarcacao: row.DataMarcacao}]->(al);
// ---------------------------------------------------------------------




// AlunoFrequentaAula
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///AlunoFrequentaAula.csv" AS row
FIELDTERMINATOR ','
MATCH (a:Aluno),(al:Aula)
      WHERE a.NrCartaoCidadao = toInteger(row.Aluno)
            AND al.idAula = toInteger(row.Aula)
      CREATE (a)-[f:Frequenta]->(al);
// ---------------------------------------------------------------------




// CategoriaInscritaAluno
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///CategoriaInscritaAluno.csv" AS row
FIELDTERMINATOR ','
MATCH (a:Aluno{NrCartaoCidadao: toInteger(row.Aluno)})
  MERGE (ca:CategoriaInscritaAluno {Categoria: row.Categoria})
WITH ca, a
  CREATE (a)-[:Inscrito]->(ca);

CREATE INDEX ON :CategoriaInscritaAluno(Aluno);
// ---------------------------------------------------------------------

// TelemovelInstrutor
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///TelemovelInstrutor.csv" AS row
FIELDTERMINATOR ','
MATCH (i:Instrutor{NrCartaoCidadeo: toInteger(row.Instrutor)})
  CREATE (t:Telemovel {Numero: toInteger(row.Telemovel)})<-[:Tem]-(i);

CREATE INDEX ON :TelemovelInstrutor(Instrutor);
// ---------------------------------------------------------------------





// TelemovelAluno
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///TelemovelAluno.csv" AS row
FIELDTERMINATOR ','
MATCH (a:Aluno{NrCartaoCidadao : toInteger(row.Aluno)})
  CREATE (t:Telemovel {Numero: toInteger(row.Telemovel)})<-[:Tem]-(a);

CREATE INDEX ON :TelemovelAluno(Aluno);
// ---------------------------------------------------------------------
