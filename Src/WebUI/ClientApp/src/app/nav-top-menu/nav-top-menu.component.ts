import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { LoginMenuComponent } from '../../api-authorization/login-menu/login-menu.component';

@Component({
  selector: 'app-nav-top-menu',
  standalone: true,
  imports: [RouterLink, LoginMenuComponent],
  templateUrl: './nav-top-menu.component.html'
})
export class NavTopMenuComponent {
}
