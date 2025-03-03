using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

class TaskBasedDownloader
{
    public async Task StartDownload(string host, string resource)
    {
        // resolves the hotname to an ip adress, create a socket to communicate with the server and defines remote endpoit
        var ipHost = Dns.GetHostEntry(host);
        var ipAddress = ipHost.AddressList[0];
        var remoteEP = new IPEndPoint(ipAddress, 80);
        var socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

        await ConnectAsync(socket, remoteEP); //synchronously establish a connection to the server (avoid blocking the thread while waiting for the connection to complete

        //construct the request and encodes it into byte array
        var request = $"GET {resource} HTTP/1.1\r\n" +
                      $"Host: {host}\r\n" +
                      $"User-Agent: CSharp-Downloader\r\n" +
                      $"Connection: close\r\n\r\n";
        var requestBytes = Encoding.ASCII.GetBytes(request);
        await SendAsync(socket, requestBytes);// send the request asynchronously

        var response = await ReceiveAllAsync(socket);//reads the entire response asynchronously
        Console.WriteLine("Download Complete:");
        Console.WriteLine(response);
        socket.Close();
    }

    private Task ConnectAsync(Socket socket, EndPoint remoteEP)
    {
        var tcs = new TaskCompletionSource();
        Console.WriteLine("Connecting...");
        socket.BeginConnect(remoteEP, ar => //starts an asynchronous connection
        {
            try
            {
                socket.EndConnect(ar); //finalize connection
                Console.WriteLine("Connected");
                tcs.SetResult(); //mark the task successful
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        }, null);
        return tcs.Task;// returns the Task to the caller, allowing them to await the connection completion.
    }

    private Task SendAsync(Socket socket, byte[] data)
    {
        var tcs = new TaskCompletionSource();
        socket.BeginSend(data, 0, data.Length, SocketFlags.None, ar => //sends the request data asynchronously
        {
            try
            {
                socket.EndSend(ar); //finalize send operation
                Console.WriteLine("Request sent.");
                tcs.SetResult();
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        }, null);
        return tcs.Task;
    }

    private async Task<string> ReceiveAllAsync(Socket socket) //method loops to receive full response
    {
        var buffer = new byte[4096]; //allocates buffer for reading chunks of data
        var responseBuilder = new StringBuilder();
        int bytesRead;

        do
        {
            bytesRead = await ReceiveAsync(socket, buffer); //read data chunks async.
            responseBuilder.Append(Encoding.ASCII.GetString(buffer, 0, bytesRead)); //converts and appends
            Console.WriteLine("Received data chunk");
        } while (bytesRead > 0); // stops when bytesRead == 0 indicating the server has finished sending data

        return responseBuilder.ToString(); //return full response
    }

    private Task<int> ReceiveAsync(Socket socket, byte[] buffer)
    {
        var tcs = new TaskCompletionSource<int>();
        socket.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, ar => //reads data asynchronously
        {
            try
            {
                tcs.SetResult(socket.EndReceive(ar));
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        }, null);
        return tcs.Task; //returns the number of bytes read that is why we have int
    }

}
