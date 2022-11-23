import { Component,ElementRef,Inject, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, throwError, Observable } from 'rxjs';

/**
 * @title Card with multiple sections
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

  @ViewChild('generateExCount') generateExCount?: ElementRef;
  @ViewChild('logGenerationResultRef') logGenerationResultRef?: ElementRef;
  logGenerationResultLabel?: HTMLElement;

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;

    this.uriDesignDiagram = new URL(this.baseUrl + 'assets/images/Logger-AppInsights-POC.jpg');

    this.http.get<Connectivity>(this.baseUrl + 'exceptionutilities/connection').subscribe(result => {
      console.log(result.status + " at " + result.datetime);
      this.connectionResult = result.status + " at " + result.datetime;
    }, error => console.error(error));
  }

  ngOnInit() {
    this.logGenerationResultLabel = this.logGenerationResultRef?.nativeElement;
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

  onSelect(file: string): void {
    this.logsGeneratedResponse = "";
    this.selectedFile = file;
    this.http.get<string[]>(this.baseUrl + 'exceptionutilities/logfilecontent/' + file).subscribe(result => {
      console.log(result);
      this.logContent = result.join('\r');
    }, error => console.error(error));
  }

  onGenerateExceptions(): void {
    this.logsGeneratedResponse = "Working hard to generate synthetic exceptions...";
    const valueInput = this.generateExCount?.nativeElement.value;
    this.http.get(this.baseUrl + 'exceptionutilities/exceptionlist/' + valueInput).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logsGeneratedResponse = 'Ok:' + result;
    }, error => {
      console.error(error);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logsGeneratedResponse = 'Error:' + error.message;
    });
  }

  onGenerateDependency(): void {
    this.logsGeneratedResponse = "Working hard to generate synthetic dependency probes...";
    const valueInput = this.generateExCount?.nativeElement.value;
    this.http.get < HttpContent>(this.baseUrl + 'metricsutilities/serverrequests/' + valueInput).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      this.logsGeneratedResponse = 'Ok:' + result.content;
    }, error => {
      console.error(error);
      //this.logGenerationResultLabel?.style.color = "red";
      this.logsGeneratedResponse = 'Error:' + error.message;
    });
  }

  async onGenerateAvailability() {
    this.logsGeneratedResponse = "Working hard to generate synthetic availability probes...";
    const valueInput = this.generateExCount?.nativeElement.value;

    for (let i = 0; i < valueInput; i++) {
      this.http.get<HttpContent>(this.baseUrl + 'metricsutilities/availabilityprobes').subscribe(result => {
        console.log(result);
        //this.logGenerationResultLabel?.style.color. = "black";
        this.logsGeneratedResponse = `[Call ${i}] Ok: + ${result.content}`;
      }, error => {
        console.error(error);
        //this.logGenerationResultLabel?.style.color = "red";
        this.logsGeneratedResponse = `[Call ${i}] Error: + ${error.message}`;
      });

      await new Promise(f => setTimeout(f, 1000));
    }
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
