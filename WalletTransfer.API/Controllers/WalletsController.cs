using Microsoft.AspNetCore.Mvc;
using WalletTransfer.Domain.Entities;
using WalletTransfer.Domain.Interfaces;
using WalletTransfer.Application.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace WalletTransfer.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WalletsController : ControllerBase
    {
        private readonly IWalletRepository _walletRepository;

        public WalletsController(IWalletRepository walletRepository)
        {
            _walletRepository = walletRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var wallets = await _walletRepository.GetAllAsync();
            return Ok(wallets);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var wallet = await _walletRepository.GetByIdAsync(id);
            if (wallet == null)
                return NotFound();
            return Ok(wallet);
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] WalletDto walletDto)
        {
            if (string.IsNullOrWhiteSpace(walletDto.Name))
                return BadRequest("El nombre es requerido.");

            // Mapea WalletDto a la entidad Wallet (puedes usar AutoMapper)
            var wallet = new Wallet
            {
                DocumentId = walletDto.DocumentId,
                Name = walletDto.Name,
                Balance = walletDto.Balance,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await _walletRepository.AddAsync(wallet);
            return CreatedAtAction(nameof(Get), new { id = wallet.Id }, wallet);
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] WalletDto walletDto)
        {
            var wallet = await _walletRepository.GetByIdAsync(id);
            if (wallet == null)
                return NotFound();

            wallet.Name = walletDto.Name;
            wallet.DocumentId = walletDto.DocumentId;
            wallet.Balance = walletDto.Balance;
            wallet.UpdatedAt = DateTime.UtcNow;

            await _walletRepository.UpdateAsync(wallet);
            return NoContent();
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var wallet = await _walletRepository.GetByIdAsync(id);
            if (wallet == null)
                return NotFound();

            await _walletRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}
