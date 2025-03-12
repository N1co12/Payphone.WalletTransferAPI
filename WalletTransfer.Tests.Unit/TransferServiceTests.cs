using Moq;
using System;
using System.Threading.Tasks;
using WalletTransfer.Application.Services;
using WalletTransfer.Domain.Entities;
using WalletTransfer.Domain.Interfaces;
using Xunit;

namespace WalletTransfer.Tests.Unit
{
    public class TransferServiceTests
    {
        private readonly Mock<IWalletRepository> _walletRepositoryMock;
        private readonly Mock<ITransactionRepository> _transactionRepositoryMock;
        private readonly TransactionService _transactionService;

        public TransferServiceTests()
        {
            _walletRepositoryMock = new Mock<IWalletRepository>();
            _transactionRepositoryMock = new Mock<ITransactionRepository>();
            _transactionService = new TransactionService(_transactionRepositoryMock.Object, _walletRepositoryMock.Object);
        }

      
        [Fact]
        public async Task TransferAsync_WithAmountLessThanOrEqualZero()
        {
            // Arrange
            int sourceWalletId = 1;
            int destinationWalletId = 2;
            decimal amount = 0;

            // Act & Assert
            await Assert.ThrowsAsync<ArgumentException>(
                () => _transactionService.TransferAsync(sourceWalletId, destinationWalletId, amount));
        }

        [Fact]
        public async Task TransferAsync_SourceWalletNotFound()
        {
            // Arrange
            int sourceWalletId = 1;
            int destinationWalletId = 2;
            decimal amount = 50;

            _walletRepositoryMock.Setup(r => r.GetByIdAsync(sourceWalletId))
                                 .ReturnsAsync((Wallet)null);
            _walletRepositoryMock.Setup(r => r.GetByIdAsync(destinationWalletId))
                                 .ReturnsAsync(new Wallet { Id = destinationWalletId, Balance = 100 });

            // Act & Assert
            var ex = await Assert.ThrowsAsync<InvalidOperationException>(
                () => _transactionService.TransferAsync(sourceWalletId, destinationWalletId, amount));
            Assert.Equal("La billetera origen no existe.", ex.Message);
        }

        [Fact]
        public async Task TransferAsync_DestinationWalletNotFound()
        {
            // Arrange
            int sourceWalletId = 1;
            int destinationWalletId = 2;
            decimal amount = 50;

            _walletRepositoryMock.Setup(r => r.GetByIdAsync(sourceWalletId))
                                 .ReturnsAsync(new Wallet { Id = sourceWalletId, Balance = 100 });
            _walletRepositoryMock.Setup(r => r.GetByIdAsync(destinationWalletId))
                                 .ReturnsAsync((Wallet)null);

            // Act & Assert
            var ex = await Assert.ThrowsAsync<InvalidOperationException>(
                () => _transactionService.TransferAsync(sourceWalletId, destinationWalletId, amount));
            Assert.Equal("La billetera destino no existe.", ex.Message);
        }

        [Fact]
        public async Task TransferAsync_WithInsufficientFund()
        {
            // Arrange
            int sourceWalletId = 1;
            int destinationWalletId = 2;
            decimal amount = 150;

            var sourceWallet = new Wallet { Id = sourceWalletId, Balance = 100 };
            var destinationWallet = new Wallet { Id = destinationWalletId, Balance = 50 };

            _walletRepositoryMock.Setup(r => r.GetByIdAsync(sourceWalletId))
                                 .ReturnsAsync(sourceWallet);
            _walletRepositoryMock.Setup(r => r.GetByIdAsync(destinationWalletId))
                                 .ReturnsAsync(destinationWallet);

            // Act & Assert
            var ex = await Assert.ThrowsAsync<InvalidOperationException>(
                () => _transactionService.TransferAsync(sourceWalletId, destinationWalletId, amount));
            Assert.Equal("Saldo insuficiente en la billetera origen.", ex.Message);
        }

        [Fact]
        public async Task TransferAsync_SuccessfulTransfer()
        {
            // Arrange
            int sourceWalletId = 1;
            int destinationWalletId = 2;
            decimal amount = 50;

            var sourceWallet = new Wallet { Id = sourceWalletId, Balance = 100 };
            var destinationWallet = new Wallet { Id = destinationWalletId, Balance = 20 };

            _walletRepositoryMock.Setup(r => r.GetByIdAsync(sourceWalletId))
                                 .ReturnsAsync(sourceWallet);
            _walletRepositoryMock.Setup(r => r.GetByIdAsync(destinationWalletId))
                                 .ReturnsAsync(destinationWallet);
            _walletRepositoryMock.Setup(r => r.UpdateAsync(It.IsAny<Wallet>()))
                                 .Returns(Task.CompletedTask);
            _transactionRepositoryMock.Setup(r => r.AddAsync(It.IsAny<Transaction>()))
                                        .Returns(Task.CompletedTask);

            // Act
            await _transactionService.TransferAsync(sourceWalletId, destinationWalletId, amount);

            // Assert: Se actualizan los saldos correctamente
            Assert.Equal(50, sourceWallet.Balance);
            Assert.Equal(70, destinationWallet.Balance);

            // Verificar que se hayan registrado dos transacciones:
            _transactionRepositoryMock.Verify(r => r.AddAsync(
                It.Is<Transaction>(t => t.WalletId == sourceWalletId && t.Type == TransactionType.Debito && t.Amount == amount)),
                Times.Once);
            _transactionRepositoryMock.Verify(r => r.AddAsync(
                It.Is<Transaction>(t => t.WalletId == destinationWalletId && t.Type == TransactionType.Credito && t.Amount == amount)),
                Times.Once);

            // Verificar que se hayan actualizado las billeteras:
            _walletRepositoryMock.Verify(r => r.UpdateAsync(sourceWallet), Times.Once);
            _walletRepositoryMock.Verify(r => r.UpdateAsync(destinationWallet), Times.Once);
        }
    }
}
