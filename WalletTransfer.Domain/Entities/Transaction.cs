namespace WalletTransfer.Domain.Entities
{
    public enum TransactionType
    {
        Debito,
        Credito
    }

    public class Transaction
    {
        public int Id { get; set; }
        public int WalletId { get; set; }
        public decimal Amount { get; set; }
        public TransactionType Type { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
