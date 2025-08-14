import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductsClient, ProductsListVm } from '../northwind-traders-api';

@Component({
  standalone: true,
  imports: [CommonModule],
  templateUrl: './products.component.html'
})
export class ProductsComponent {

  productsListVm: ProductsListVm = new ProductsListVm();

  constructor(client: ProductsClient) {
    client.getAll().subscribe(result => {
      this.productsListVm = result;
    }, error => console.error(error));
  }
}
