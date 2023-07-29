import { BrowserModule } from '@angular/platform-browser';
import { NgModule, ErrorHandler } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';

import { AppComponent } from './app.component';
import { NavMenuComponent } from './nav-menu/nav-menu.component';
import { HomeComponent } from './home/home.component';
import { CounterComponent } from './counter/counter.component';
import { FetchDataComponent } from './fetch-data/fetch-data.component';
import { PubsComponent } from './pubs/pubs.component';
import { LoggerToApmComponent } from './logger-to-apm/logger-to-apm.component';
import { EmbeddedBrowserComponent } from './embedded-browser/browser.component';
import { DocumentationComponent } from './documentation/documentation.component';
import { DemoMaterialModule } from './ng.material.module';
//import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from '@angular/material/form-field';
import { MatNativeDateModule } from '@angular/material/core';
import { MdbCollapseModule } from 'mdb-angular-ui-kit/collapse';
import { ApplicationinsightsAngularpluginErrorService } from '@microsoft/applicationinsights-angularplugin-js';
import { ApplicationInsightsErrorHandler } from '../apm/appinsights.errorhandler';

@NgModule({
  declarations: [
    AppComponent,
    NavMenuComponent,
    HomeComponent,
    CounterComponent,
    FetchDataComponent,
    PubsComponent,
    LoggerToApmComponent,
    DocumentationComponent,
    EmbeddedBrowserComponent
  ],
  imports: [
    BrowserModule.withServerTransition({ appId: 'ng-cli-universal' }),
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    DemoMaterialModule,
    MatNativeDateModule,
    MdbCollapseModule,
    RouterModule.forRoot([
      { path: '', component: HomeComponent, pathMatch: 'full' },
      { path: 'counter', component: CounterComponent },
      { path: 'fetch-data', component: FetchDataComponent },
      { path: 'logger-to-apm', component: LoggerToApmComponent },
      { path: 'pubs', component: PubsComponent },
      { path: 'documentation', component: DocumentationComponent },
      { path: 'embedded-browser', component: EmbeddedBrowserComponent },
    ])
  ],
  providers: [
    {
      provide: ErrorHandler,
      useClass: ApplicationinsightsAngularpluginErrorService
      //useClass: ApplicationInsightsErrorHandler
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
