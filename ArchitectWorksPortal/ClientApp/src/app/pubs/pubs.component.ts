import { Component, Inject, ViewChild, ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'pubs-db',
  templateUrl: './pubs.component.html'
})
export class PubsComponent {
  public pubs: Publication[] = [];
  @ViewChild('nameContains') nameContains?: ElementRef;
  @ViewChild('titleContains') titleContains?: ElementRef;
  baseUrl?: string;
  http: HttpClient;

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.baseUrl = baseUrl;
    this.http = http;
    http.get<Publication[]>(baseUrl + 'portalutilities/pubs/db').subscribe(result => {
      this.pubs = result;
    }, error => console.error(error));
  }

  onRunQuery() {
    var nameContains = this.nameContains?.nativeElement.value;
    var titleContains = this.titleContains?.nativeElement.value;

    if (nameContains == '') {
      nameContains = '^=^';
    }

    if (titleContains == '') {
      titleContains = '^=^';
    }

    this.http.get<Publication[]>(this.baseUrl + `portalutilities/pubs/namecontains/${nameContains}/titlecontains/${titleContains}`).subscribe(result => {
      this.pubs = result;
    }, error => console.error(error));
  }
}

interface Publication {
  author: string;
  city: string;
  state: string;
  title: string;
  type: string;
}

