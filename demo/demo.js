$(document).ready(function(){
  $('#Example1').treePicker({
    data: './sample_data.json',
    name: 'Regions',
    onSubmit: function(nodes) {
      console.log(nodes);
    }
  })
});
