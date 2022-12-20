
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR ./

COPY BlazorServer.sln .
COPY "BlazorServer/BlazorServer.csproj" "BlazorServer/BlazorServer.csproj"
RUN dotnet restore 

COPY . .
RUN dotnet publish --no-restore -c Release -o out ./BlazorServer

FROM mcr.microsoft.com/dotnet/aspnet:6.0
EXPOSE 5003
WORKDIR /
COPY --from=build-env /out .
ENTRYPOINT ["./BlazorServer"]

