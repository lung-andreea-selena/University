using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

class EventDrivenDownloader
{
    private Socket _socket;
    private StringBuilder _responseBuilder = new StringBuilder(); //full response
    private int _contentLength = -1;
    private int _headerLength = -1;
    private byte[] _buffer = new byte[4096]; // byte array to store the incoming data

    public void StartDownload(string host, string resource) // initiate the process
    {
        try
        {
            //first we need a socket to send and receive data over the network
            _socket = new Socket(
                AddressFamily.InterNetwork, //socket will use IPv4
                SocketType.Stream, //steam-based socket
                ProtocolType.Tcp); //set protocol to TCP (for reliable, ordered and error-checked delivery)

            //the hostname must be converted to an IP adress for the socket to connect
            var ipHost = Dns.GetHostEntry(host); //getting the host name
            var ipAddress = ipHost.AddressList[0]; // retreives the first ip address from the resolved list

            //we create an remote endpoint for the socket to connect to 
            var remoteEP = new IPEndPoint(ipAddress, 80); // the server's IP adress and the port for http communication

            Console.WriteLine("Connecting...");

            //start asynchronous connection
            _socket.BeginConnect(remoteEP, ConnectCallback, (host, resource));
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }

    private void ConnectCallback(IAsyncResult ar) // completes the connection initiated by StartDownload
    {
        try
        {
            //EndConnect ensures the connection was successful and cleans up any resources used during the asynchronous operation.
            _socket.EndConnect(ar); //completes the asynchronous connection initiated by _socket.BeginConnect. (ar = AsyncResult => result of the connection attempt)
            Console.WriteLine("Connected.");


            var (host, resource) = ((string, string))ar.AsyncState; //Retrieves the host and resource values that were passed as state data when BeginConnect was called in StartDownload

            //ensure server understands the request
            var request = $"GET {resource} HTTP/1.1\r\n" + //http method and resource
                          $"Host: {host}\r\n" + //target server
                          $"User-Agent: CSharp-Downloader\r\n" + //identifies client
                          $"Connection: close\r\n\r\n"; //requests the server to close the connection after responding

            var requestBytes = Encoding.ASCII.GetBytes(request);//Converts the HTTP request string into a byte array 

            Console.WriteLine("Request Sent:");
            Console.WriteLine(request);

            //BeginSend ensures the program continues running without waiting for a request to finish sending
            _socket.BeginSend(requestBytes, 0, requestBytes.Length, SocketFlags.None, SendCallback, null); // 0 is the offset (start from the eginning of array
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Connection error: {ex.Message}");
            _socket.Close();
        }
    }

    private void SendCallback(IAsyncResult ar)//method that is called if the sending operation completes
    {
        try
        {
            //ensure all request data has been sent over the socket
            _socket.EndSend(ar);// finalizes the send operation initiated by _socket.BeginSend
            Console.WriteLine("Request sent. Waiting for response...");

            //start an asynchronous operation to receive data from the server.This prepares the program to handle chunks of data from the server.
            _socket.BeginReceive(_buffer, 0, _buffer.Length, SocketFlags.None, ReceiveCallback, null);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Send error: {ex.Message}");
            _socket.Close();
        }
    }

    private void ReceiveCallback(IAsyncResult ar)// handles incoming data and the method to handle the data received
    {
        try
        {
            //completes the receive operation initiated by _socket.BeginReceive.
            var bytesRead = _socket.EndReceive(ar); //returns the number of bytes read from the server

            if (bytesRead > 0)
            {
                var data = Encoding.ASCII.GetString(_buffer, 0, bytesRead); //converts the received bytes into a string
                _responseBuilder.Append(data); //appends data to acumulate the full response

                Console.WriteLine("Received data chunk:");
                Console.WriteLine(data);

                //check if header was parsed yet, if not parse it
                if (_headerLength == -1)
                {
                    ParseHeaders();
                }

                //checks if the full response was received (header + body) 
                if (_headerLength != -1 && _responseBuilder.Length >= _headerLength + _contentLength)
                {
                    //extracts and prints the reponse body
                    Console.WriteLine("Download Complete:");
                    var fullResponse = _responseBuilder.ToString();
                    var body = fullResponse.Substring(_headerLength);
                    Console.WriteLine(body);
                    _socket.Close();
                }
                else
                {
                    _socket.BeginReceive(_buffer, 0, _buffer.Length, SocketFlags.None, ReceiveCallback, null);
                }
            }
            else
            {
                Console.WriteLine("Connection closed before receiving the full content.");
                _socket.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Receive error: {ex.Message}");
            _socket.Close();
        }
    }

    private void ParseHeaders()
    {
        var content = _responseBuilder.ToString();
        var headerEndIndex = content.IndexOf("\r\n\r\n");

        if (headerEndIndex != -1)
        {
            _headerLength = headerEndIndex + 4; // Include "\r\n\r\n"
            var headers = content.Substring(0, headerEndIndex).Split(new[] { "\r\n" }, StringSplitOptions.None);

            Console.WriteLine("Headers:");
            foreach (var header in headers)
            {
                Console.WriteLine(header);
                if (header.StartsWith("Content-Length:", StringComparison.OrdinalIgnoreCase))
                {
                    _contentLength = int.Parse(header.Split(':')[1].Trim());
                    break;
                }
            }

            if (_contentLength == -1)
            {
                Console.WriteLine("Content-Length not found in headers.");
                _socket.Close();
            }
        }
    }
}