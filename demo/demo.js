$(document).ready(function(){
  $('#Example1').treePicker({
    data: './sample_data.json',
    name: 'Regions',
    picked:  [120,130,140],
    onSubmit: function(nodes) {
      console.log(nodes);
    },
    displayFormat: function(picked) {
      return "Regions ("+picked.length+" picked)";
    }
  })
});
