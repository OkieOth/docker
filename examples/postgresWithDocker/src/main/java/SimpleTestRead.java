
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author eiko
 */
public class SimpleTestRead {

    private final static String conStr = "jdbc:postgresql://localhost:6001/pg_test";
    private final static String jdbcClass = "org.postgresql.Driver";
    private final static String dbUser = "batman";
    private final static String dbPwd = "betman999";
    
    public static String getDate() throws ClassNotFoundException,SQLException {
        String ret=null;
        Class.forName(jdbcClass);
        Properties props = new Properties();
        props.setProperty("user", dbUser);
        props.setProperty("password", dbPwd);
        //props.setProperty("ssl","true");
        Connection conn = DriverManager.getConnection(conStr, props);
        Statement s = conn.createStatement();
        ResultSet rs = s.executeQuery ("SELECT current_date");
        rs.next();
        ret = rs.getString(1);
        rs.close();
        s.close();
        conn.close();
        return ret;
    }
    

    public static void main(String[] args) throws ClassNotFoundException,SQLException {
        System.out.println("today is: "+getDate());
    }
}
