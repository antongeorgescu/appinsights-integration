import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

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

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    http.get<ApplicationInfo[]>(baseUrl + 'portalutilities/applications').subscribe(result => {
      this.dataSource = result;
    }, error => console.error(error));
  }
}


