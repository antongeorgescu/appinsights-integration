import { Component } from '@angular/core';
import { SafeResourceUrl, DomSanitizer } from '@angular/platform-browser';

@Component({
  selector: 'embedded-browser',
  templateUrl: './browser.component.html',
  styleUrls: ['./browser.component.css']
})
export class EmbeddedBrowserComponent {
  title = 'browser-component';
  url: string = "https://mail.yahoo.ca";
  urlSafe: SafeResourceUrl | undefined;

  constructor(public sanitizer: DomSanitizer) { }

  ngOnInit() {
    this.urlSafe= this.sanitizer.bypassSecurityTrustResourceUrl(this.url);
  }
}
