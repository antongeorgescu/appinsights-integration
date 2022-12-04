import { Component,ElementRef,Inject, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, throwError, Observable } from 'rxjs';
import { AppInsightsService } from '../../apm/appinsights.service';

/**
 * @title Application Performance Monitoring (APM) - Proof-of-Concept 
 */
@Component({
  selector: 'logger-to-apm',
  templateUrl: 'logger-to-apm.component.html',
  styleUrls: ['logger-to-apm.component.css'],
})
export class LoggerToApmComponent {
  public exceptionlist: Exception[] = [];
  public exlist:[] = [];
  public error?: string;
  public connectionResult?: string;
  public logfiles: FileObject[] = [];
  public uriDesignDiagram: any;
  public logsGeneratedResponse?: string;
  baseUrl?: string;
  http: HttpClient;

  selectedFile?: string;
  public logContent?: string = "";
  selectedAPM: string = "appinsights";
  selectedCase: string = "selectcase";
  show: string = "Toggle";
  selectedDoc: string = "selectdoc";

  appInsightsService?: AppInsightsService;

  isShownExceptionList = false;
  isShownDesign = false;

  casesCount: number = 0;
  interval: any;
  caseTimeoutSecs: number = 10;
  caseNo: number = 0;

  caseGeneratedInfo: string = '';

  @ViewChild('generateExCount') generateExCount?: ElementRef;
  @ViewChild('logGenerationResultRef') logGenerationResultRef?: ElementRef;
  @ViewChild('exceptionListCollapse') exceptionListRef?: ElementRef;
  @ViewChild('designCollapse') designRef?: ElementRef;
  @ViewChild('casesCount') casesCountRef?: ElementRef;
  logGenerationResultLabel?: HTMLElement;
  exceptionList?: HTMLElement;
  designContainer?: HTMLElement

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string, appInsightsService: AppInsightsService) {
    this.baseUrl = baseUrl;
    this.http = http;
    this.appInsightsService = appInsightsService;

    this.http.get<Connectivity>(this.baseUrl + 'exceptionutilities/connection').subscribe(result => {
      console.log(result.status + " at " + result.datetime);
      this.connectionResult = result.status + " at " + result.datetime;
    }, error => console.error(error));
  }

  ngOnInit() {

    this.appInsightsService?.logPageView("SOURCE*Browser*TYPE*TrackPageView*CLASS*Info*MESSAGE*SyntheticEventGeneration");

    this.logGenerationResultLabel = this.logGenerationResultRef?.nativeElement;
    this.exceptionList = this.exceptionListRef?.nativeElement;
    this.designContainer = this.designRef?.nativeElement;
    this.http.get<Exception[]>(this.baseUrl + 'exceptionutilities/extypelist/all').subscribe(result => {
      console.log(result);
      for (var i = 0; i < result.length; i++) {
        // assign this inner object to a variable for simpler property access
        var entry = result[i];
        const ex = new Exception(entry.framework,entry.code,entry.type,entry.description);
        this.exceptionlist.push(ex)
      }
    }, error => console.error(error));
    this.http.get<FileObject[]>(this.baseUrl + 'exceptionutilities/logfiles').subscribe(result => {
      console.log(result);
      for (var i = 0; i < result.length; i++) {
        // assign this inner object to a variable for simpler property access
        var entry = result[i];
        this.logfiles.push(entry)
      }
    }, error => console.error(error));
  }

  onDocumentationShow() {
    switch (this.selectedDoc) {
      case 'exceptionlist':
        this.isShownExceptionList = !this.isShownExceptionList;
        break;
      case 'appinsights':
        this.uriDesignDiagram = new URL(this.baseUrl + 'assets/images/Logger-AppInsights-POC.jpg');
        this.isShownDesign = !this.isShownDesign;
        break;
      case 'appdynamics':
        break;
    }
  }

  //event handler for the select element's change event
  onSelectDocumentationHandler(event: any) {
    this.selectedDoc = event.target.value;
  }

  //event handler for the select element's change event
  onSelectApmHandler(event: any) {
    //update the ui
    this.selectedAPM = event.target.value;
  }

  onSelect(file: string): void {
    this.logsGeneratedResponse = "";
    this.selectedFile = file;
    this.http.get<string[]>(this.baseUrl + 'exceptionutilities/logfilecontent/' + file).subscribe(result => {
      console.log(result);
      this.logContent = result.join('\r');
    }, error => console.error(error));
  }

  onSelectGenerationCaseHandler(event: any): void {
    this.selectedCase = event.target.value;
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
    this.logsGeneratedResponse = "Generating synthetic exceptions via AspNetCore ILogger configuration...";
    const valueInput = this.generateExCount?.nativeElement.value;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    this.http.get(this.baseUrl + `exceptionutilities/loggerservice/${valueInput}/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logsGeneratedResponse = 'Ok:' + result;
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`),3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logsGeneratedResponse = 'Error:' + error.message + '*' + error.error.status
    });
  }

  generateExceptionsAppInsightsInLoggerController(): void {
    this.logsGeneratedResponse = "Generating synthetic exceptions via ApplicationInsights SDK...";
    const valueInput = this.generateExCount?.nativeElement.value;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    this.http.get(this.baseUrl + `exceptionutilities/appinsightslib/${valueInput}/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logsGeneratedResponse = 'Ok:' + result;
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logsGeneratedResponse = 'Error:' + error.message + '*' + error.error.status
    });
  }

  async generateExceptionsFiltersInExceptionsController() {
    this.logsGeneratedResponse = "Generating synthetic exceptions via Exception Filters with ApplicationInsights...";
    const valueInput = this.generateExCount?.nativeElement.value;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    for (let i = 0; i < valueInput; i++) {
      this.http.get<HttpContent>(this.baseUrl + `exceptionutilities/controller/apm/${apmName}`).subscribe(result => {
        console.log(result);
        //this.logGenerationResultLabel?.style.color. = "black";
        this.logsGeneratedResponse = `[Call ${i}] ${result.content}`;
      }, error => {
        console.error(error);
        this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
        //this.logGenerationResultLabel?.style.color = "red";
        this.logsGeneratedResponse = `[Call ${i}] ${error.message}`;
      });

      await new Promise(f => setTimeout(f, 1000));
    }
  }

  generateDependencyInMetricsController(): void {
    this.logsGeneratedResponse = "Generating synthetic dependency probes with ApplicationInsights TrackDependency...";
    const valueInput = this.generateExCount?.nativeElement.value;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics";

    this.http.get<HttpContent>(this.baseUrl + `metricsutilities/serverrequests/${valueInput}/apm/${apmName}`).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logsGeneratedResponse = 'Ok:' + result.content;
    }, error => {
      console.error(error);
      this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logsGeneratedResponse = 'Error:' + error.message;
    });
  }

  async generateAvailabilityInMetricsController() {
    this.logsGeneratedResponse = "Generating synthetic dependency probes with ApplicationInsights TrackAvailability...";
    const valueInput = this.generateExCount?.nativeElement.value;

    var apmName = this.selectedAPM == "appinsights" ? "appinsights" : "appdynamics"; 

    for (let i = 0; i < valueInput; i++) {
      this.http.get<HttpContent>(this.baseUrl + `metricsutilities/availabilityprobes/apm/${apmName}`).subscribe(result => {
        console.log(result);
        //this.logGenerationResultLabel?.style.color. = "black";
        this.logsGeneratedResponse = `[Call ${i}] ${result.content}`;
      }, error => {
        console.error(error);
        this.appInsightsService?.logException(new Error(`SOURCE*Browser*TYPE*Exception*MESSAGE*${error.message}*STATUS*${error.error.status}`), 3);
        //this.logGenerationResultLabel?.style.color = "red";
        this.logsGeneratedResponse = `[Call ${i}] ${error.message}`;
      });

      await new Promise(f => setTimeout(f, 1000));
    }
  }

  async onStartTimerEventGeneration() {
    var cases: string[] = ["iloggerlogger", "appinsightslogger", "exceptionsfilters", "metricsdependencies", "metricsavailability"];
    this.casesCount = this.casesCountRef?.nativeElement.value;
    this.caseGeneratedInfo = "Started timed out random generated cases."
    for (var i = 0; i < this.casesCount; i++) {
      var inx = Math.floor(Math.random() * cases.length);
      this.selectedCase = cases[inx];
      this.caseGeneratedInfo = `Case ${i+1} for [${this.selectedCase}] initiated.`
      this.onRunEventGeneration();
      await new Promise(f => setTimeout(f, 10000));
    }
    this.caseGeneratedInfo = "Ended timed out random generated cases."
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
