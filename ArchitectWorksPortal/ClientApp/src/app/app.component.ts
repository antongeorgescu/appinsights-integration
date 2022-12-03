import { Component, isDevMode } from '@angular/core';
import { AppInsightsService } from '../apm/appinsights.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent {
  title = 'APM - Synthetic Event Generator';

  constructor(private appInsights: AppInsightsService) {
    
    //var angularPlugin = new AngularPlugin();
    //const appInsights = new ApplicationInsights({
    //  config: {
    //    connectionString: isDevMode() ? environment_dev.appInsightsConnString : environment.appInsightsConnString,
    //    extensions: [angularPlugin],
    //    extensionConfig: {
    //      [angularPlugin.identifier]: { router: this.router }
    //    },
    //    enableCorsCorrelation: true,
    //    enableAutoRouteTracking: true
    //  }
    //});
    //appInsights.loadAppInsights();
    //appInsights.trackPageView();

  }
}
