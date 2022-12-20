
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