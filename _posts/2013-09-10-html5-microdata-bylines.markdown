---
layout: post
title: "Use HTML5 microdata for bylines"
author: "Matthew Caruana Galizia"
date: 2013-10-08 13:50:55
tags: html5
keywords: html5 articles semantic microdata
excerpt: Adding semantic microdata to your HTML allows the information contained within it to become machine readable, allowing Google to display bylines in search results in this case.
---

Here's how the New York Times does bylines:

```html
<nyt_byline>
	<h6 class="byline">By 
		<span 
			itemprop="author creator" 
			itemscope="" 
			itemtype="http://schema.org/Person" 
			itemid="http://topics.nytimes.com/top/reference/timestopics/people/b/peter_baker/index.html">
			<a href="http://topics.nytimes.com/top/reference/timestopics/people/b/peter_baker/index.html"
				rel="author" 
				title="More Articles by PETER BAKER">
				<span itemprop="name">PETER BAKER</span>
			</a>
		</span>
	</h6>
</nyt_byline>
```

And here's how the Guardian does it:

```html
<span
	itemscope=""
	itemprop="author"
	itemtype="http://schema.org/Person">
	<span itemprop="name">
		<a
			class="contributor"
			rel="author"
			itemprop="url"
			href="http://www.theguardian.com/profile/patrickwintour">Patrick Wintour</a>
	</span>
</span>
```

These are great examples of [microdata][microdata] in HTML5. Adding this kind of structure to your HTML allows the information contained within it to become machine readable, allowing Google to display [bylines in search results][google-rich-snippets-people], for example.

[microdata]: http://html5doctor.com/microdata/
[google-rich-snippets-people]: https://support.google.com/webmasters/answer/146646
