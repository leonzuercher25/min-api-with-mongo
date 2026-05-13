FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /src

COPY ["WebApi.csproj", "./"]
RUN dotnet restore

COPY . .
RUN dotnet publish "WebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false


FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE:URLS=https://+:5001
EXPOSE 5001

ENTRYPOINT [ "dotnet", "WebApi.dll" ]