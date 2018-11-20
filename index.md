---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

<ul>
{% for sample in site.data.excelsamples %}
<li>{{sample.FirstName}}</li>
{% endfor %}
</ul>