FROM mcr.microsoft.com/dotnet/sdk:8.0 AS Build
WORKDIR /src

COPY ["WebApi/WebApi.csproj", "WebApi/"]
RUN dotnet restore "WebApi/WebApi.csproj"

COPY . .
WORKDIR "/src/WebApi"
RUN dotnet publish "WebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false


FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=Build /app/publish .

ENV ASPNETCORE_URLS=https://+:5001
EXPOSE 5001

ENTRYPOINT [ "dotnet", "WebApi.dll" ]