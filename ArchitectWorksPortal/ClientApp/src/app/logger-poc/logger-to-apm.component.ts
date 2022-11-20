import { Component,Inject } from '@angular/core';
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
  baseUrl?: string;
  http: HttpClient;

  selectedFile?: string;
  public logContent?: string = "";

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;

    this.uriDesignDiagram = new URL(this.baseUrl + 'assets/images/Logger-with-APM-Provides-POC.jpg');

    this.http.get<Connectivity>(this.baseUrl + 'exceptionutilities/connection').subscribe(result => {
      console.log(result.status + " at " + result.datetime);
      this.connectionResult = result.status + " at " + result.datetime;
    }, error => console.error(error));
  }

  ngOnInit() {
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
    this.selectedFile = file;
    this.http.get<string[]>(this.baseUrl + 'exceptionutilities/logfilecontent/' + file).subscribe(result => {
      console.log(result);
      this.logContent = result.join('\r');
    }, error => console.error(error));
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
