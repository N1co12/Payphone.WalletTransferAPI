using Microsoft.AspNetCore.Mvc;
using WalletTransfer.Domain.Entities;
using WalletTransfer.Domain.Interfaces;
using WalletTransfer.Application.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace WalletTransfer.API.Controllers
{
    /// <summary>
    /// Controlador para gestionar las billeteras.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class WalletsController : ControllerBase
    {
        private readonly IWalletRepository _walletRepository;

        public WalletsController(IWalletRepository walletRepository)
        {
            _walletRepository = walletRepository;
        }

        /// <summary>
        /// Este metodo permite listar todas las billeteras existentes.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var wallets = await _walletRepository.GetAllAsync();
            return Ok(wallets);
        }

        /// <summary>
        /// Este metodo permite buscar una billetera mediante el id de la billetera.
        /// </summary>
        /// <param name="id">id de la billetera.</param>
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var wallet = await _walletRepository.GetByIdAsync(id);
            if (wallet == null)
                return NotFound();
            return Ok(wallet);
        }

        /// <summary>
        /// Este metodo permite crear una nueva billetera.
        /// </summary>
        /// <param name="walletDto">Datos de la billetera a crear.</param>
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

        /// <summary>
        /// Este metodo permite editar una billetera.
        /// </summary>
        /// <param name="walletDto">Datos de la billetera a editar.</param>
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

        /// <summary>
        /// Este metodo permite eliminar una billetera.
        /// </summary>
        /// <param name="id">id de la billetera</param>
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
