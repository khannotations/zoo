import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketAddress;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class ServiceThread extends Thread {
	private ServerSocket welcomeSocket;
	private BufferedReader inFromClient;
	private DataOutputStream outToClient;
	
	/* Static variables */
	
	public ServiceThread(ServerSocket welcomeSocket, Map<String, String> updateTable) {
		this.welcomeSocket = welcomeSocket;
	}
	public void run() {
		System.out.println(this + " started.");
		while (true) {
			// Get a new request connection
			Socket s = null;
			synchronized (welcomeSocket) {
				try {
					s = welcomeSocket.accept();
					/System.out.println("Thread "+this+" process request "+s);
				} catch (IOException e) {
				}
			}
			processRequest(s);
			
		}
	}
	private void processRequest(Socket connSock) {
		boolean html = false;
		try {
			// Create read stream to get input
			inFromClient = new BufferedReader(new InputStreamReader(connSock.getInputStream()));
			outToClient = new DataOutputStream(connSock.getOutputStream());
			// Map to store parameters
			Map<String, String> map = new HashMap<String, String>();
			
		    String query = inFromClient.readLine();
		    if(query == null) {
		    	outputError(404, "Path was null!");
		    	connSock.close();
		    }
		    System.out.println("Query: "+query);
		    String[] request = query.split("\\s");
		    if (request.length < 2 || !request[0].equals("GET")) {
			    outputError(500, "Bad request");
			    connSock.close();
			    return;
		    }
		    String[] path = request[1].split("\\?");
		    String action = path[0];
		    if (path.length > 1) {
			    String[] params = path[1].split("&");
			    for (String param : params) {
			    	String name = param.split("=")[0];
			    	String value = param.split("=")[1];
			    	map.put(name, value);
			    } 
		    }
		    // To get a URL variable: 
		    // String variable = map.get("varName");
		    String outputString = "Nothing happened!";
		    if(action.equals("/zoo")) {
		    	System.out.println("Serving hzw");
		    	try {
		    		outputString = readFile("./hzw_output.txt");
		    	} catch (IOException e) {
		    		e.printStackTrace();
		    	}
		    } else {
		    	System.out.println("Path: "+ action);
		    	outputError(404, "No such path.");
		    	connSock.close();
		    	return;
		    } 
		    outputResponseHeader();
		    // outputHTMLHeader();
		    outputResponseBody(outputString);
		    System.out.println("Serving "+action+"...");
		    connSock.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static String readFile(String path) throws IOException {
		  FileInputStream stream = new FileInputStream(new File(path));
		  try {
		    FileChannel fc = stream.getChannel();
		    MappedByteBuffer bb = fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());
		    /* Instead of using default, pass in a decoder. */
		    return Charset.defaultCharset().decode(bb).toString();
		  }
		  finally {
		    stream.close();
		  }
	}
	
	private static byte[] readByteFile(String path) throws IOException {
		FileInputStream stream = new FileInputStream(new File(path));
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] buff = new byte[1024];
		int read = 0;
		while((read = stream.read(buff)) > 0) {
			baos.write(buff, 0, read);
		}
		baos.flush();
		stream.close();
		return baos.toByteArray();
	}

	private void outputResponseHeader() throws Exception {
		String string = "HTTP/1.0 200 Document Follows\r\n";
		string += "Access-Control-Allow-Origin: *\r\n";
		outToClient.writeBytes(string);
	}
	private void outputHTMLHeader() throws Exception {
		outToClient.writeBytes("Content-Type: text/html; charset=utf-8\r\n");
	}
	private void outputAudio(String file) throws Exception {
		outputResponseHeader();
		outToClient.writeBytes("Content-Type: audio/mpeg\r\n");
		byte[] toWrite = readByteFile(file);
		outToClient.writeBytes("Content-Length: " + toWrite.length + "\r\n");
		outToClient.write(toWrite);
	}
	private void outputResponseBody(String out) throws Exception {
		outToClient.writeBytes("Content-Length: " + out.length() + "\r\n");
		outToClient.writeBytes("\r\n");
		outToClient.writeBytes(out);
	}
	void outputError(int errCode, String errMsg) {
		try {
			outToClient.writeBytes("HTTP/1.0 " + errCode + " " + errMsg
					+ "\r\n");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

