package csvthemall;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class Connect
{   
    private static final String URL = "localhost";
    private static final String DB = "EscolaConducao";
    private static String USERNAME;
    private static String PASSWORD;
    
    
    public Connect (String username, String password)
    {
        this.USERNAME = username;
        this.PASSWORD = password;
    }
    
    /**
     * Establish connection with DB.
     * @return
     * @throws SQLException
     * @throws ClassNotFoundException 
     */
    public static Connection connect() throws SQLException, ClassNotFoundException 
    {
        Class.forName("com.mysql.jdbc.Driver");
        //cliente deve fechar conexão!
        return DriverManager.getConnection("jdbc:mysql://"+URL+"/"+DB+"?user="+USERNAME+"&password="+PASSWORD);    
    }
    
    /**
     * If is open, close the connection to the DB.
     * @param c 
     */
    public static void close(Connection c) 
    {
        try {
            
            if(c!=null && !c.isClosed())
                c.close();
            
        } catch (SQLException e) 
        {
            e.printStackTrace();
        }
    }
}
