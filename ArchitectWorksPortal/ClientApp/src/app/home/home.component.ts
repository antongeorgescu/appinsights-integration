import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

export interface ApplicationInfo {
  type: string;
  title: string;
  description: string;
  notes: string;
}
const ELEMENT_DATA: ApplicationInfo[] = [
  { type: "poc", title: 'Hydrogen', description: "jhsgdhsg", notes: 'H' },
  { type: "poc", title: 'Hydrogen', description: "jhsgdhsg", notes: 'H' },
  { type: "poc", title: 'Hydrogen', description: "jhsgdhsg", notes: 'H' }
];

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
})
export class HomeComponent {
  displayedColumns: string[] = ['type', 'title', 'description', 'notes'];
  dataSource = ELEMENT_DATA;

  //public applications: ApplicationInfo[] = [];

  //constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
  //  http.get<ApplicationInfo[]>(baseUrl + 'portalinformation').subscribe(result => {
  //    this.applications = result;
  //  }, error => console.error(error));
  //}
}

//interface ApplicationInfo {
//  type: string;
//  title: number;
//  description: number;
//  notes: string;
//}
