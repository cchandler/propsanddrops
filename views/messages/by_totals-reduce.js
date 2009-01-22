function(key, values, rereduce)
{
  var final_result = [];

  for(j = 0; j < values.length; j++)
  {
    var result_key = values[j][0];
    var props = 0;
    var drops = 0;


    if(values[j][1].match(/^@?props?/) != null)
    {
      props++;
    }

    if(values[j][1].match(/^@?drops?/) != null)
    {
      drops++;
    }

   final_result.push({'key' : result_key, 'props' : props, 'drops' : drops, 'totals' : props - drops})
  }


  sorted_result = final_result.sort(function(a,b){return b.totals - a.totals;})

  var limited_sorted_result = []
  for(i = 0; i < 10 && i < sorted_result.length ; i++)
  {
    limited_sorted_result.push(sorted_result[i]);
  }

return limited_sorted_result;
}