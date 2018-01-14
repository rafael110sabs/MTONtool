/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package csvthemall;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author rafael
 */
public class Connect {   
    
    private static final String URL = "localhost";
    private static final String DB = "EscolaConducao";
    private static final String USERNAME = "appuser";
    private static final String PASSWORD = "appconnection";
    
    /**
     * Estabelece ligação à base de dados
     * @return
     * @throws SQLException
     * @throws ClassNotFoundException 
     */
    public static Connection connect() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        //cliente deve fechar conexão!
        return DriverManager.getConnection("jdbc:mysql://"+URL+"/"+DB+"?user="+USERNAME+"&password="+PASSWORD);    
    }
    
    /**
     * Fecha a ligação à base de dados, se aberta.
     * @param c 
     */
    public static void close(Connection c) {
        try {
            if(c!=null && !c.isClosed()) {
                c.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
