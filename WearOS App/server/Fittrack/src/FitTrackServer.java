import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class FitTrackServer {
    public static int PORT_NUMBER = 1010;
    private static Robot robot; // Robot for simulating key presses

    public static void main(String[] args) {
        // Initialize the GUI
        MainFrame.init();

        try {
            // Initialize the Robot instance
            robot = new Robot();

            // Get the IP address of the current machine
            InetAddress localIP = InetAddress.getLocalHost();
            String ipAddress = localIP.getHostAddress();
            MainFrame.log("Server IP address: " + ipAddress);

            ServerSocket hostingSocket = new ServerSocket(PORT_NUMBER);
            MainFrame.log("Server started, listening on port " + PORT_NUMBER);

            while (true) {
                MainFrame.log("Waiting for a client connection...");
                Socket clientSocket = hostingSocket.accept(); // Wait for client
                MainFrame.log("Client connected: " + clientSocket.getInetAddress().getHostAddress());

                // Handle the client connection
                handleClient(clientSocket);
            }
        } catch (UnknownHostException ex) {
            MainFrame.log("Error retrieving local IP address: " + ex.getMessage());
        } catch (IOException ex) {
            MainFrame.log("Error starting server: " + ex.getMessage());
        } catch (AWTException ex) {
            MainFrame.log("Error initializing Robot: " + ex.getMessage());
        }
    }

    private static void handleClient(Socket clientSocket) {
        try (BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()))) {
            String inputLine;
            StringBuilder jsonData = new StringBuilder();
            MainFrame.log("Reading data from client...");

            // Read the incoming data until the end of stream
            while ((inputLine = in.readLine()) != null) {
                // Check for "Next" or "Back" command
                if (inputLine.equalsIgnoreCase("Next")) {
                    MainFrame.log("Next slide command received");
                    simulateKeyPress(KeyEvent.VK_RIGHT); // Simulate right arrow key press
                } else if (inputLine.equalsIgnoreCase("Back")) {
                    MainFrame.log("Back slide command received");
                    simulateKeyPress(KeyEvent.VK_LEFT); // Simulate left arrow key press
                } else {
                    jsonData.append(inputLine); // Accumulate other data (assumed to be JSON)
                    MainFrame.log("Received partial data: " + inputLine); // Log partial data
                }
            }

            // If we have accumulated JSON data, process it
            if (jsonData.length() > 0) {
                String jsonString = jsonData.toString();
                MainFrame.log("Full received data: " + jsonString);

                // Parse and log the heart rate data
                parseAndLogHeartRateData(jsonString);
            }

        } catch (IOException ex) {
            MainFrame.log("Error reading from client: " + ex.getMessage());
        } finally {
            try {
                clientSocket.close();
                MainFrame.log("Client connection closed.");
            } catch (IOException ex) {
                MainFrame.log("Error closing client socket: " + ex.getMessage());
            }
        }
    }

    // Method to simulate a key press using the Robot class
    private static void simulateKeyPress(int keyCode) {
        try {
            robot.keyPress(keyCode);
            robot.keyRelease(keyCode); // Release the key after pressing it
            MainFrame.log("Simulated key press: " + KeyEvent.getKeyText(keyCode));
        } catch (IllegalArgumentException e) {
            MainFrame.log("Error simulating key press: " + e.getMessage());
        }
    }

    // Method to parse and log heart rate data
    private static void parseAndLogHeartRateData(String jsonString) {
        try {
            // Parse the JSON array
            JSONArray jsonArray = new JSONArray(jsonString);

            // Loop through the array and extract heart rate and date
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String heartRate = jsonObject.getString("heartRate");
                String date = jsonObject.getString("date");

                // Log the heart rate and date
                MainFrame.log("Heart Rate: " + heartRate + " BPM, Time: " + date);
            }

        } catch (Exception e) {
            MainFrame.log("Error parsing JSON data: " + e.getMessage());
        }
    }
}
