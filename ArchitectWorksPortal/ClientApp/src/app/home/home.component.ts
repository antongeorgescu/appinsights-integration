import { Component, Inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

export interface ApplicationInfo {
  type: string;
  title: string;
  description: string;
  notes: string;
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
})
export class HomeComponent {
  displayedColumns: string[] = ['type', 'title', 'description', 'notes'];
  dataSource: ApplicationInfo[] = [];
  
  public applications: ApplicationInfo[] = [];

  baseUrl?: string;
  http: HttpClient;

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;
    this.http.get<ApplicationInfo[]>(baseUrl + 'portalutilities/applications/db').subscribe(result => {
      this.dataSource = result;
    }, error => console.error(error));
  }

  onRedirectDocumentationAppD(): void {
    const headers = new HttpHeaders()
      .append('Content-Type', 'application/json')
      .append('Access-Control-Allow-Headers', 'Content-Type')
      .append('Access-Control-Allow-Methods', 'GET')
      .append('Access-Control-Allow-Origin', '*');
    this.http.get(this.baseUrl + 'portalutilities/redirectdocumentationappd', {headers}).subscribe(result => {
      console.log(result);
      //this.logGenerationResultLabel?.style.color. = "black";
      //this.logsGeneratedResponse = 'Ok:' + result.content;
    }, error => {
      console.error(error);
      //this.logGenerationResultLabel?.style.color = "red";
      //this.logsGeneratedResponse = 'Error:' + error.message;
    });
  }
}


