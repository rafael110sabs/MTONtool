package csvthemall;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CSVThemAll 
{
    
    public static List<String> getTablesList(Connection conn) throws SQLException
    {
        List<String> tables = new ArrayList<>();
        
        PreparedStatement stm = conn.prepareStatement("SHOW TABLES;");
        ResultSet rs = stm.executeQuery();
        
        while(rs.next())
            tables.add(rs.getString(1));
        
        return tables;
    }
    
    public static void createCSV(String tableName, Connection conn) throws SQLException
    {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT");
                
        String columnQuery = "SHOW COLUMNS FROM "+tableName+";";
                
        PreparedStatement sta = conn.prepareStatement(columnQuery);
        ResultSet rs = sta.executeQuery();
        
        if(rs.next())
            sb.append(" '").append(rs.getString(1)).append("'");
                
        while (rs.next())
            sb.append(", '").append(rs.getString(1)).append("'");

        String columnsNames = sb.toString();

        PreparedStatement stm = conn.prepareStatement(columnsNames
                + " UNION ALL"
                + " SELECT * FROM " + tableName
                + "     INTO OUTFILE '/var/lib/mysql-files/" + tableName + ".csv'"
                + "     FIELDS ENCLOSED BY '\"' "
                + "     TERMINATED BY ','"
                + "     ESCAPED BY ''"
                + "     LINES TERMINATED BY '\\r\\n';");
        
        stm.executeQuery();
    }
    


    public static void main(String[] args) 
    {
        try {
            if (args.length >= 2)
            {
                Connect c = new Connect(args[0],args[1]);
                Connection connection = c.connect();
                
                List<String> tableNames = getTablesList(connection);
                
                for(String tableName: tableNames)
                {
                    System.out.println("# Creating " + tableName + ".csv");
                    createCSV(tableName, connection);
                }       
                System.out.println();
                c.close(connection);
            }           
        } 
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        catch(ClassNotFoundException e)
        {
            e.printStackTrace();
        }
    }
}
