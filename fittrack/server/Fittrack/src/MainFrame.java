import javax.swing.*;
import java.awt.*;

public class MainFrame {
    private static JFrame frame;
    private static JTextArea logArea;

    public static void init() {
        frame = new JFrame("FitTrack Server");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(400, 300);

        logArea = new JTextArea();
        logArea.setEditable(false);
        frame.add(new JScrollPane(logArea), BorderLayout.CENTER);

        frame.setVisible(true);
    }

    public static void log(String message) {
        SwingUtilities.invokeLater(() -> {
            logArea.append(message + "\n");
            logArea.setCaretPosition(logArea.getDocument().getLength()); // Scroll to the bottom
        });
    }
}
