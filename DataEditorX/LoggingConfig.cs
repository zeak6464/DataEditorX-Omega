using Serilog;

namespace DataEditorX
{
    public static class LoggingConfig
    {
        public static void ConfigureLogging()
        {
            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Debug()
                .WriteTo.Console()
                .WriteTo.File("logs/DataEditorX.log", rollingInterval: RollingInterval.Day)
                .CreateLogger();

            Log.Information("Logging configured successfully.");
        }
    }
}
