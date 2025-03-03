using System;
using System.Net.Sockets;
using System.Text;
using System.Net;

class AsyncAwaitDownloader
{
    public async Task StartDownload(string host, string resource)
    {
        var ipHost = Dns.GetHostEntry(host);
        var ipAddress = ipHost.AddressList[0];
        var remoteEP = new IPEndPoint(ipAddress, 80);

        using var socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        await socket.ConnectAsync(remoteEP);

        var request = $"GET {resource} HTTP/1.1\r\n" +
                      $"Host: {host}\r\n" +
                      $"User-Agent: CSharp-Downloader\r\n" +
                      $"Connection: close\r\n\r\n";
        var requestBytes = Encoding.ASCII.GetBytes(request);
        await socket.SendAsync(requestBytes, SocketFlags.None);

        var responseBuilder = new StringBuilder();
        var buffer = new byte[4096];

        int bytesRead;
        do
        {
            bytesRead = await socket.ReceiveAsync(buffer, SocketFlags.None);
            responseBuilder.Append(Encoding.ASCII.GetString(buffer, 0, bytesRead));
        } while (bytesRead > 0);

        Console.WriteLine("Download Complete:");
        Console.WriteLine(responseBuilder.ToString());
    }
}
