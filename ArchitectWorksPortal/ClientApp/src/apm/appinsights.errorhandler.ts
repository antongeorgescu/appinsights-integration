import { Injectable, ErrorHandler } from '@angular/core';
import { AppInsightsService } from './appinsights.service';

@Injectable()
export class ApplicationInsightsErrorHandler extends ErrorHandler {

  constructor(private appInsightsService: AppInsightsService) {
    super();
  }

  handleError(error: Error) {
    this.appInsightsService.logException(error); // Manually log exception
  }
}
