import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { FeatherModule } from 'angular-feather';

@Component({
  selector: 'app-nav-side-menu',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, FeatherModule],
  templateUrl: './nav-side-menu.component.html'
})
export class NavSideMenuComponent {
}
