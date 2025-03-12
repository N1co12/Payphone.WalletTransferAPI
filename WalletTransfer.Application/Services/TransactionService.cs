using WalletTransfer.Domain.Entities;
using WalletTransfer.Domain.Interfaces;

namespace WalletTransfer.Application.Services
{
    public class TransactionService
    {
        private readonly ITransactionRepository _transactionRepository;
        private readonly IWalletRepository _walletRepository;

        public TransactionService(ITransactionRepository transactionRepository, IWalletRepository walletRepository)
        {
            _transactionRepository = transactionRepository;
            _walletRepository = walletRepository;
        }

        public async Task TransferAsync(int sourceWalletId, int destinationWalletId, decimal amount)
        {
            if (amount <= 0)
                throw new ArgumentException("El monto debe ser mayor que cero.");

            var sourceWallet = await _walletRepository.GetByIdAsync(sourceWalletId);
            var destinationWallet = await _walletRepository.GetByIdAsync(destinationWalletId);

            if (sourceWallet == null)
                throw new InvalidOperationException("La billetera origen no existe.");
            if (destinationWallet == null)
                throw new InvalidOperationException("La billetera destino no existe.");
            if (sourceWallet.Balance < amount)
                throw new InvalidOperationException("Saldo insuficiente en la billetera origen.");

            // Realiza la operación de débito y crédito
            sourceWallet.Debit(amount);
            destinationWallet.Credit(amount);

            // Actualiza las billeteras
            await _walletRepository.UpdateAsync(sourceWallet);
            await _walletRepository.UpdateAsync(destinationWallet);

            // Registra el movimiento de débito
            var debitTransaction = new Transaction
            {
                WalletId = sourceWalletId,
                Amount = amount,
                Type = TransactionType.Debito,
                CreatedAt = DateTime.UtcNow
            };

            // Registra el movimiento de crédito
            var creditTransaction = new Transaction
            {
                WalletId = destinationWalletId,
                Amount = amount,
                Type = TransactionType.Credito,
                CreatedAt = DateTime.UtcNow
            };

            await _transactionRepository.AddAsync(debitTransaction);
            await _transactionRepository.AddAsync(creditTransaction);
        }

        public async Task<IEnumerable<Transaction>> GetAllTransactionsAsync()
        {
            return await _transactionRepository.GetAllAsync();
        }

        public async Task<Transaction> GetTransactionByIdAsync(int id)
        {
            return await _transactionRepository.GetByIdAsync(id);
        }
    }
}
