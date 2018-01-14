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






// Aula
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Aula.csv" AS row
FIELDTERMINATOR ','
CREATE (:Aula {
      idAula: toInteger(row.idAula),
      Data: row.Data,
      HoraInicio: row.HoraInicio,
      HoraFim: row.HoraFim,
      Duracao: toInteger(row.Duracao),
      TipoAula: row.TipoAula,
      Instrutor: toInteger(row.Instrutor),
      Veiculo: toInteger(row.Veiculo)});


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





// CategoriaInscritaAluno
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///CategoriaInscritaAluno.csv" AS row
FIELDTERMINATOR ','
CREATE (:CategoriaInscritaAluno {
      Categoria: row.Categoria,
      Aluno: toInteger(row.Aluno)});

CREATE INDEX ON :CategoriaInscritaAluno(Aluno);
// ---------------------------------------------------------------------




// Inscrito
// ---------------------------------------------------------------------
MATCH (a:Aluno),(ci:CategoriaInscritaAluno)
      WHERE a.NrCartaoCidadao = ci.Aluno
      CREATE (a)-[:Inscrito]->(ci);
// ---------------------------------------------------------------------





// TelemovelInstrutor
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///TelemovelInstrutor.csv" AS row
FIELDTERMINATOR ','
CREATE (:TelemovelInstrutor {
      Telemovel: toInteger(row.Telemovel),
      Instrutor: toInteger(row.Instrutor)});

CREATE INDEX ON :TelemovelInstrutor(Instrutor);
// ---------------------------------------------------------------------





// TelemovelAluno
// ---------------------------------------------------------------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///TelemovelAluno.csv" AS row
FIELDTERMINATOR ','
CREATE (:TelemovelAluno {
      Telemovel: toInteger(row.Telemovel),
      Aluno: toInteger(row.Aluno)});

CREATE INDEX ON :TelemovelAluno(Aluno);
// ---------------------------------------------------------------------



// Tem
// ---------------------------------------------------------------------
MATCH (a:Aluno),(ta:TelemovelAluno)
      WHERE a.NrCartaoCidadao = ta.Aluno
      CREATE (a)-[:Tem]->(ta);
// ---------------------------------------------------------------------



// Tem
// ---------------------------------------------------------------------
MATCH (i:Instrutor),(ti:TelemovelInstrutor)
      WHERE i.NrCartaoCidadao = ti.Instrutor
      CREATE (i)-[:Tem]->(ti);
// ---------------------------------------------------------------------