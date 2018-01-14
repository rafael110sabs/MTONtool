/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package csvthemall;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author rafael
 */
public class CSVThemAll {
    
    public static List<String> getTablesList(Connection conn){
        List<String> tables = new ArrayList<>();
        
        try{
            PreparedStatement stm = conn.prepareStatement("SHOW TABLES;");
            ResultSet rs = stm.executeQuery();
            while(rs.next()){
                tables.add(rs.getString(1));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public static void createCSV(List<String> tableNames, Connection conn){
        try{
            for (String tableName : tableNames) {
                System.out.println("# Creating " + tableName + ".csv");
                
                StringBuilder sb = new StringBuilder();
                sb.append("SELECT");
                
                String columnQuery = "SHOW COLUMNS FROM "+tableName+";";
                
                PreparedStatement sta = conn.prepareStatement(columnQuery);
                ResultSet rs = sta.executeQuery();
                if(rs.next())
                    sb.append(" '").append(rs.getString(1)).append("'");
                
                while (rs.next()) {
                    sb.append(", '").append(rs.getString(1)).append("'");
                }
                String columnsNames = sb.toString();

                PreparedStatement stm = conn.prepareStatement(columnsNames + "\n"
                        + "UNION ALL\n"
                        + "SELECT *\n"
                        + "	FROM " + tableName + "\n"
                        + "    INTO OUTFILE '/var/lib/mysql-files/" + tableName + ".csv'\n"
                        + "    FIELDS ENCLOSED BY '\"'\n"
                        + "    TERMINATED BY ','\n"
                        + "    ESCAPED BY ''\n"
                        + "    LINES TERMINATED BY '\\r\\n';");
                ResultSet rs2 = stm.executeQuery();
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        
        
    }
    

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
       
        try(Connection conn = Connect.connect()){
            List<String> tableNames = getTablesList(conn);
            System.out.print("Found tables:");
            for(String tableName: tableNames){
                System.out.print(tableName+", ");
            }
            System.out.println("");
            createCSV(tableNames, conn);
            
        } catch(Exception e){
            e.printStackTrace();
        }
    }
    
}
