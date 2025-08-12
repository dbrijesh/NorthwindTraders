using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Northwind.Application.Common.Interfaces;

namespace Northwind.Persistence
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration)
        {
            var useInMemoryDatabase = configuration.GetValue<bool>("UseInMemoryDatabase");
            
            if (useInMemoryDatabase)
            {
                services.AddDbContext<NorthwindDbContext>(options =>
                    options.UseInMemoryDatabase("NorthwindTraders"));
            }
            else
            {
                services.AddDbContext<NorthwindDbContext>(options =>
                    options.UseSqlServer(configuration.GetConnectionString("NorthwindDatabase")));
            }

            services.AddScoped<INorthwindDbContext>(provider => provider.GetService<NorthwindDbContext>());

            return services;
        }
    }
}
