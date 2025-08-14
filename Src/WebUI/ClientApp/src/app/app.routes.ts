import { Routes } from '@angular/router';

import { CustomersComponent } from './customers/customers.component';
import { HomeComponent } from './home/home.component';
import { ProductsComponent } from './products/products.component';
import { AuthorizeGuard } from '../api-authorization/authorize.guard';

export const routes: Routes = [
    { path: '', component: HomeComponent, pathMatch: 'full' },
    { path: 'customers', component: CustomersComponent, canActivate: [AuthorizeGuard] },
    { path: 'products', component: ProductsComponent }
];