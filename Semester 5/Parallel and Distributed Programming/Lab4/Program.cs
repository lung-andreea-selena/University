class Program
{
    static async Task Main(string[] args)
    {
        Console.WriteLine("Choose a download implementation:");
        Console.WriteLine("1 - Event-Driven (Callback-Based)");
        Console.WriteLine("2 - Task-Based with Callbacks");
        Console.WriteLine("3 - Async/Await");
        Console.Write("Enter your choice: ");
        var choice = Console.ReadLine();

        // Define multiple download targets
        var downloads = new List<(string Host, string Resource)>
    {
        ("httpbin.org", "/anything"),
        ("postman-echo.com", "/get"),
    };

        switch (choice)
        {
            case "1": // Event-Driven
                Console.WriteLine("Running Event-Driven (Callback-Based) Implementation...");
                foreach (var (host, resource) in downloads)
                {
                    var eventDrivenDownloader = new EventDrivenDownloader();
                    eventDrivenDownloader.StartDownload(host, resource);
                }
                Console.ReadLine(); 
                break;

            case "2": // Task-Based
                Console.WriteLine("Running Task-Based Implementation...");
                var taskBasedDownloaders = downloads.Select(d => {
                    var taskBasedDownloader = new TaskBasedDownloader();
                    return taskBasedDownloader.StartDownload(d.Host, d.Resource);
                });
                await Task.WhenAll(taskBasedDownloaders); // Wait for all tasks to complete
                break;

            case "3": // Async/Await
                Console.WriteLine("Running Async/Await Implementation...");
                var asyncAwaitDownloaders = downloads.Select(d => {
                    var asyncAwaitDownloader = new AsyncAwaitDownloader();
                    return asyncAwaitDownloader.StartDownload(d.Host, d.Resource);
                });
                await Task.WhenAll(asyncAwaitDownloaders); // Wait for all tasks to complete
                break;

            default:
                Console.WriteLine("Invalid choice. Exiting...");
                break;
        }
    }
}