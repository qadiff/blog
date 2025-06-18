---
title: 'markdown list'
description: ''
publishdate: '2025-05-24T11:09:19+09:00'
unpublishdate: '2030-05-24T11:09:19+09:00'
author: 'Kaieda'
category: 'programming'
tags: ['temporary']
CoverImg: ''
---

<!-- Sample CommonMark document demonstrating every formal element -->

Title written in Setext H1
==========================

Subtitle written in Setext H2
-----------------------------

# ATX Heading Level 1
## ATX Heading Level 2
### ATX Heading Level 3
#### ATX Heading Level 4
##### ATX Heading Level 5
###### ATX Heading Level 6

Paragraph demonstrating *emphasis* and **strong emphasis** and combined ***both***, an inline
code span `printf("hi")`, and escaping special characters like \*asterisk\* and \_underscore\_.  
We can also embed HTML entities such as &copy; and &#x1F60A; inside text.  
To copy, press <kbd>Ctrl</kbd>+<kbd>C</kbd>.

Another line in the **same paragraph**  
(the previous line ends with two spaces → this is a *hard line break*).  
This line shows that the newline above—without two trailing spaces—was a *soft line break*.

> Block quote level 1 that starts with “greater‑than” sign.  
> > Nested block quote level 2 inside it.  
> Back to level 1; note that block quotes, like other blocks, are separated by blank lines.

- Bullet list item A  
  continuing text inside the same list item to show how line breaks work.
- Bullet list item B
  - Nested bullet B‑1
    - Deeply nested bullet B‑1‑a
- Bullet list C
+ Another bullet introduced with “+”
* And one more with “*”

1. Ordered list item 1
2. Ordered list item 2 with an indented continuation  
   that still belongs to item 2.
3. Ordered list item 3

Paragraph just before a thematic break.

---

<div>
Raw HTML block: this text is inside a &lt;div&gt;.  
CommonMark allows (but does not interpret) raw block‑level HTML.
</div>

    # Indented code block (4 spaces)
    echo "Hello from an *indented* code block!"

```python
# Fenced code block with an info string
print("Hello from a fenced code block")
```

Inline link: [CommonMark Spec](https://spec.commonmark.org/0.31.2/ "Specification 0.31.2").

Reference‑style link: see [this example][ref].

Autolinks turn plain URIs into links: <https://example.com>  
and email addresses into mailto links: <info@example.com>.

Image (inline syntax):

![Kitten staring into space](https://placekitten.com/200/300 "Cute Kitten")

Escaped punctuation for literal display:  
\\\* \\_ \\` \\[ \\] \\( \\) \\< \\> \\# \\+ \\- \\! \\.

[ref]: https://example.org "Reference link destination"

~~This text is struck through~~

| Syntax | Description |
|--------|-------------|
| Header | Title |
| Paragraph | Text |

- [x] Completed task
- [ ] Incomplete task

Here is a footnote reference [^1].

Term
:   Its definition, which can span multiple lines.

[^1]: The footnote text.
