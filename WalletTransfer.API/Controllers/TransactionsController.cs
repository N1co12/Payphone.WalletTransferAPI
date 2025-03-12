﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WalletTransfer.Application.DTOs;
using WalletTransfer.Application.Services;
namespace WalletTransfer.API.Controllers
{
    /// <summary>
    /// Controlador para gestionar las transacciones.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class TransactionsController : ControllerBase
    {
        private readonly TransactionService _transactionService;

        public TransactionsController(TransactionService transactionService)
        {
            _transactionService = transactionService;
        }

        /// <summary>
        /// Este metodo permite listar todas las transacciones existentes.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var transactions = await _transactionService.GetAllTransactionsAsync();
            return Ok(transactions);
        }

        /// <summary>
        /// Este metodo permite buscar una transacción mediante el id de la transacción.
        /// </summary>
        /// <param name="id">id de la transacción.</param>
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var transaction = await _transactionService.GetTransactionByIdAsync(id);
            if (transaction == null)
                return NotFound();
            return Ok(transaction);
        }

        /// <summary>
        /// Este metodo permite registrar una nueva transacción.
        /// </summary>
        /// <param name="request">datos de la transacción</param>
        [Authorize]
        [HttpPost("transfer")]
        public async Task<IActionResult> Transfer([FromBody] TransferRequestDto request)
        {
            if (request.Amount <= 0)
                return BadRequest("El monto debe ser mayor que cero.");

            try
            {
                await _transactionService.TransferAsync(request.SourceWalletId, request.DestinationWalletId, request.Amount);
                return Ok(new { message = "Transferencia realizada exitosamente." });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }
}
