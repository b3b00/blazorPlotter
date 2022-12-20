FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY BlazorServer.sln .
COPY ["BlazorServer/BlazorServer.csproj", "BlazorServer/"]
RUN dotnet restore "BlazorServer/BlazorServer.csproj"
COPY . .
RUN dotnet publish "BlazorServer.csproj" --no-restore -c Release -o out ./BlazorServer

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorServer.dll"]

# -------------

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR ./

# Copy csproj and restore as distinct layers
COPY BlazorServer.sln .
COPY BlazorServer/BlazorServer.csproj ./BlazorServer/BlazorServer.csproj
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish --no-restore -c Release -o out ./BlazorServer

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /
COPY --from=build-env /out .
ENTRYPOINT ["./BlazorServer"]