import { Component,ElementRef,Inject, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, throwError, Observable } from 'rxjs';

/**
 * @title Card with multiple sections
 */
@Component({
  selector: 'documentation',
  templateUrl: './documentation.component.html'
  
})
export class DocumentationComponent {
  baseUrl?: string;
  http: HttpClient;

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;
  }
}

