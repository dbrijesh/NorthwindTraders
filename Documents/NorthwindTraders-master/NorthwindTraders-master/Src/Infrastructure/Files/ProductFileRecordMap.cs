using System.Globalization;
using CsvHelper.Configuration;
using Northwind.Application.Products.Queries.GetProductsFile;

namespace Northwind.Infrastructure.Files
{
    public sealed class ProductFileRecordMap : ClassMap<ProductRecordDto>
    {
        public ProductFileRecordMap()
        {
            AutoMap(CultureInfo.InvariantCulture);
            Map(m => m.UnitPrice).Name("Unit Price").Convert(args => (args.Value.UnitPrice ?? 0).ToString("C"));
        }
    }
}
