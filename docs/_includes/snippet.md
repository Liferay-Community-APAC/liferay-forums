{%- comment -%}
  Shows a file from _includes/snippets/ in a code block, indented to sit inside a list item.
  Usage, on its own line inside the fence: {% include snippet.md file="name" indent="    " %}
  The same file is published for download from assets/downloads/; see download.html.
{%- endcomment -%}
{%- capture nl %}
{% endcapture -%}
{%- capture body %}{% include snippets/{{ include.file }} %}{% endcapture -%}
{%- assign sep = nl | append: include.indent -%}
{{ body | rstrip | replace: nl, sep -}}