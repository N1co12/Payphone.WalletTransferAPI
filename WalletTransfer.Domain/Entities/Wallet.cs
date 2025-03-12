namespace WalletTransfer.Domain.Entities
{
    public class Wallet
    {
        public int Id { get; set; }
        public string DocumentId { get; set; }
        public string Name { get; set; }
        public decimal Balance { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public void Debit(decimal amount)
        {
            if (amount <= 0)
                throw new ArgumentException("El monto debe ser mayor que cero.");
            if (Balance < amount)
                throw new InvalidOperationException("Saldo insuficiente.");
            Balance -= amount;
            UpdatedAt = DateTime.UtcNow;
        }

        public void Credit(decimal amount)
        {
            if (amount <= 0)
                throw new ArgumentException("El monto debe ser mayor que cero.");
            Balance += amount;
            UpdatedAt = DateTime.UtcNow;
        }
    }
}
