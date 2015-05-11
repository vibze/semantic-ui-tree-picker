# Semantic UI Tree Picker

#### Usage example

Include plugin css and javascript files in the head after semantic-ui.
```html
<link rel="stylesheet" href="semantic.min.css" />
<link rel="stylesheet" href="semantic-ui-tree-picker.css" />

<script type="text/javascript" src="jquery.min.js"></script>
<script type="text/javascript" src="semantic.min.js"></script>
<script type="text/javascript" src="semantic-ui-tree-picker.js"></script>
```

Define container for widget. Styling is up to you.
```html
<div id="Example1"></div>

<script type="text/javascript">
  $(document).ready(function(){
    $('#Example1').treePicker({
      data: './sample_data.json', // URL for retrieving tree data
      name: 'The Menu', // Name for widget
      picked: [110,120], // Ids of pre-picked nodes
      onSubmit: function(nodes) { console.log(nodes); } // Submit callback
    })
  });
</script>
```

`data` should be formatted following this example
```json
[
  {
    "id": 1,
    "name": "Appetizers",
    "nodes": [
      {"id": 110, "name": "Jalapenos Nachos"},
      {"id": 120, "name": "Quesadilla", "nodes": [
        {"id": 121, "name": "with Cheese"},
        {"id": 122, "name": "with Beef"},
        {"id": 123, "name": "with Chiclen"}
        ]},
      {"id": 130, "name": "Toquitos Chicken or Beef"},
      {"id": 140, "name": "Chips", "nodes": [
        {"id": 141, "name": "with Cheese"},
        {"id": 142, "name": "with Cheese & Beans"}
      ]}
    ]
  },

  {
    "id": 2,
    "name": "Tacos",
    "nodes": [
      {"id": 210, "name": "Carnitas"},
      {"id": 220, "name": "Carne Asada"},
      {"id": 230, "name": "Chicken"},
      {"id": 240, "name": "Shredded Beef"},
      {"id": 250, "name": "Al Pastor"},
      {"id": 260, "name": "Crispy Potato"}
    ]
  },

  {
    "id": 3,
    "name": "Breakfast",
    "nodes": [
      {"id": 310, "name": "Huevos Rancheros"},
      {"id": 320, "name": "Machaca Plate"},
      {"id": 330, "name": "Hievos a la Mexicana"},
      {"id": 340, "name": "Chile Verde Omelette"}
    ]
  }
]
```

`onSubmit()` callback is given a single parameter, which is a list of hashes that
contain `id` and `name` keys. For example `{id: "3", name: "Breakfast"}`
