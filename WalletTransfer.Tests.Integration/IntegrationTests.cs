using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.VisualStudio.TestPlatform.TestHost;
using Xunit;

namespace WalletTransfer.Tests.Integration
{
    public class IntegrationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;

        public IntegrationTests(WebApplicationFactory<Program> factory)
        {
            // Crea el cliente HTTP usando la fábrica de la aplicación
            _client = factory.CreateClient();
        }

        [Fact]
        public async Task Login_ReturnsValidToken()
        {
            // Arrange: Crea el payload para el login
            var loginPayload = new
            {
                username = "userPayPhone",
                password = "PayPhonePro"
            };

            var content = new StringContent(JsonSerializer.Serialize(loginPayload), Encoding.UTF8, "application/json");

            var response = await _client.PostAsync("/api/auth/login", content);

            response.EnsureSuccessStatusCode();
            var responseContent = await response.Content.ReadAsStringAsync();
            Assert.Contains("token", responseContent);
        }

        [Fact]
        public async Task Transfer_ReturnsSuccess_WhenValid()
        {
            // Configura el token en las cabeceras para la siguiente solicitud
            var loginPayload = new
            {
                username = "userPayPhone",
                password = "PayPhonePro"
            };
            var loginContent = new StringContent(JsonSerializer.Serialize(loginPayload), Encoding.UTF8, "application/json");
            var loginResponse = await _client.PostAsync("/api/auth/login", loginContent);
            loginResponse.EnsureSuccessStatusCode();

            var loginResponseContent = await loginResponse.Content.ReadAsStringAsync();
            using var document = JsonDocument.Parse(loginResponseContent);
            var token = document.RootElement.GetProperty("token").GetString();

            
            _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var transferPayload = new
            {
                SourceWalletId = 1,
                DestinationWalletId = 2,
                Amount = 50
            };
            var transferContent = new StringContent(JsonSerializer.Serialize(transferPayload), Encoding.UTF8, "application/json");

            var transferResponse = await _client.PostAsync("/api/transactions/transfer", transferContent);

            transferResponse.EnsureSuccessStatusCode();
            var transferResponseContent = await transferResponse.Content.ReadAsStringAsync();
            Assert.Contains("Transferencia realizada exitosamente", transferResponseContent);
        }
    }
}
