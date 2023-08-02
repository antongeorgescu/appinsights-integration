import { Component, ElementRef, Inject, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, throwError, Observable } from 'rxjs';
import { AppInsightsService } from '../../apm/appinsights.service';
import { ActivatedRoute } from '@angular/router';
import { DatePipe } from '@angular/common';

/**
 * @title Application Performance Monitoring (APM) - Proof-of-Concept 
 */
@Component({
  selector: 'auto-synth-traffic',
  templateUrl: 'auto-synth-traffic.component.html',
  providers: [DatePipe]
})
export class AutoSynthTrafficComponent {

  title: string = 'Automatic Synthetic Logging Generator';
  public exceptionlist: Exception[] = [];
  public exlist:[] = [];
  public error?: string;
  public connectionResult?: string;
  public logfiles: FileObject[] = [];
  
  public logResponses: Array<string> = [];
  baseUrl?: string;
  http: HttpClient;
  
  selectedFile?: string;
  public logContent?: string = "";
  selectedAPM: string = "appinsights";
  selectedCase: string = "selectcase";
  show: string = "Toggle";
  selectedDoc: string = "selectdoc";

  appInsightsService?: AppInsightsService;

  casesCount: number = 0;
  interval: any;
  caseTimeoutSecs: number = 10;
  caseNo: number = 0;

  caseGeneratedInfo: string = '';

  count: number = 50;
  datepipe: DatePipe;

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string,
              appInsightsService: AppInsightsService,
              route: ActivatedRoute, datePipe: DatePipe)
  {
    this.baseUrl = baseUrl;
    this.http = http;
    this.appInsightsService = appInsightsService;

    this.datepipe = datePipe;
    let currentDate = new Date();
    let startDate = this.datepipe.transform(currentDate, 'yyyy-MM-dd h:mm:ss a');
    this.logResponses.push(`Automatic Syntehtic Logging Generator started at ${startDate}`)

    route.params.subscribe(params => {
      this.count = params['count'];
    });

    this.http.get<Connectivity>(this.baseUrl + 'exceptionutilities/connection').subscribe(result => {
      console.log(result.status + " at " + result.datetime);
      this.connectionResult = result.status + " at " + result.datetime;
    }, error => console.error(error));
    
  }

  ngOnInit() {

    this.onStartTimerEventGeneration();
    
  }

  async onRunEventGeneration(): Promise<void> {
    switch (this.selectedCase) {
      case 'iloggerlogger':
        this.generateExceptionsILoggerInLoggerController();
        break;
      case 'appinsightslogger':
        this.generateExceptionsAppInsightsInLoggerController();
        break;
      case 'exceptionsfilters':
        await this.generateExceptionsFiltersInExceptionsController();
        break;
      case 'metricsdependencies':
        this.generateDependencyInMetricsController();
        break;
      case 'metricsavailability':
        await this.generateAvailabilityInMetricsController();
        break;
    }
  
  }

  generateExceptionsILoggerInLoggerController(): void {
    let task = "Generating synthetic exceptions via AspNetCore ILogger configuration...";
    
    var apmName = "appinsights";
    
    this.http.get(this.baseUrl + `exceptionutilities/loggerservice/1/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logResponses.push(`${task} => Ok:` + result);
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`),3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logResponses.push(`${task} => Error:` + error.message + '*' + error.error.status);
    });
  }

  generateExceptionsAppInsightsInLoggerController(): void {
    let task = "Generating synthetic exceptions via ApplicationInsights SDK...";
    
    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    this.http.get(this.baseUrl + `exceptionutilities/appinsightslib/1/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logResponses.push(`${task} => Ok:` + result);
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logResponses.push(`${task} => Error:` + error.message + '*' + error.error.status);
    });
  }

  async generateExceptionsFiltersInExceptionsController() {
    let task = "Generating synthetic exceptions via Exception Filters with ApplicationInsights...";
    
    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";
        
    this.http.get<HttpContent>(this.baseUrl + `exceptionutilities/controller/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logResponses.push(`${task} => Ok:` + result);
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logResponses.push(`${task} => Error:` + error.message + '*' + error.error.status);
    });
    
  }

  generateDependencyInMetricsController(): void {
    let task = "Generating synthetic dependency probes with ApplicationInsights TrackDependency...";
    const valueInput = this.count;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    this.http.get<HttpContent>(this.baseUrl + `metricsutilities/serverrequests/1/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logResponses.push(`${task} => Ok:` + result);
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logResponses.push(`${task} => Error:` + error.message + '*' + error.error.status);
    });
  }

  async generateAvailabilityInMetricsController() {
    let task = "Generating synthetic dependency probes with ApplicationInsights TrackDependency...";
    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics"; 
    
    this.http.get<HttpContent>(this.baseUrl + `metricsutilities/availabilityprobes/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logResponses.push(`${task} => Ok:` + result);
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logResponses.push(`${task} => Error:` + error.message + '*' + error.error.status);
    });

  }

  async onStartTimerEventGeneration() {
    var cases: string[] = ["iloggerlogger", "appinsightslogger", "exceptionsfilters", "metricsdependencies", "metricsavailability"];
    this.casesCount = this.count;
    this.caseGeneratedInfo = "Started timed out random generated cases."
    for (var i = 0; i < this.casesCount; i++) {
      var inx = Math.floor(Math.random() * cases.length);
      this.selectedCase = cases[inx];
      this.caseGeneratedInfo = `Case ${i+1} for [${this.selectedCase}] initiated.`
      this.onRunEventGeneration();
      await new Promise(f => setTimeout(f, 10000));
    }
    this.caseGeneratedInfo = "Ended timed out random generated cases."
    let currentDate = new Date();
    let endDate = this.datepipe.transform(currentDate, 'yyyy-MM-dd h:mm:ss a');
    this.logResponses.push(`Automatic Syntehtic Logging Generator ended at ${endDate}`)

  }

  getRandomInt(max: number) {
    return Math.floor(Math.random() * max);
  }
}

class Exception {
  framework: string;
  code: string;
  type: string;
  description: string;

  constructor(framework: string, code: string, type: string, description: string) {
    this.framework = framework;
    this.code = code;
    this.type = type;
    this.description = description;
  }
}

interface FileObject {
  name: string;
  path: string;
}

interface Connectivity {
  status: string;
  datetime: string;
}

export interface HttpContent {
  content?: string;
  contentType?: string;
  statusCode?: string;
}
