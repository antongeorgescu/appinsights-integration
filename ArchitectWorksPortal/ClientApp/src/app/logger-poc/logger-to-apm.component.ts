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
  public error: string = "";
  public connectionResult = "";
  baseUrl: string = "";
  http: HttpClient;

  //constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
  //  http.get<Exception[]>(baseUrl + 'syntheticlogapi').subscribe(result => {
  //    this.exceptionlist = result;
  //  }, error => console.error(error));
  //}

  doc = [
    {
      "key": "NET01",
      "path": "Exceptions:netcore:NET01",
      "value": "IndexOutOfRangeException|Thrown by the runtime only when an array is indexed improperly."
    },
    {
      "key": "NET02",
      "path": "Exceptions:netcore:NET02",
      "value": "NullReferenceException|Thrown by the runtime only when a null object is referenced."
    },
    {
      "key": "NET03",
      "path": "Exceptions:netcore:NET03",
      "value": "InvalidOperationException|Thrown by methods when in an invalid state."
    },
    {
      "key": "NET04",
      "path": "Exceptions:netcore:NET04",
      "value": "ArgumentNullException|Thrown by methods that do not allow an argument to be null."
    },
    {
      "key": "NET05",
      "path": "Exceptions:netcore:NET05",
      "value": "ArgumentOutOfRangeException|Thrown by methods that verify that arguments are in a given range."
    }
  ];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;

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
      }}, error => console.error(error));
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

interface Connectivity {
  status: string;
  datetime: string;
}
