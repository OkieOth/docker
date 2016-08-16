
import java.sql.SQLException;
import static org.junit.Assert.assertNotNull;
import org.junit.Test;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author eiko
 */
public class IT_First {
    @Test
    public void test() throws ClassNotFoundException, SQLException {
        String s = SimpleTestRead.getDate();
        assertNotNull(s);
        System.err.println("I'm a integration test: "+s);
    }
}
