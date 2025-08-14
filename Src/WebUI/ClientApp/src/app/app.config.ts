import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideClientHydration } from '@angular/platform-browser';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { HTTP_INTERCEPTORS } from '@angular/common/http';

import { routes } from './app.routes';
import { CustomersClient, ProductsClient, API_BASE_URL } from './northwind-traders-api';
import { AuthorizeInterceptor } from '../api-authorization/authorize.interceptor';
import { environment } from '../environments/environment';
import { ModalModule } from 'ngx-bootstrap/modal';
import { AppIconsModule } from './app.icons.module';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideClientHydration(),
    provideHttpClient(),
    { provide: HTTP_INTERCEPTORS, useClass: AuthorizeInterceptor, multi: true },
    { provide: API_BASE_URL, useValue: environment.apiBaseUrl },
    CustomersClient,
    ProductsClient,
    importProvidersFrom(ModalModule.forRoot(), AppIconsModule)
  ]
};