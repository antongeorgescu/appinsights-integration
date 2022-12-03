import { Injectable, isDevMode } from '@angular/core';
import { Router } from '@angular/router';
import { ApplicationInsights } from '@microsoft/applicationinsights-web';
import { environment as environment_dev } from 'src/environments/environment';
import { environment } from 'src/environments/environment.prod';
import { AngularPlugin } from '@microsoft/applicationinsights-angularplugin-js';

@Injectable({
  providedIn: 'root'
})
export class AppInsightsService {

  instance: ApplicationInsights;

  constructor(private router: Router) {
    var angularPlugin = new AngularPlugin();
    this.instance = new ApplicationInsights({
      config: {
        instrumentationKey: isDevMode() ? environment_dev.appInsightsConnString : environment.appInsightsConnString,
        enableCorsCorrelation: true,
        enableAutoRouteTracking: true,
        extensions: [angularPlugin],
        extensionConfig: {
          [angularPlugin.identifier]: { router: this.router }
        },
      }
    });
    this.instance.loadAppInsights();
    this.instance.trackPageView();
  }

  logPageView(name?: string, url?: string) { // option to call manually
    this.instance.trackPageView({
      name: name,
      uri: url
    });
  }

  logEvent(name: string, properties?: { [key: string]: any }) {
    this.instance.trackEvent({ name: name }, properties);
  }

  logMetric(name: string, average: number, properties?: { [key: string]: any }) {
    this.instance.trackMetric({ name: name, average: average }, properties);
  }

  logException(exception: Error, severityLevel?: number) {
    this.instance.trackException({ exception: exception, severityLevel: severityLevel });
  }

  logTrace(message: string, properties?: { [key: string]: any }) {
    this.instance.trackTrace({ message: message }, properties);
  }
}
