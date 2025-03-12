using Microsoft.EntityFrameworkCore;
using WalletTransfer.Domain.Entities;

namespace WalletTransfer.Infrastructure.Data
{
    public class AppDbContext: DbContext
    {
        public DbSet<Wallet> Wallets { get; set; }
        public DbSet<Transaction> Transactions { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configuraciones adicionales (por ejemplo, relaciones, restricciones, etc.)
            base.OnModelCreating(modelBuilder);
        }
    }
}
