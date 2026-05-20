using Microsoft.Extensions.Options;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);
var movieDatabaseConfigSection = builder.Configuration.GetSection("DatabaseSettings");
builder.Services.Configure<DatabaseSettings>(movieDatabaseConfigSection);

var app = builder.Build();

app.MapGet("/", () => "Minimal API Version 1.0.0");

app.MapGet("/check", (Microsoft.Extensions.Options.IOptions<DatabaseSettings> options) =>
{
    var mongoDBConnectionString = options.Value.ConnectionString;
    try
    {
        var client = new MongoClient(mongoDBConnectionString);
        var dblist = client.ListDatabaseNames().ToList();
        string dbs = string.Join(", ", dblist);
        
    return $"Zugriff auf MongoDB ok. Vorhandene DBs: {dbs}";
    }
    catch (Exception ex)
    {
        return $"Fehler beim Zugriff auf MongoDB: {ex.Message}";
    }
});

app.Run();
