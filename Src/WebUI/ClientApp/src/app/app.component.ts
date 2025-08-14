import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NavTopMenuComponent } from './nav-top-menu/nav-top-menu.component';
import { NavSideMenuComponent } from './nav-side-menu/nav-side-menu.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavTopMenuComponent, NavSideMenuComponent],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';
}
